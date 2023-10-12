#reads_filter
fastp -i sample_1.fq.gz -I sample_2.fq.gz -o sample_fix_1.fastq.gz -O sample_fix_2.fastq.gz -f 10 -F 10 -q 20 -l 50 -5 -3 -h sample.html -w 20 2>&1 2>sample.log

#align
bwa-mem2 mem -t 30 -R '@RG\tID:sample\tPL:illumina\tPU:illumina\tLB:sample\tSM:sample' -M genome.fasta sample_fix_1.fastq.gz sample_fix_2.fastq.gz | samtools view -hF 256 - |samtools sort -O bam -@ 30 -T sample.tmp -o sample.sort.bam

#remove pcr duplicate
java -Xmx20g -jar picard.jar MarkDuplicates INPUT=sample.sort.bam OUTPUT=sample.sort.nodup.bam METRICS_FILE=sample.dup.txt REMOVE_DUPLICATES=true ; samtools index sample.sort.nodup.bam

#realign
java -jar GenomeAnalysisTK3.8.jar -T RealignerTargetCreator -nt 10 -R genome.fasta -I sample.sort.nodup.bam -o sample.realn.intervals sample.TC.bam.log
java -jar GenomeAnalysisTK3.8.jar -T IndelRealigner -R genome.fasta -targetIntervals sample.realn.intervals -o sample.realn.bam -I sample.sort.nodup.bam 2>sample.realn.bam.log

#depth and coverage stat
bamdst -p genome.bed -o sample sample.realn.bam

#snp_calling
java -jar GenomeAnalysisTK3.8.jar -T HaplotypeCaller -R genome.fasta -I sample.realn.bam -nct 20 -ERC GVCF -o sample.gvcf.gz -variant_index_type LINEAR -variant_index_parameter 128000 --min_mapping_quality_score 20 2>>./sample.log

#genotype and merge
java -jar GenomeAnalysisTK.jar -T GenotypeGVCFs -R genome.fasta -V sample.gvcf.gz -V ...(ohter_sample) -o ./Pop.vcf.gz
java -jar GenomeAnalysisTK.jar -T SelectVariants -R genome.fasta -V ./Pop.vcf.gz -selectType SNP -o ./Pop.SNP.vcf.gz
java -jar GenomeAnalysisTK.jar -T SelectVariants -R genome.fasta -V ./Pop.vcf.gz -selectType INDEL -o ./Pop.INDEL.vcf.gz
java -jar GenomeAnalysisTK.jar -T VariantFiltration -R genome.fasta -V ./Pop.SNP.vcf.gz  --filterExpression "QD < 2.0 || FS > 60.0 || MQ < 40.0 || MQRankSum < -12.5 || ReadPosRankSum < -8.0"  --filterName "my_snp_filter" -o ./Pop.HDflt.SNP.vcf.gz
java -jar GenomeAnalysisTK.jar -T VariantFiltration -R genome.fasta -V ./Pop.INDEL.vcf.gz --filterExpression "QD < 2.0 || FS > 200.0 || ReadPosRankSum < -20.0" --filterName "my_indel_filter" -o ./Pop.HDflt.INDEL.vcf.gz
perl https://github.com/Axolotl233/Simple_Script/blob/master/GATK.remove.hdfilter.pl --input ./Pop.HDflt.SNP.vcf.gz --out ./Pop.HDflted.SNP.vcf.gz --type SNP --marker my_snp_filter --multi
perl https://github.com/Axolotl233/Simple_Script/blob/master/GATK.remove.hdfilter.pl --input ./Pop.HDflt.INDEL.vcf.gz --out ./Pop.HDflted.INDEL.vcf.gz --type INDEL --marker my_indel_filter

#mannul filter
using https://github.com/Axolotl233/Simple_Script/blob/master/Vcf.filter.snp.v2.pl to get Pop.final.SNP.filter.vcf.gz

#annotation
java -Xmx20g -jar snpEff.jar -c snpEff.config genome Pop.final.SNP.filter.vcf.gz -verbose -stats ./Pop.filter.snp_anno.html -csvStats ./Pop.filter.snp_anno.csv -o gatk > Pop.final.SNP.filter.anno.txt