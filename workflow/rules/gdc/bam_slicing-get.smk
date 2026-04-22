rule bam_slicing_get:
    input:
        bed=lambda wildcards: DF_SAMPLE["region_bed"][wildcards.sample],
    output:
        bam=protected("bam_slicing/{sample}/{sample}.bam"),
    log:
        "logs/{sample}/bam_slicing_get.log",
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
        {{ regions=$(awk 'NF >= 3 {{print $1":"$2"-"$3}}' {input.bed} | sed 's/^/region=/' | paste -sd '&')

        curl \\
            --header "X-Auth-Token: {params.token}" \\
            "{params.api}/{params.uuid}?${{regions}}" \\
            --output {output.bam} ; }} \\
        1> {log} 2>&1
        """
