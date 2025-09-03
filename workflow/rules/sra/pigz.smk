rule pigz_paired_end:
    conda:
        "../../envs/pigz.yaml"
    input:
        fq_1=f"{{sample}}{SUFFIXES_SRA_1}",
        fq_2=f"{{sample}}{SUFFIXES_SRA_2}",
    output:
        fq_1=f"{{sample}}{SUFFIX_READ_1}",
        fq_2=f"{{sample}}{SUFFIX_READ_2}",
    params:
        layout=get_library_layout,
    threads: 1
    log:
        "logs/{sample}/pigz_paired_end.log",
    script:
        "../../scripts/pigz.sh"


rule pigz_single_end:
    conda:
        "../../envs/pigz.yaml"
    input:
        fq=f"{{sample}}{SUFFIX_SRA_SE}",
    output:
        fq=f"{{sample}}{SUFFIX_READ_SE}",
    params:
        layout=get_library_layout,
    threads: 1
    log:
        "logs/{sample}/pigz_single_end.log",
    script:
        "../../scripts/pigz.sh"
