# collinearity region identified, S and D seprately
minimap2 -cx asm20 --cs -t 30 --secondary=no polyploid_subgenome.fasta diploid.fasta  > z.asm20.paf

# SNP coordinate liftover
transanno minimap2chain z.asm20.paf --output z.asm20.chain
CrossMap.py vcf z.asm20.chain Pop.HDflted.SNP.vcf.gz diploid.fasta Pop.HDflted.2to4.vcf

# SNP to fasta
perl z.util/00.get_common_loci.pl Pop.HDflted.4.vcf  Pop.HDflted.2to4.vcf > 00.get_common_loci.HDflted.txt
perl z.util/01.GetFastaFromVCF.pl 00.get_common_loci.HDflted.txt  Pop.HDflted.4.vcf  01.HDflted.4.fa
perl z.util/01.GetFastaFromVCF.pl 00.get_common_loci.HDflted.txt  Pop.HDflted.2to4.vcf  01.HDflted.2to4.fa
perl z.util/02.filter_fasta.pl 01.HDflted.4.fa 01.HDflted.2to4.fa > 02.HDflted.fa

#network tree construction
Using split tree v4.0

# population structure
Using https://github.com/Axolotl233/Simple_Script/blob/master/Vcf.structure.pl for population structure analysis (ML tree, PCA , admixture)

#pi and fst
pixy --stat pi fst --vcf vcf.file --populations pop.lst  --n_cores 10 --bypass_invariant_check yes --output_folder pixy.out

# chloroplast (PGA is a software)
get_organelle_from_reads.py -1 sample_fix_1.fastq.gz -2 sample_2.fastq.gz -o TE43 -t 20 -R 15 -k 21,45,65,85,105 -F embplant_pt
perl PGA.pl -r z.database/gb -t annotation
perl z.util/genbank2CDSandPEP.pl sample.gb sample
perl z.util/z.1.sample2gene.pl
perl z.util/z.2.mafft.pl
perl z.util/z.3.tandem_fa.pl
iqtree -s All.plast.gene.fasta  -pre fix -nt 10 -bb 1000 -quiet -redo
iqtree -s All.plast.fasta  -pre fix -nt 10 -bb 1000 -quiet -redo