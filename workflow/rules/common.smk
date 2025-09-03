# *--------------------------------------------------------------------------* #
# * Configuration                                                            * #
# *--------------------------------------------------------------------------* #
from snakemake.utils import validate


include: "utils.smk"


configfile: "config/config.yaml"


validate(config, "../schemas/config.schema.yaml")


pepfile: "config/pep/config.yaml"


pepschema: "../schemas/pep.schema.yaml"


if config["dir_run"] and config["dir_run"] is not None:

    workdir: config["dir_run"]


# *--------------------------------------------------------------------------* #
# * Constants                                                                * #
# *--------------------------------------------------------------------------* #
SUFFIXES = config["suffixes_fastq_renamed"]
SUFFIXES_READ_PE = SUFFIXES["paired-end"]
SUFFIX_READ_1, SUFFIX_READ_2 = SUFFIXES_READ_PE
SUFFIX_READ_SE = SUFFIXES["single-end"]

DF_SAMPLE = pep.sample_table
SAMPLES = DF_SAMPLE["sample_name"]
SAMPLES_PE = SAMPLES[DF_SAMPLE["library_layout"] == "paired-end"]
SAMPLES_SE = SAMPLES[DF_SAMPLE["library_layout"] == "single-end"]

SUFFIXES_SRA_PE = ["_1.fastq", "_2.fastq"]
SUFFIXES_SRA_1, SUFFIXES_SRA_2 = SUFFIXES_SRA_PE
SUFFIX_SRA_SE = ".fastq"

TO_RUN_FASTQC = config["run_fastqc"]
TO_RUN_MULTIQC = config["run_multiqc"]


# *--------------------------------------------------------------------------* #
# * Wildcard constraints                                                     * #
# *--------------------------------------------------------------------------* #
wildcard_constraints:
    sample=r"|".join(SAMPLES),
