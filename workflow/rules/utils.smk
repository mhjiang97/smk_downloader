def get_targets():
    targets = []

    targets += [
        f"{sample}/{sample}{suffix}"
        for sample in SAMPLES_PE
        for suffix in SUFFIXES_SRA_PE
    ]
    targets += [f"{sample}/{sample}{SUFFIX_SRA_SE}" for sample in SAMPLES_SE]

    if TO_RUN_FASTQC:
        targets += [f"fastqc/{sample}" for sample in SAMPLES]
        if TO_RUN_MULTIQC:
            targets += ["multiqc/multiqc_report.html"]

    return targets


def get_library_layout(wildcards):
    sample = wildcards.sample
    layout = DF_SAMPLE["library_layout"][sample]

    if layout not in ["paired-end", "single-end"]:
        raise ValueError(f"Unexpected library layout '{layout}' for sample '{sample}'.")

    return layout


def get_fastqc_inputs(wildcards):
    sample = wildcards.sample

    if sample in SAMPLES_PE:
        return {
            "fq_1": "{sample}/{sample}_1.fastq.gz",
            "fq_2": "{sample}/{sample}_2.fastq.gz",
        }
    elif sample in SAMPLES_SE:
        return {"fq": "{sample}/{sample}.fastq.gz"}
    else:
        raise ValueError(f"Sample {sample} not found in SAMPLES_PE or SAMPLES_SE.")
