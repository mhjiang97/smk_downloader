rule pigz_paired_end:
    input:
        fq_1=f"{{sample}}{SUFFIXES_SRA_1}",
        fq_2=f"{{sample}}{SUFFIXES_SRA_2}",
    output:
        fq_1=protected(f"{{sample}}{SUFFIX_READ_1}"),
        fq_2=protected(f"{{sample}}{SUFFIX_READ_2}"),
    log:
        "logs/{sample}/pigz_paired_end.log",
    conda:
        "../../envs/pigz.yaml"
    threads: 1
    params:
        layout=get_library_layout,
    script:
        "../../scripts/pigz.sh"


rule pigz_single_end:
    input:
        fq=f"{{sample}}{SUFFIX_SRA_SE}",
    output:
        fq=protected(f"{{sample}}{SUFFIX_READ_SE}"),
    log:
        "logs/{sample}/pigz_single_end.log",
    conda:
        "../../envs/pigz.yaml"
    threads: 1
    params:
        layout=get_library_layout,
    script:
        "../../scripts/pigz.sh"
