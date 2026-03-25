rule fastqc:
    input:
        unpack(get_fastqc_inputs),
    output:
        dir=directory("fastqc/{sample}"),
    log:
        "logs/{sample}/fastqc.log",
    conda:
        "../../envs/fastqc.yaml"
    threads: 1
    params:
        layout=get_library_layout,
    script:
        "../../scripts/fastqc.sh"


rule multiqc:
    input:
        fastqcs=expand("fastqc/{sample}", sample=SAMPLES),
    output:
        dir=directory("multiqc"),
        html="multiqc/multiqc_report.html",
    log:
        "logs/multiqc.log",
    conda:
        "../../envs/multiqc.yaml"
    shell:
        """
        multiqc -o {output.dir} --force {input.fastqcs} 1> {log} 2>&1
        """
