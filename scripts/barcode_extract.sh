#!/bin/bash

# Directory containing the fastq.gz files
input_dir="/home/asahu/CTseed_phase2/01_RawData/RawData_SET_2"
restriction_site="AATT"

# Loop through all *_R1.fastq.gz files in the directory
for input_file in "$input_dir"/*_R2.fastq.gz; do
    # Skip if no files match
    [ -e "$input_file" ] || continue

    # Get file prefix
    prefix=$(basename "$input_file" .fastq.gz)
    output_file="${prefix}_top4.txt"

    echo "Processing $input_file..."

    zcat "$input_file" | LC_ALL=C awk -v site="$restriction_site" 'NR%4==2 && index($0, site) {
        split($0, a, site);
        print a[1]
    }' | sort | uniq -c | sort -nr | head -n 4 | awk '{print $2 "\t" $1}' > "$output_file"

    echo "Top 4 sequences saved to $output_file"
done

