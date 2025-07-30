<!-- markdownlint-configure-file {"no-inline-html": {"allowed_elements": ["code", "details", "h2", "summary"]}} -->

# SMK_DOWNLOADER

![License GPLv3](https://img.shields.io/badge/License-GPLv3-blue.svg)

A Snakemake workflow for downloading public raw sequencing data

## Supported Data Sources

- [**SRA**](https://www.ncbi.nlm.nih.gov/sra)

<details>

<summary><h2>Recommended Project Structure</h2></summary>

```text
data/
├── sra/
│   └── PRJNA*/            # Data organized by BioProject
│       ├── SRR*/          # Individual SRA entries
│       │   ├── SRR*.sra           # Raw SRA files
│       │   ├── SRR*.fastq.gz      # Single-end reads
|       │   ├── SRR*_1.fastq.gz    # Paired-end forward reads
│       │   └── SRR*_2.fastq.gz    # Paired-end reverse reads
│       ├── SRR*.fq.gz             # Symbolic links (single-end)
|       ├── SRR*_R1.fq.gz          # Symbolic links (paired-end forward)
│       ├── SRR*_R2.fq.gz          # Symbolic links (paired-end reverse)
│       ├── fastqc/                # QC reports
│       └── multiqc/               # Aggregated QC reports
└── code/
    └── smk_downloader/    # This workflow
```

</details>

## Setup

```shell
# Install Snakemake and eido using pipx (https://pipx.pypa.io/stable/)
pipx install snakemake
pipx inject snakemake eido

# Clone the repository
git clone https://github.com/mhjiang97/smk_downloader.git
cd smk_downloader/

# Initialize configuration
cp config/.config.yaml config/config.yaml
cp config/pep/.config.yaml config/pep/config.yaml
```

## Configuration

### Main Configuration

<details>

<summary>Edit <code>config/config.yaml</code></summary>

```yaml
retries_sra: 1
dir_run: /home/user/projects/data
suffixes_fastq_renamed:
  paired-end: ["_R1.fq.gz", "_R2.fq.gz"]
  single-end: [".fq.gz"]
run_fastqc: true
run_multiqc: true
```

</details>

All default values are defined in the validation schema (`workflow/schemas/config.schema.yaml`).

### Execution Profile

<details>

<summary>Edit <code>workflow/profiles/default/config.yaml</code></summary>

```yaml
software-deployment-method:
  - conda
conda-prefix: /home/mjhk/.snakemake/envs/smk_downloader
printshellcmds: True
keep-incomplete: True
cores: 20
resources:
  n_instance: 5
set-threads:
  fastqc: 4
set-resources:
  download_sra_paired_end:
    n_instance: 1
  download_sra_single_end:
    n_instance: 1
```

</details>

### Sample Metadata

This workflow uses [**Portable Encapsulated Projects (PEP)**](https://pep.databio.org/) for sample management.

<details>

<summary>Edit <code>config/pep/config.yaml</code></summary>

```yaml
pep_version: 2.1.0
sample_table: samples.csv    # Path to the sample table (Required)
```

</details>

The sample table must include these mandatory columns:

| **sample_name**                   | **library_layout**                                     |
| --------------------------------- | ------------------------------------------------------ |
| Unique identifier for each sample | Sequencing strategy (`"paired-end"` or `"single-end"`) |

Another validation schema (`workflow/schemas/pep.schema.yaml`) ensures that the sample table meets the required format.

## Execution

```shell
# Create environments
snakemake --conda-create-envs-only

# Run the workflow
snakemake
```

## License

The code in this repository is licensed under the [GNU General Public License v3](http://www.gnu.org/licenses/gpl-3.0.html).
