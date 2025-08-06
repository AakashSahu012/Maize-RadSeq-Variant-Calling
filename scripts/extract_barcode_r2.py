import os
from collections import Counter
from Bio import SeqIO
import pandas as pd
import gzip

def extract_barcodes(fastq_file, restriction_site, max_length=20):
    """
    Extract barcodes from the fastq file up to the restriction site within the first `max_length` base pairs.
    """
    barcodes = []

    # Check if the file is gzipped
    if fastq_file.endswith(".gz"):
        open_func = gzip.open
    else:
        open_func = open

    with open_func(fastq_file, "rt") as file:
        for record in SeqIO.parse(file, "fastq"):
            sequence = str(record.seq)
            # Extract the first `max_length` base pairs or up to the restriction site
            if restriction_site in sequence[:max_length]:
                barcode = sequence[:sequence.find(restriction_site)]
                barcodes.append(barcode)
            else:
                barcode = sequence[:max_length]  # if no restriction site, just take the first `max_length` bases
                barcodes.append(barcode)
    return barcodes

def process_samples(fastq_folder, restriction_site_fwd=None, restriction_site_rev=None):
    """
    Process all paired-end FASTQ files in the given folder (.fastq or .fastq.gz), extract inline barcodes
    for both forward and reverse reads, and report the top barcode with counts and percentages.
    """
    output_data = []

    # List all fastq and fastq.gz files in the folder
    all_files = [f for f in os.listdir(fastq_folder) if f.endswith(".fastq") or f.endswith(".fastq.gz")]

    # Group files by sample name prefix (before _R1 or _R2)
    sample_dict = {}
    for f in all_files:
        if "_R1" in f:
            sample_name = f.split("_R1")[0]
            sample_dict.setdefault(sample_name, {})["R1"] = os.path.join(fastq_folder, f)
        elif "_R2" in f:
            sample_name = f.split("_R2")[0]
            sample_dict.setdefault(sample_name, {})["R2"] = os.path.join(fastq_folder, f)

    # Process each sample
    for sample_name, files in sample_dict.items():
        forward_file = files.get("R1")
        reverse_file = files.get("R2")

        if not forward_file or not reverse_file:
            print(f"Skipping {sample_name}: missing R1 or R2 file.")
            continue

        # Extract barcodes
        forward_barcodes = extract_barcodes(forward_file, restriction_site_fwd)
        reverse_barcodes = extract_barcodes(reverse_file, restriction_site_rev)

        if not forward_barcodes and not reverse_barcodes:
            print(f"Skipping {sample_name}: no barcodes found.")
            continue

        forward_counts = Counter(forward_barcodes)
        reverse_counts = Counter(reverse_barcodes)

        forward_reads = len(forward_barcodes)
        reverse_reads = len(reverse_barcodes)

        if forward_counts:
            forward_barcode, forward_count = forward_counts.most_common(1)[0]
            forward_percentage = (forward_count / forward_reads) * 100
            # Extract last 4 bases as Spacer
            spacer = forward_barcode[-4:]  # Last 4 bases
            forward_barcode = forward_barcode[:-4]  # Remove the last 4 bases from the forward barcode
        else:
            forward_barcode, forward_count, forward_percentage, spacer = "", 0, 0.0, ""

        if reverse_counts:
            reverse_barcode, reverse_count = reverse_counts.most_common(1)[0]
            reverse_percentage = (reverse_count / reverse_reads) * 100
        else:
            reverse_barcode, reverse_count, reverse_percentage = "", 0, 0.0

        # Append the data for this sample to the output list
        output_data.append({
            "Sample Name": sample_name,
            "Forward Barcode": forward_barcode,
            "Spacer": spacer,  # Spacer is now the third column, after Forward Barcode
            "Forward Count": forward_count,
            "Forward Percentage": round(forward_percentage, 2),
            "Reverse Barcode": reverse_barcode,
            "Reverse Count": reverse_count,
            "Reverse Percentage": round(reverse_percentage, 2)
        })

    return output_data

def save_to_file(output_data, output_filename="barcode_counts.tsv"):
    """
    Saves the output data to a tab-delimited file.
    """
    df = pd.DataFrame(output_data)
    df.to_csv(output_filename, sep="\t", index=False)
    print(f"Results saved to {output_filename}")

def main():
    # User input
#    fastq_folder = os.getcwd()  # Automatically use current working directory
    fastq_folder = input("Enter the path to the directory containing the FASTQ files: ").strip()

      # Validate the path
    if not os.path.isdir(fastq_folder):
          print("The provided path is not a valid directory.")
          return
    restriction_site_fwd = input("Enter the restriction site sequence for the forward reads: ")
    restriction_site_rev = input("Enter the restriction site sequence for the reverse reads: ")

    # Process the samples and extract barcodes
    output_data = process_samples(fastq_folder, restriction_site_fwd=restriction_site_fwd, restriction_site_rev=restriction_site_rev)

    # Save the results to a file
    save_to_file(output_data)

if __name__ == "__main__":
    main()
