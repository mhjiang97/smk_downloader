rule fasterq_dump_paired_end:
    input:
        sra="{sample}/{sample}.sra",
    output:
        fq_1=temp(f"{{sample}}{SUFFIXES_SRA_1}"),
        fq_2=temp(f"{{sample}}{SUFFIXES_SRA_2}"),
    log:
        "logs/{sample}/fasterq_dump_paired_end.log",
    conda:
        "../../envs/sra-tools.yaml"
    threads: 1
    params:
        dir="./{sample}",
        layout=get_library_layout,
    script:
        "../../scripts/fasterq-dump.sh"


rule fasterq_dump_single_end:
    input:
        sra="{sample}/{sample}.sra",
    output:
        fq=temp(f"{{sample}}{SUFFIX_SRA_SE}"),
    log:
        "logs/{sample}/fasterq_dump_single_end.log",
    conda:
        "../../envs/sra-tools.yaml"
    threads: 1
    params:
        dir="./{sample}",
        layout=get_library_layout,
    script:
        "../../scripts/fasterq-dump.sh"
