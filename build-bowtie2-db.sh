for GENOME in `cat genomes.txt`
do
   TAG="${GENOME/-contigs.fa/}"
   echo $TAG-contigs.fa
   bowtie2-build $TAG-contigs.fa $TAG
done
