rule fasterq_dump_paired_end:
    conda:
        "../../envs/sra-tools.yaml"
    input:
        sra="{sample}/{sample}.sra",
    output:
        fq_1=temp(f"{{sample}}{SUFFIXES_SRA_1}"),
        fq_2=temp(f"{{sample}}{SUFFIXES_SRA_2}"),
    params:
        dir="./{sample}",
        layout=get_library_layout,
    threads: 1
    log:
        "logs/{sample}/fasterq_dump_paired_end.log",
    script:
        "../../scripts/fasterq-dump.sh"


rule fasterq_dump_single_end:
    conda:
        "../../envs/sra-tools.yaml"
    input:
        sra="{sample}/{sample}.sra",
    output:
        fq=temp(f"{{sample}}{SUFFIX_SRA_SE}"),
    params:
        dir="./{sample}",
        layout=get_library_layout,
    threads: 1
    log:
        "logs/{sample}/fasterq_dump_single_end.log",
    script:
        "../../scripts/fasterq-dump.sh"
