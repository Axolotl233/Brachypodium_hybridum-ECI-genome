# wgdi (ks, colinearity, homelogous_chain and other scripts)
Using https://github.com/Axolotl233/Simple_Script/blob/master/wgdi.pl
Using config file and other custom script in z.wgdi_util

# OrhtoMCL cluster
mysql -u root < mysql.setting.template
orthomclInstallSchema orthomcl.config.template

orthomclFilterFasta compliantFasta/ 10 20

#makeblastdb -in goodProteins.fasta -dbtype prot
#blastp -db goodProteins.fasta -query goodProteins.fasta -out all-all.blastp.out -evalue 1e-5 -outfmt 6 -num_threads 24

diamond makedb --in goodProteins.fasta -d goodProteins.fasta
diamond blastp --db goodProteins.fasta --query goodProteins.fasta --out all-all.blastp.out --outfmt 6  --more-sensitive --max-target-seqs 500 --evalue 1e-5 --id 30 --block-size 20.0 -p 30 --tmpdir ./tmp --index-chunks 1

orthomclBlastParser all-all.blastp.out compliantFasta > similarSequences.txt
perl -p -i.bak -e 's/0\t0/1\t-181/' similarSequences.txt
orthomclLoadBlast orthomcl.config.template similarSequences.txt
orthomclPairs orthomcl.config.template orthomcl_pairs.log cleanup=no
orthomclDumpPairsFiles orthomcl.config.template
mcl mclInput --abc -I 1.5 -o mclOutput
orthomclMclToGroups cluster 1 < mclOutput > groups.txt

# gene repeat
perl https://github.com/Axolotl233/Simple_Script/blob/master/Gff3.convert.bed.mcscan.pl gene.gff
perl z.gene_repeat_util/repeat.stat.pl
perl z.gene_repeat_util/z.add_pair.pl repeat.stat.tab > repeat.stat.fix.tab

# genome structural variants
nucmer --maxmatch -c 100 -b 500 -l 50 -t 30 Bsta-Bdis.fa Bhyb.fa
delta-filter -m -i 90 -l 100 out.delta > out_m_i90_l100.delta
show-coords -THrd out_m_i90_l100.delta > out_m_i90_l100.coord
python syri -c out_m_i90_l100.coord -d out_m_i90_l100.delta -r Bsta-Bdis.fa -q Bhyb.fa --nosnp -k

#replacement HE
minimap2 -cx asm20 -t 30 --secondary=no Bhyb.fasta Bdis-Bsta.fasta > z.merge-bhyb.paf
minimap2 -cx asm20 -t 60 --secondary=no Bdis.fa Bsta.fa > z.bsta-bdis.div5.paf
perl z.Hse_util/Convert.minimap_paf2block_bed.pl --min 2000 --prior z.Hse_Util/1.merge.pair.txt z.merge-bhyb.div5.paf
perl z.Hse_util/Convert.minimap_paf2block_bed.pl --min 2000 --prior z.Hse_Util/1.bsta-bdis.pair.txt z.bsta-bdis.div5.paf

bwa-mem2 mem -t 60 -M ref.fa sample_1.fq.gz sample_2.fq.gz | samtools view -hF 256 - |samtools sort -O bam -@ 60 -T sample.tmp -o sample.sort.bam
perl https://github.com/Axolotl233/Simple_Script/blob/master/Fasta.convert.bed.window.bamdst.pl ref.fa 10000 > ref.10k.bed
bamdst -p ref.10k.bed -o ./sample sample.sort.bam

cd sample; perl z.Hse_util/split_file_by_col.pl region.tsv.gz -g -h un;cd ..
perl z.Hse_util/1.Hse.pl sample
mkdir 1.depthlink
mv *hse.link.txt 1.depthlink
mkdir 2.link2block
perl z.Hse_util/2.link2block
mkdir 3.identify_homo_region
perl z.Hse_util/3.block.identify.pl
perl z.Hse_util/4.block2query.pl
perl z.Hse_util/4.stat.new.pl

#reciproal HE
nucmer --mum -c 100 -l 50 -b 2000 -g 2000 -t 60 BhD.fa BhS.fa
delta-filter -1 -l 50 out.delta > out_l50_c100_b2k_g2k_mum.delta
show-coords -THqd out_l50_c100_b2k_g2k_mum.delta > out_l50_c100_b2k_g2k_mum.coord

bwa-mem2 mem -t 60 -M ref_ploid.fa D_dip_1.fq.gz D_dip_2.fq.gz | samtools view -hF 256 - |samtools sort -O bam -@ 60 -T sample.tmp -o D_dip.sort.bam
bwa-mem2 mem -t 60 -M ref_ploid.fa S_dip_1.fq.gz S_dip_2.fq.gz | samtools view -hF 256 - |samtools sort -O bam -@ 60 -T sample.tmp -o S_dip.sort.bam
perl https://github.com/Axolotl233/Simple_Script/blob/master/Fasta.convert.bed.window.bamdst.pl ref_ploid.fa 10000 > ref_ploid.10k.bed
bamdst -p ref_ploid.10k.bed -o ./S_dip S_dip.sort.bam
bamdst -p ref_ploid.10k.bed -o ./D_dip D_dip.sort.bam

perl z.Hse_util/z.1.detect.outlier.region.high_depth.pl S_dip z.D.lst
perl z.Hse_util/z.1.detect.outlier.region.high_depth.pl D_dip z.S.lst
perl z.Hse_util/z.1.detect.outlier.region.low_depth.pl S_dip z.S.lst
perl z.Hse_util/z.1.detect.outlier.region.low_depth.pl D_dip z.D.lst
perl z.Hse_util/z.2.gather_res.pl D_dip S_dip
perl z.Hse_util/z.3.find_common_region_dup.pl >  3.find_common_region_dup.txt
perl z.Hse_util/z.4.find_common_region_homo.pl 3.find_common_region_dup.txt

