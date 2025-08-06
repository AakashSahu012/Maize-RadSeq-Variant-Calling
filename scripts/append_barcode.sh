#!/bin/bash

# Output file to collect max sequences
summary_output="max_count_bar.txt"

# Clear the output file if it exists
> "$summary_output"

# Loop through all *_top4.txt files
for top4_file in *_R2_top4.txt; do
    # Skip if no files match
    [ -e "$top4_file" ] || continue

    # Extract prefix from filename (remove_R2 _top4.txt)
    prefix="${top4_file%_R2_top4.txt}"

    # Get the first line (max count sequence) from the file
    max_seq=$(head -n 1 "$top4_file" | cut -f1)

    # Append to summary file
    echo -e "${max_seq}\t${prefix}" >> "$summary_output"
done

echo "Summary saved to $summary_output"

