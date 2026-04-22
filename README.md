<!-- markdownlint-configure-file {"no-inline-html": {"allowed_elements": ["code", "details", "h2", "summary"]}} -->

# SMK_DOWNLOADER

![License GPLv3](https://img.shields.io/badge/License-GPLv3-blue.svg)

A Snakemake workflow for downloading public raw sequencing data

## Supported Data Sources

- [**SRA**](https://www.ncbi.nlm.nih.gov/sra)
- [**GDC**](https://docs.gdc.cancer.gov/API/Users_Guide/BAM_Slicing/)

<details>

<summary><h2>Recommended Project Structure</h2></summary>

```text
projects/
├── data/
│   ├── code/
│   │   └── smk_downloader/     # This workflow
│   └── sra/
│       └── PRJNA*/             # SRA download outputs
│           ├── fastq/          # Raw FASTQ files
│           ├── fastqc/         # Quality control reports
│           └── multiqc/        # Aggregated QC reports
└── tcga/
    └── analysis/
        └── [wgs/wes/rnaseq]/
            └── [brca/...]/
                └── bam_slicing/    # GDC BAM slicing outputs
```

</details>

## Prerequisites

- [**Python**](https://www.python.org)
- [**Snakemake**](https://snakemake.github.io)
- [**eido**](https://pep.databio.org/eido/)
- [**Mamba**](https://mamba.readthedocs.io/en/latest/) (recommended) or [**conda**](https://docs.conda.io/projects/conda/en/stable/)

Additional dependencies are automatically installed by **Mamba** or **conda**. Environments are defined in yaml files under `workflow/envs/`.

- [**sra-tools**](https://github.com/ncbi/sra-tools)
- [**FastQC**](https://www.bioinformatics.babraham.ac.uk/projects/fastqc/)
- [**MultiQC**](https://multiqc.info/)
- [**jq**](https://jqlang.org)
- [**curl**](https://curl.se)

## Setup

```shell
# ---------------------------------------------------------------------------- #
# Install Mamba if necessary                                                   #
# ---------------------------------------------------------------------------- #
if ! command -v mamba &> /dev/null; then
    "${SHELL}" <(curl -L micro.mamba.pm/install.sh)
    source ~/.bashrc
fi

# Install Snakemake and eido using pipx (https://pipx.pypa.io/stable/)
pipx install snakemake
pipx inject snakemake eido

# Clone the repository
git clone https://github.com/mhjiang97/smk_downloader.git
cd smk_downloader/

# Initialize configuration
cp config/.config.yaml config/config.yaml
cp config/pep/.config.yaml config/pep/config.yaml
cp workflow/profiles/default/.config.yaml workflow/profiles/default/config.yaml
```

## Configuration

### Main Configuration

<details>

<summary>Edit <code>config/config.yaml</code></summary>

```yaml
dir_run: /projects/data/sra/PRJNAxxx    # Path to the directory where data will be downloaded (Optional)

source_download: sra                    # Data source to download from (`sra` or `gdc`) (Default: `sra`)

method_gdc: post                        # HTTP method for GDC BAM slicing (`get` or `post`) (Default: `post`)

retries_prefetch: 1                     # How many times to retry downloading SRA data (Default: 1)
retries_gdc: 1                          # How many times to retry downloading GDC data (Default: 1)

suffixes_fastq_renamed:                 # Suffixes for renamed FASTQ files (Defaults: {paired-end: ["_R1.fq.gz", "_R2.fq.gz"], single-end: ".fq.gz"})
  paired-end:
    - "_R1.fq.gz"
    - "_R2.fq.gz"
  single-end: ".fq.gz"

run_fastqc: true                        # Whether to run FastQC on downloaded FASTQ files (Default: true)
run_multiqc: true                       # Whether to run MultiQC on FastQC reports (Default: true)
```

</details>

All default values are defined in the validation schema (`workflow/schemas/config.schema.yaml`).

### Execution Profile

<details>

<summary>Edit <code>workflow/profiles/default/config.yaml</code></summary>

```yaml
software-deployment-method:
  - conda
conda-prefix: /.snakemake/envs/smk_downloader
scheduler: greedy
printshellcmds: True
keep-incomplete: True
prioritize:
  - pigz_paired_end
  - pigz_single_end
cores: 20
resources:
  n_prefetch: 5
  n_curl: 5
set-threads:
  fastqc: 4
  fasterq_dump_paired_end: 10
  fasterq_dump_single_end: 10
  pigz_paired_end: 10
  pigz_single_end: 10
set-resources:
  prefetch:
    n_prefetch: 1
  gdc_slicing_post:
    n_curl: 1
  gdc_slicing_get:
    n_curl: 1
```

</details>

### Sample Metadata

This workflow uses [**Portable Encapsulated Projects (PEP)**](https://pep.databio.org/) for sample management.

<details>

<summary>Edit <code>config/pep/config.yaml</code></summary>

```yaml
pep_version: 2.1.0
sample_table: PRJNAxxx.csv    # Path to the sample table (Required)
```

</details>

#### SRA

If downloading from **SRA**, the sample table must include these mandatory columns:

| **sample_name**                   | **library_layout**                                     |
| --------------------------------- | ------------------------------------------------------ |
| Unique identifier for each sample | Sequencing strategy (`"paired-end"` or `"single-end"`) |

#### GDC

If downloading from **GDC**, the sample table must include these mandatory columns:

| **sample_name**                   | **uuid**                         | **region_bed**   |
| --------------------------------- | -------------------------------- | ---------------- |
| Unique identifier for each sample | UUID of the BAM file to download | Regions to slice |

Validation schema (`workflow/schemas/pep.schema.yaml` and `workflow/schemas/pep.gdc.schema.yaml`) ensures that the sample table meets the required format.

## Execution

```shell
# Create environments
snakemake --conda-create-envs-only

# If using GDC BAM slicing, set the environment variable for the GDC token (replace with the actual path to your token file)
export GDC_TOKEN=$(< /path/to/gdc_token)

# Run the workflow
snakemake
```

## Output

All downloaded data is organized in the directory specified as *dir_run* in your configuration (or in the `workflow/` if *dir_run* is unset).

<details>

<summary>Main results</summary>

- **fastqc/**
  - Raw reads: `{sample}/{sample}[_1/_2]_fastqc.html`
  - Trimmed reads: `fastp/{sample}/{sample}[_1/_2]_fastqc.html`

- **multiqc/**
  - Summary: `multiqc_report.html`

- **{sample}/**
  - Raw SRA archive files: `{sample}.sra`

- **{sample}.fq.gz** *or* **{sample}_R1.fq.gz**, **{sample}_R2.fq.gz**
  - Extracted, pigzipped, and renamed single-end reads *or* paired-end reads

- **bam_slicing/**
  - Sliced BAM files: `{sample}/{sample}.bam`

</details>

## License

The code in this repository is licensed under the [GNU General Public License v3](http://www.gnu.org/licenses/gpl-3.0.html).
