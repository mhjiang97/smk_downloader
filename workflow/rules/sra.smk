rule download_sra_paired_end:
    priority: 10
    retries: config["retries_sra"]
    output:
        sra=protected(update("{sample}/{sample}.sra")),
        fq_1=protected(update("{sample}/{sample}_1.fastq.gz")),
        fq_2=protected(update("{sample}/{sample}_2.fastq.gz")),
        fq_1_renamed="{sample}%s" % SUFFIX_READ_1,
        fq_2_renamed="{sample}%s" % SUFFIX_READ_2,
    log:
        "logs/{sample}/download_sra_paired_end.log",
    script:
        "../scripts/sra.sh"


rule download_sra_single_end:
    priority: 10
    retries: config["retries_sra"]
    output:
        sra=protected(update("{sample}/{sample}.sra")),
        fq=protected(update("{sample}/{sample}.fastq.gz")),
        fq_renamed="{sample}%s" % SUFFIX_READ_SE,
    log:
        "logs/{sample}/download_sra_single_end.log",
    script:
        "../scripts/sra.sh"
