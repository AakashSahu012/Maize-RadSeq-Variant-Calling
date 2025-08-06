import os
import pandas as pd

# Prompt user for directory
input_dir = input("Enter the directory containing your stat files: ").strip()

# Validate directory
if not os.path.isdir(input_dir):
    print("❌ Invalid directory. Please check the path and try again.")
    exit()

rows = []
exclude_keys = {'A', 'T', 'G', 'C', 'N', 'percent G-C content'}

# Parse files
for file in os.listdir(input_dir):
    if file.endswith('.txt') or file.endswith('.stats'):
        filepath = os.path.join(input_dir, file)
        row = {"File name": file}
        with open(filepath) as f:
            for line in f:
                if ':' in line:
                    key, val = line.split(':', 1)
                    key = key.strip()
                    if key not in exclude_keys:
                        row[key] = val.strip()
        rows.append(row)

if not rows:
    print("⚠️ No .txt or .stats files found in the directory.")
    exit()

# Create and save DataFrame
df = pd.DataFrame(rows)

# Remove full path, keep only file name
df["File name"] = df["File name"].apply(os.path.basename)

# Save to CSV
df.to_csv('All_compile_stats.csv', index=False)

print(f"✅ Stats compilation done in: {input_dir}")

