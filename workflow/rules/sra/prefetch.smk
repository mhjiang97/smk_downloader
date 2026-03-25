rule prefetch:
    output:
        sra=ensure(update("{sample}/{sample}.sra"), non_empty=True),
    log:
        "logs/{sample}/prefetch.log",
    retries: config["retries_prefetch"]
    conda:
        "../../envs/sra-tools.yaml"
    resources:
        n_prefetch=1,
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
