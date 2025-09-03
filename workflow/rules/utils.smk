def get_targets():
    targets = []

    targets += [
        f"{sample}{suffix}" for sample in SAMPLES_PE for suffix in SUFFIXES_READ_PE
    ]
    targets += [f"{sample}/{sample}{SUFFIX_READ_SE}" for sample in SAMPLES_SE]

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
            "fq_1": f"{{sample}}{SUFFIX_READ_1}",
            "fq_2": f"{{sample}}{SUFFIX_READ_2}",
        }
    elif sample in SAMPLES_SE:
        return {"fq": f"{{sample}}{SUFFIX_READ_SE}"}
    else:
        raise ValueError(f"Sample {sample} not found in SAMPLES_PE or SAMPLES_SE.")
