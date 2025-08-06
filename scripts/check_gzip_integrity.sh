#!/bin/bash

# Directory to scan (default is current directory)
DIR="/work/CTseed_phase2_RawData/01_RawData/RawData_SET_4/28042025"

# Output file for results
OUTPUT_FILE="gzip_integrity_check_set4.tsv"

# Check if the directory exists
if [ ! -d "$DIR" ]; then
  echo "Directory $DIR does not exist!"
  exit 1
fi

# Create or clear the output file
echo -e "Filename\tStatus" > "$OUTPUT_FILE"

# Find all .gz files in the directory and check their integrity
for file in "$DIR"/*.gz; do
  if [ -f "$file" ]; then
    # Test the gzip file integrity
    gunzip -t "$file" &> /dev/null
    if [ $? -eq 0 ]; then
      echo -e "$file\tvalid" >> "$OUTPUT_FILE"
    else
      echo -e "$file\tcorrupt" >> "$OUTPUT_FILE"
    fi
  fi
done

echo "Integrity check results saved to $OUTPUT_FILE"

