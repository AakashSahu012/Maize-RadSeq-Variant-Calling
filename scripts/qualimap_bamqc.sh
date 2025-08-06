##make a result dir
mkdir -p  ./bamqc_result

###### run loop ###
for bam in ./Pop*.bam;do
	name=$(basename "$bam" .bam)
	echo "running bamqc on $name.."
	qualimap bamqc -bam "$bam" -outdir ./bamqc_result/"${name}" -nt 16
done
