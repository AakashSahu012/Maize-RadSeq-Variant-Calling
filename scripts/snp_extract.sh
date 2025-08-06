#!/bin/bash
set -euo pipefail

# === Logging setup ===
log_file="pipeline_$(date +%F_%T).log"
exec > >(tee -i "$log_file")
exec 2>&1

echo "=== Starting SNPs Processing Pipeline ==="
echo "Timestamp: $(date)"

# ===Config===
input_vcf="./TotalRawSNPs.vcf"
REF="../reference.fasta"
PICARD_JAR="/tools/picard.jar"
HTSLIB="/tools/htslib-1.21/bin"
GATK="/tools/gatk-4.6.1.0/gatk"
BCFtool="/tools/bcftools-1.21/bin/bcftools"
VCFtool="/tools/vcftools/bin/vcftools"
PLINK="/tools/plink_1.9/plink"
ref_dict="./reference.dict"
export PATH=/tools/jdk-23.0.1/bin:$PATH
#export PATH=/tools/jre1.8.0_311/bin:$PATH

# ===Tool Availability====
echo " Checking required tools..."

for tool in java "$HTSLIB/bgzip" "$HTSLIB/tabix" "$GATK" "$VCFtool" "$BCFtool"; do
    if command -v "$tool" &>/dev/null || [[ -x "$tool" ]]; then
        echo "Found executable: $tool"
    else
        echo "Error: Required tool not found or not executable -> $tool"
        exit 1
    fi
done

# ===check vcf file in dir===
if [[ ! -f "$input_vcf" ]]; then
	echo "Error: file '$input_vcf' not found"
	exit 1
fi

# ===prepare working dir===
mkdir -p ./work
cd work

# ===move input into vcf_file===
echo "[step] moving '$input_vcf' into vcf_files" 
#ln -s ../TotalRawSNPs.vcf .

# ===Compress and index vcf===
echo "[Step] Compressing and indexing input VCF..."

#$HTSLIB/bgzip -c -@ 16 ./TotalRawSNPs.vcf > TotalRawSNPs.vcf.gz

#$HTSLIB/tabix TotalRawSNPs.vcf.gz
#echo "compressing and indexing done"

# ===CreateSequenceDictionary (Picard)=== 

echo "[Step] Compressing and indexing input VCF..."
#java -jar $PICARD_JAR CreateSequenceDictionary R=$REF O=$ref_dict

# ===UpdateVcfSequenceDictionary (Picard) ### contig in vcf headers===

echo "[Step] Compressing and indexing input VCF..."
#java -jar $PICARD_JAR UpdateVcfSequenceDictionary INPUT=TotalRawSNPs.vcf.gz OUTPUT=TotalRawSNPs_r1.vcf.gz SEQUENCE_DICTIONARY=$ref_dict

# ===index file needed in gatk===

echo "[Step] Compressing and indexing input VCF..." 
#/tools/htslib-1.21/bin/tabix TotalRawSNPs_r1.vcf.gz

# ===extract Raw SNPs===

echo "[Step] Compressing and indexing input VCF..."
#$GATK SelectVariants -R ../reference.fasta -V TotalRawSNPs_r1.vcf.gz --select-type-to-include SNP -O RawSNPsOnly.vcf.gz --exclude-non-variants --remove-unused-alternates >> RawSNPsOnly.logs 2>&1 

# ===extract BIALLELIC (Step - 1)===

echo "[Step] Compressing and indexing input VCF..."
#$GATK SelectVariants -R ../reference.fasta -V RawSNPsOnly.vcf.gz --select-type-to-include SNP --restrict-alleles-to BIALLELIC -O SNPsOnly_r1.vcf.gz >> SNPsOnly_r1.log 2>&1

# ===Filter SNPs based on allele frequency and count===

echo "[Step] Compressing and indexing input VCF..."
#$VCFtool --gzvcf SNPsOnly_r1.vcf.gz --non-ref-af 0.0001 --max-non-ref-af 0.9999 --mac 1 --recode --recode-INFO-all --stdout | $HTSLIB/bgzip -c -@6 > SNPsOnly_r2.vcf.gz

# ===remove loci with Qual < 20===

echo "[Step] Compressing and indexing input VCF..."
#$BCFtool filter -e 'QUAL<20' -o SNPsOnly_r3.vcf.gz -O z --threads 8 SNPsOnly_r2.vcf.gz 

# ===indexing file needed for gatk===

echo "[Step] Compressing and indexing input VCF..."
#$HTSLIB/tabix SNPsOnly_r3.vcf.gz

# ===Filter for DP<3===

echo "[Step] Compressing and indexing input VCF..."
#$GATK VariantFiltration -R ../reference.fasta -V SNPsOnly_r3.vcf.gz -O SNPsOnly_r4.vcf.gz -G-filter "DP<3" --genotype-filter-name "dp_lt3" --set-filtered-genotype-to-no-call >> SNPsOnly_r4.log 2>&1

echo "[Step] Compressing and indexing input VCF..."
#$GATK SelectVariants -R ../reference.fasta -V SNPsOnly_r4.vcf.gz -O SNPsOnly_r5.vcf.gz --exclude-filtered --exclude-non-variants --remove-unused-alternates >> SNPsOnly_r5.log 2>&1

# ===remove missing===

echo "[Step] Compressing and indexing input VCF..."
#$VCFtool --gzvcf SNPsOnly_r5.vcf.gz --max-missing 0.8 --recode --recode-INFO-all --stdout | $HTSLIB/bgzip -c -@ 6 > SNPsOnly_r6.vcf.gz

# ===Minor allele frequency===

echo "[Step] Compressing and indexing input VCF..."
#$PLINK --allow-extra-chr --double-id --freq --vcf SNPsOnly_r6.vcf.gz --out SNPsOnly_r6_maf_stat

# ===filter snps for MAF===

#$VCFtool --gzvcf SNPsOnly_r6.vcf.gz --maf 0.01 --recode --recode-INFO-all --stdout | $HTSLIB/bgzip -c -@6 > SNPsOnly_r7_01.vcf.gz

#$VCFtool --gzvcf SNPsOnly_r6.vcf.gz --maf 0.001 --recode --recode-INFO-all --stdout | $HTSLIB/bgzip -c -@6 > SNPsOnly_r7_001.vcf.gz

#$VCFtool --gzvcf SNPsOnly_r6.vcf.gz --maf 0.05 --recode --recode-INFO-all --stdout | $HTSLIB/bgzip -c -@6 > SNPsOnly_r7_05.vcf.gz

for file in ./*.vcf.gz; do
	name=$(basename "$file" .vcf.gz)
	$BCFtool stats -s - "$file" > "${name}.stat"
done

pipeline_2025-07-16_10:40:41.log
