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


rule fastqc:
    input:
        unpack(get_fastqc_inputs),
    output:
        dir=directory("fastqc/{sample}"),
    threads: 1
    log:
        "logs/{sample}/fastqc.log",
    script:
        "../scripts/fastqc.sh"


rule multiqc:
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
