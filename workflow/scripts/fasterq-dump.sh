#!/usr/bin/env bash
# shellcheck disable=SC2154

set -x

{ sample=${snakemake_wildcards[sample]}
dir=${snakemake_params[dir]}
layout=${snakemake_params[layout]}
threads=${snakemake[threads]}

if [ "${layout}" == "paired-end" ]; then
    fq_1=${snakemake_output[fq_1]}
    fq_2=${snakemake_output[fq_2]}
elif [ "${layout}" == "single-end" ]; then
    fq=${snakemake_output[fq]}
else
    echo "$(date +"%Y-%m-%d %H:%M:%S") [ERROR] Unexpected layout: ${layout}"
    exit 1
fi

if [ "${layout}" == "paired-end" ] && [ -s "${fq_1}" ] && [ -s "${fq_2}" ]; then
    echo "$(date +"%Y-%m-%d %H:%M:%S") [INFO] ${sample} already exists."
    exit 0
elif [ "${layout}" == "single-end" ] && [ -s "${fq}" ]; then
    echo "$(date +"%Y-%m-%d %H:%M:%S") [INFO] ${sample} already exists."
    exit 0
fi

fasterq-dump --threads "${threads}" "${dir}"; } \
1> "${snakemake_log[0]}" 2>&1
