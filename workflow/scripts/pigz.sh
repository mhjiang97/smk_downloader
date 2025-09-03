#!/usr/bin/env bash
# shellcheck disable=SC2154

set -x

{ sample=${snakemake_wildcards[sample]}
layout=${snakemake_params[layout]}
threads=${snakemake[threads]}

if [ "${layout}" == "paired-end" ]; then
    fq_1=${snakemake_input[fq_1]}
    fq_2=${snakemake_input[fq_2]}
    out_fq_1=${snakemake_output[fq_1]}
    out_fq_2=${snakemake_output[fq_2]}
elif [ "${layout}" == "single-end" ]; then
    fq=${snakemake_input[fq]}
    out_fq=${snakemake_output[fq]}
else
    echo "$(date +"%Y-%m-%d %H:%M:%S") [ERROR] Unexpected layout: ${layout}"
    exit 1
fi


if [ "${layout}" == "paired-end" ]; then
    pigz -p "${threads}" -c "${fq_1}" > "${out_fq_1}"
    pigz -p "${threads}" -c "${fq_2}" > "${out_fq_2}"

    if [ -f "${sample}".fastq ]; then
        pigz -p "${threads}" "${sample}".fastq
    fi
else
    pigz -p "${threads}" -c "${fq}" > "${out_fq}"
fi; } \
1> "${snakemake_log[0]}" 2>&1
