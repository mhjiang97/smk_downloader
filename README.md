# SMK_DOWNLOADER

*A Snakemake workflow for downloading public raw sequencing data*

## Supported Data Sources

- **SRA**

## Recommended Project Structure

```
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

## Setup

```shell
git clone https://github.com/mhjiang97/smk_downloader.git

cd smk_downloader/

mv config/.config.yaml config/config.yaml
mv config/pep/.config.yaml config/pep/config.yaml
```

## Configuration

### Config File

The main configuration file (`config/config.yaml`) contains:

- `retries_sra`: Number of retries for SRA downloads (default: `1`)
- `dir_run`: Output directory (optional)
- `suffixes_fastq_renamed`: Read file naming patterns
  - `paired-end`: (Default: `["_R1.fq.gz", "_R2.fq.gz"]`)
  - `single-end`: (Default: `".fq.gz"`)
- `run_fastqc`: Enable FastQC analysis (default: `true`)
- `run_multiqc`: Generate MultiQC report (default: `true`)

All default values are defined in the validation schema (`config/schemas/config.yaml`).

### Profile

The default profile (`workflow/profiles/default/config.yaml`) configures execution parameters:
- `printshellcmds`:  True
- `keep-incomplete`: True
- `cores`: 20
- `resources`:
  - `n_instance`: 5
- `set-threads`:
  - `fastqc`: 4
- `set-resources`:
  - `download_sra_paired_end`:
    - `n_instance`: 1
  - `download_sra_single_end`:
    - `n_instance`: 1

### Sample Metadata

This workflow uses [Portable Encapsulated Projects (PEP)](https://pep.databio.org/) to manage sample metadata.

Sample configuration (`config/pep/config.yaml`) specifies the path to your sample table and other attributes.

The sample table must include these mandatory columns:

- `sample_name`: Unique identifier for each sample (required by PEP)
- `library_layout`: Sequencing strategy, must be either `"paired-end"` or `"single-end"`

Another validation schema (`config/schemas/pep.yaml`) ensures that the sample table meets the required format.

## Execution

After the configuration, you can run it using Snakemake:

```shell
snakemake
```

## License

The code in this repository is licensed under the [GNU General Public License v3](http://www.gnu.org/licenses/gpl-3.0.html).
