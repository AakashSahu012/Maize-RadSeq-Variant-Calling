# Forward reads
for pattern in CT-1017 CT-2020 CT-203 CT-283 CT-351 CT-50 CT-602 CT-604 CT-605 CT-613 CT-619 CT-623 CT-625 CT-628 CT-629 CT-642 CT-644 CT-646 CT-648 CT-650 CT-655 CT-657 CT-658 CT-663 CT-668 CT-676 CT-682 CT-686 CT-693 CT-697 CT-699 CT-719 CT-727 CT-729 CT-730 CT-731 CT-732 CT-733 CT-734 CT-747 CT-753 CT-756 CT-758 CT-761 CT-762 CT-764 CT-765 CT-768 CT-781 CT-784 CT-800 CT-804 CT-806 CT-811 CT-815 CT-825 CT-831 CT-836 CT-842 CT-850 CT-854 CT-860 CT-868 CT-869 CT-875 CT-883 CT-889
do
    output="Pop1_${pattern}.F.fq"
    files=$(ls set*/"$pattern".1.fq.gz 2>/dev/null)
    if [ -n "$files" ]; then
        echo "$files" | sort | xargs -I{} echo zcat {} ">> $output" > run_cat_R1_${pattern}.sh
    else
        echo "Warning: No R1 files found for $pattern"
    fi
done

# Reverse reads
for pattern in CT-1017 CT-2020 CT-203 CT-283 CT-351 CT-50 CT-602 CT-604 CT-605 CT-613 CT-619 CT-623 CT-625 CT-628 CT-629 CT-642 CT-644 CT-646 CT-648 CT-650 CT-655 CT-657 CT-658 CT-663 CT-668 CT-676 CT-682 CT-686 CT-693 CT-697 CT-699 CT-719 CT-727 CT-729 CT-730 CT-731 CT-732 CT-733 CT-734 CT-747 CT-753 CT-756 CT-758 CT-761 CT-762 CT-764 CT-765 CT-768 CT-781 CT-784 CT-800 CT-804 CT-806 CT-811 CT-815 CT-825 CT-831 CT-836 CT-842 CT-850 CT-854 CT-860 CT-868 CT-869 CT-875 CT-883 CT-889
do
    output="Pop1_${pattern}.R.fq"
    files=$(ls set*/"$pattern".2.fq.gz 2>/dev/null)
    if [ -n "$files" ]; then
        echo "$files" | sort | xargs -I{} echo zcat {} ">> $output" > run_cat_R2_${pattern}.sh
    else
        echo "Warning: No R2 files found for $pattern"
    fi
done

