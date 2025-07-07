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
│       │   ├── SRR*.fastq.gz      # Single-end FASTQ
|       │   ├── SRR*_1.fastq.gz    # Paired-end forward reads
│       │   └── SRR*_2.fastq.gz    # Paired-end reverse reads
│       ├── SRR*.fq.gz             # Symbolic links (single-end)
|       ├── SRR*_R1.fq.gz          # Symbolic links (paired forward)
│       ├── SRR*_R2.fq.gz          # Symbolic links (paired reverse)
│       ├── fastqc/                # FastQC output
│       └── multiqc/               # MultiQC reports
└── code/
    └── smk_downloader/    # This workflow
```

## License

The code in this repository is licensed under the [GNU General Public License v3](http://www.gnu.org/licenses/gpl-3.0.html).
