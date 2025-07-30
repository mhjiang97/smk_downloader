rule download_sra_paired_end:
    priority: 10
    conda:
        "../../envs/sra-tools.yaml"
    retries: config["retries_sra"]
    output:
        sra=protected(update("{sample}/{sample}.sra")),
        fq_1=protected(update(f"{{sample}}/{{sample}}{SUFFIXES_SRA_1}")),
        fq_2=protected(update(f"{{sample}}/{{sample}}{SUFFIXES_SRA_2}")),
        fq_1_renamed=f"{{sample}}{SUFFIX_READ_1}",
        fq_2_renamed=f"{{sample}}{SUFFIX_READ_2}",
    params:
        layout=get_library_layout,
    resources:
        n_instance=1,
    log:
        "logs/{sample}/download_sra_paired_end.log",
    script:
        "../../scripts/sra.sh"


rule download_sra_single_end:
    priority: 10
    conda:
        "../../envs/sra-tools.yaml"
    retries: config["retries_sra"]
    output:
        sra=protected(update("{sample}/{sample}.sra")),
        fq=protected(update(f"{{sample}}/{{sample}}{SUFFIX_SRA_SE}")),
        fq_renamed=f"{{sample}}{SUFFIX_READ_SE}",
    params:
        layout=get_library_layout,
    resources:
        n_instance=1,
    log:
        "logs/{sample}/download_sra_single_end.log",
    script:
        "../../scripts/sra.sh"
