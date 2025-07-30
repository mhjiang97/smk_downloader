#!/usr/bin/env bash
# shellcheck disable=SC2154

set -x


{ sample=${snakemake_wildcards[sample]}
layout=${snakemake_params[layout]}

if [ "${layout}" == "paired-end" ]; then
    fq_1=${snakemake_output[fq_1]}
    fq_2=${snakemake_output[fq_2]}
    fq_1_renamed=${snakemake_output[fq_1_renamed]}
    fq_2_renamed=${snakemake_output[fq_2_renamed]}
elif [ "${layout}" == "single-end" ]; then
    fq=${snakemake_output[fq]}
    fq_renamed=${snakemake_output[fq_renamed]}
else
    echo "$(date +"%Y-%m-%d %H:%M:%S") [ERROR] Unexpected number of outputs: ${snakemake_output[*]}"
    exit 1
fi

if [ "${layout}" == "paired-end" ] && [ -s "${fq_1}" ] && [ -s "${fq_2}" ] && [ -h "${fq_1_renamed}" ] && [ -h "${fq_2_renamed}" ]; then
    echo "$(date +"%Y-%m-%d %H:%M:%S") [INFO] ${sample} already exists."
    exit 0
elif [ "${layout}" == "single-end" ] && [ -s "${fq}" ] && [ -h "${fq_renamed}" ]; then
    echo "$(date +"%Y-%m-%d %H:%M:%S") [INFO] ${sample} already exists."
    exit 0
fi

prefetch -p -r yes -C yes -O ./ --max-size u "${sample}"

fasterq-dump ./"${sample}"

if [ "${layout}" == "paired-end" ]; then
    pigz "${sample}"_1.fastq "${sample}"_2.fastq

    mv "${sample}"_1.fastq.gz "${sample}"/
    mv "${sample}"_2.fastq.gz "${sample}"/

    ln -s "${fq_1}" "${fq_1_renamed}"
    ln -s "${fq_2}" "${fq_2_renamed}"

    if [ -f "${sample}".fastq ]; then
        pigz "${sample}".fastq
        mv "${sample}".fastq.gz "${sample}"/
    fi
else
    pigz "${sample}".fastq
    mv "${sample}".fastq.gz "${sample}"/
    ln -s "${fq}" "${fq_renamed}"
fi; } \
1> "${snakemake_log[0]}" 2>&1
