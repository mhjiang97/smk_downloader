rule bam_slicing_post:
    input:
        bed=lambda wildcards: DF_SAMPLE["region_bed"][wildcards.sample],
    output:
        json="bam_slicing/{sample}/regions.json",
        bam=protected("bam_slicing/{sample}/{sample}.bam"),
    log:
        "logs/{sample}/bam_slicing_post.log",
    retries: config["retries_gdc"]
    conda:
        "../../envs/jq.yaml"
    resources:
        n_curl=1,
    params:
        token=os.environ["GDC_TOKEN"],
        api="https://api.gdc.cancer.gov/slicing/view",
        uuid=lambda wildcards: DF_SAMPLE["uuid"][wildcards.sample],
    shell:
        """
        {{ awk 'NF >= 3 {{print $1":"$2"-"$3}}' {input.bed} \\
            | jq \\
                -R \\
                -s \\
                'split("\\n") | map(select(length > 0)) | {{"regions": .}}' \\
            > {output.json}

        curl \\
            --header "X-Auth-Token: {params.token}" \\
            --request POST {params.api}/{params.uuid} \\
            --header "Content-Type: application/json" -d@{output.json} \\
            --output {output.bam} ; }} \\
        1> {log} 2>&1
        """
