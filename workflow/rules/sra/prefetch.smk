rule prefetch:
    conda:
        "../../envs/sra-tools.yaml"
    retries: config["retries_prefetch"]
    output:
        sra=update("{sample}/{sample}.sra"),
    resources:
        n_prefetch=1,
    log:
        "logs/{sample}/prefetch.log",
    shell:
        """
        prefetch \\
            -p \\
            -r yes \\
            -C yes \\
            -O ./ \\
            --max-size u \\
            {wildcards.sample} \\
            1> {log} 2>&1
        """
