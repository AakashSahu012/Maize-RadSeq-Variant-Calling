RAD-seq Variant Calling Pipeline for Maize (660 Samples)
🧬 Overview

This project involves the analysis of 660 RAD-seq FASTQ files of maize, divided into 5 datasets. The aim was to identify high-quality SNPs and perform downstream population analysis including PCA and phylogenetic analysis. All processing was performed using a Docker-based workflow and HPC parallel computing for speed and efficiency.

Barcodes were either provided by the client or extracted using a custom Python script.

🗂️ Workflow Summary
1. Initial Quality Check

    Calculate raw FASTQ statistics using Raspberry tool.

2. Demultiplexing (Round 1)

    Tool: sabre

    Demultiplex based on R1 barcodes

    Run using parallel threads:

    parallel -j 32 < sabre_cmds.txt

3. Post-demultiplexing Stats

    Recalculate stats for all demultiplexed FASTQ files to check success and coverage.

4. Process RAD-tags (Round 2 Demultiplexing)

    Tool: process_radtags from STACKS

    Demultiplex using both R1 spacer and R2 barcode

    Run in parallel:

    parallel -j 32 < pcrt_cmd.txt
    
    Recalculate stats for all demultiplexed FASTQ files to check success and coverage.

5. Sample Concatenation

    Concatenate FASTQ files for the same sample across multiple sets, if present.

6. Variant Calling Pipeline

    Tool: dDocent

    Perform read alignment, SNP calling, and initial filtering.

7. SNP Filtering

    Custom pipeline: snp_extract.sh

    Select high-quality SNPs for population genetic analysis

8. Population Genetics

    PCA analysis

    Phylogenetic tree construction

⚙️ Technology Stack

    see requirement.txt file

    Languages: Bash, Python

    Environments: Docker, HPC

🚀 How to Run

# 1. Prepare environment using Docker
docker run -v $PWD:/data -w /data your_docker_image bash

# 2. Run sabre
parallel -j 32 < sabre_cmds.txt

# 3. Run process_radtags
parallel -j 32 < pcrt_cmd.txt

# 4. Run dDocent
bash dDocent_config_and_run.sh

# 5. Filter SNPs
bash snp_extract.sh

👨‍💻 Author

    Aakash Sahu, Bioinformatics Intern
    Focused on variant discovery, population genetics, and high-performance computing in genomics.
