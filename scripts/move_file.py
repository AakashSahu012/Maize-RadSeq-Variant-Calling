import os
import shutil

def move_fastq_files(sample_file, src_dir, dest_dir):
    os.makedirs(dest_dir, exist_ok=True)

    # Read sample names like "CT-203"
    with open(sample_file, 'r') as f:
        samples = [line.strip() for line in f if line.strip()]

    moved_files = []

    for sample in samples:
        for read_num in ['1', '2']:
            filename = f"{sample}.{read_num}.fq.gz"
            src_path = os.path.join(src_dir, filename)
            dest_path = os.path.join(dest_dir, filename)
            if os.path.exists(src_path):
                shutil.move(src_path, dest_path)
                moved_files.append(filename)
            else:
                print(f"⚠️ File not found: {filename}")

    print(f"\n✅ Moved {len(moved_files)} files:")
    for f in moved_files:
        print(f" - {f}")

if __name__ == "__main__":
    sample_file = input("📄 Enter path to sample names file (e.g., samples.txt): ").strip()
    src_dir = input("📁 Enter source directory (where FASTQ files are located): ").strip()
    dest_dir = input("📂 Enter destination directory (where to move files): ").strip()

    move_fastq_files(sample_file, src_dir, dest_dir)

