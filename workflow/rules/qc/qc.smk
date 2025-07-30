rule fastqc:
    conda:
        "../../envs/fastqc.yaml"
    input:
        unpack(get_fastqc_inputs),
    output:
        dir=directory("fastqc/{sample}"),
    params:
        layout=get_library_layout,
    threads: 1
    log:
        "logs/{sample}/fastqc.log",
    script:
        "../../scripts/fastqc.sh"


rule multiqc:
    conda:
        "../../envs/multiqc.yaml"
    input:
        fastqcs=expand("fastqc/{sample}", sample=SAMPLES),
    output:
        dir=directory("multiqc"),
        html="multiqc/multiqc_report.html",
    log:
        "logs/multiqc.log",
    shell:
        """
        multiqc -o {output.dir} --force {input.fastqcs} 1> {log} 2>&1
        """
