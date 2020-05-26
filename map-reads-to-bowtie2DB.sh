#SAMPPATH="../genome-recovery-from-MG/"
#SAMPPATH="~/MetaG-Nov18/"
#SAMPPATH="/home/dhwani/TolmanHighDepthMetaG-BB15GT15/"
#SAMPPATH="/home/dhwani/work/metaG2018/assembly_binning/region-wise-assembly/"
SAMPPATH=`pwd`
echo $SAMPPATH
for sample in `awk '{print $1}' samples.txt`
do
    if [ "$sample" == "sample" ]; then continue; fi
    
    # For each genome or gene in genomes.txt
    # map reads in each sample to it
    for GENOME in `cat genomes.txt`
    do
        TAG="${GENOME/-contigs.fa/}"
        SUF1="-QUALITY_PASSED_R1.fastq"
        SUF2="-QUALITY_PASSED_R2.fastq"
        echo "$TAG $sample $SAMPPATH$sample$SUF1 $SAMPPATH$sample$SUF2"
        # do the bowtie mapping to get the SAM file:
        # specify the relative path to files here
        # TO-DO: CHANGE script so that it takes the relative path to the directory where 
        # cleaned QUALITY_PASSED fastq files are located, as input from the user 
        bowtie2 --threads 24 \
		--very-sensitive-local \
                -x $TAG -N 1 \
                -1 $SAMPPATH$sample$SUF1 \
                -2 $SAMPPATH$sample$SUF2 \
                --no-unal \
                -S $TAG-$sample.sam
        
        # convert the resulting SAM file to a BAM file:
        samtools view -F 4 -bS $TAG-$sample.sam > $TAG-$sample-RAW.bam

        # sort and index the BAM file:
        samtools sort $TAG-$sample-RAW.bam $TAG-$sample
        samtools index $TAG-$sample.bam

        # remove temporary files:
        rm $TAG-$sample.sam $TAG-$sample-RAW.bam
     done
done
