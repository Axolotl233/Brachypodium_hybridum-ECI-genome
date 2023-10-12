perl z.util/1.get_gene_pair.pl
perl z.util/2.fpkm_compare.pl

grep -v 'no_bias' 2.fpkm_compare.TL.txt |grep -v 'Low' |grep -v 'Gene' |cut -f 3 > z.TL.bias.gene.lst
grep -v 'no_bias' 2.fpkm_compare.TR.txt |grep -v 'Low' |grep -v 'Gene' |cut -f 3 > z.TR.bias.gene.lst
grep -v 'no_bias' 2.fpkm_compare.CR.txt |grep -v 'Low' |grep -v 'Gene' |cut -f 3 > z.CR.bias.gene.lst
grep -v 'no_bias' 2.fpkm_compare.CL.txt |grep -v 'Low' |grep -v 'Gene' |cut -f 3 > z.CL.bias.gene.lst

perl z.util/2.z.anno.bais.gene.pl  > 2.z.all.bais.gene.res.R.txt
perl z.util/2.z.anno.bais.gene.pl  > 2.z.all.bais.gene.res.L.txt
perl z.util/2.zz.stable.pair.pl

perl z.util/3.stat.between.treatment.pl 2.fpkm_compare.CL.txt 2.fpkm_compare.TL.txt
perl z.util/3.stat.between.treatment.pl 2.fpkm_compare.CR.txt 2.fpkm_compare.TR.txt

perl z.util/4.compare_kaks_between_dom_and_undom.new.pl
perl z.util/4.filter result_of_4.compare_kaks_between_dom_and_undom.new.pl
perl z.util/5.compare_repeat_between_dom_and_undom.new.pl

#perl z.util/z.query_tpm.pl 
#https://github.com/Axolotl233/Simple_Script/blob/master/Command.Goatools.pl for go analysis 