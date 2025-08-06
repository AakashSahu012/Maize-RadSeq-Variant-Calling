#!/bin/bash

# Output CSV file
output="all_fastq_stats.csv"
first=1

# Remove old output file if it exists
rm -f "$output"

# Loop through all the file arguments
for file in "$@"; do
  awk -F ':' -v first="$first" '
  {
    gsub(/^ +| +$/, "", $1)
    gsub(/^ +| +$/, "", $2)
    keys[NR]=$1
    vals[NR]=$2
  }
  END {
    if (first == 1) {
      for (i = 1; i <= NR; i++) {
        printf "%s%s", keys[i], (i==NR ? "\n" : ",")
      }
    }
    for (i = 1; i <= NR; i++) {
      printf "%s%s", vals[i], (i==NR ? "\n" : ",")
    }
  }' "$file" >> "$output"
  first=0
done

