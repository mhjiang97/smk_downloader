rule gdc_slicing_post:
    conda:
        "../../envs/jq.yaml"
    retries: config["retries_gdc"]
    input:
        bed=lambda wildcards: DF_SAMPLE["region_bed"][wildcards.sample],
        token=config["token_gdc"],
    output:
        json="gdc_slicing/{sample}/regions.json",
        bam=protected("gdc_slicing/{sample}/{sample}.bam"),
    params:
        api="https://api.gdc.cancer.gov/slicing/view",
        uuid=lambda wildcards: DF_SAMPLE["uuid"][wildcards.sample],
    resources:
        n_curl=1,
    log:
        "logs/{sample}/gdc_slicing_post.log",
    shell:
        """
        {{ token=$(<{input.token})

        awk 'NF >= 3 {{print $1":"$2"-"$3}}' {input.bed} \\
            | jq \\
                -R \\
                -s \\
                'split("\\n") | map(select(length > 0)) | {{"regions": .}}' \\
            > {output.json}

        curl \\
            --header "X-Auth-Token: ${{token}}" \\
            --request POST {params.api}/{params.uuid} \\
            --header "Content-Type: application/json" -d@{output.json} \\
            --output {output.bam} ; }} \\
        1> {log} 2>&1
        """
