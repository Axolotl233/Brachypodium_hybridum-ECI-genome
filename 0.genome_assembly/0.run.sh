# repetitve sequence stat
Using https://github.com/Axolotl233/Simple_Script/tree/master/Repeat_ClassStatisitc

# circos
Using scripts from z.circos_util

# wgdi (ks, colinearity,)
Using https://github.com/Axolotl233/Simple_Script/blob/master/wgdi.pl

# genome structural variants
nucmer --maxmatch -c 100 -b 500 -l 50 -t 30 Bsta-Bdis.fa Bhyb.fa
delta-filter -m -i 90 -l 100 out.delta > out_m_i90_l100.delta
show-coords -THrd out_m_i90_l100.delta > out_m_i90_l100.coord
python syri -c out_m_i90_l100.coord -d out_m_i90_l100.delta -r Bsta-Bdis.fa -q Bhyb.fa --nosnp -k

# HSE
minimap2 -cx asm20 --cs -t 30 --secondary=no  Bhyb.fasta Bdis-Bsta.fasta > z.asm20.paf
Using scripts from z.HSE_util to detect HSE

# gene_faimly and dated phylogentic tree
descripted in methods