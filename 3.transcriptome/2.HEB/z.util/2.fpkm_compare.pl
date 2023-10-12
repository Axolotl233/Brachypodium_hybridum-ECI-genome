#! perl

use warnings;
use strict;
use File::Basename;
use Cwd;
use List::Util qw(sum);

my $h_dir = getcwd();
my $fpkm = "$h_dir/0.data/Bhyb.tpm.txt";
#my $fpkm = "/data/01/user112/project/Brachypodium/09.trans/bhyb/02.stringtie/Bhyb.tpm.txt";
my $sample_lst = "$h_dir/0.data/Sample.txt";
my $genepair_dir = "$h_dir/1.gene_pair";
my @m = qw/CL TL CR TR/;
my %f;
open IN,'<',"$fpkm" or die "$!";
my @head = split/\t/,(readline IN);
chomp $head[-1];
while(<IN>){
    chomp;
    my @l = split/\t/;
    for (my $i = 1;$i < @l;$i++){
        $f{$l[0]}{$head[$i]} = $l[$i];
    }
}
close IN;

my %sam;
open IN,'<',$sample_lst or die "$!";
while(<IN>){
    chomp;
    my @l = split/\t/;
    push @{$sam{$l[1]}},$l[0];
}
close IN;

my $o_head = "Chr_pair\tGroup\tGene_pair\tLog2FC\tBias\tClass\tExp_class\tSample\tMean_exp\tExp\n";
my @fs = sort {$a cmp $b} grep {/genepair.txt/} `find $h_dir/1.gene_pair`;
mkdir "2.fpkm_compare" if ! -e "2.fpkm_compare";
for my $f (@fs){
    chomp $f;
    chdir "2.fpkm_compare";
    (my $pair = basename $f) =~ s/(.*?)\..*/$1/;
    mkdir $pair if ! -e $pair;
    chdir $pair;
    my @sub = split/\-/,$pair;
    for my $k (sort{$a cmp $b} keys %sam){
        open O,'>',"$pair.$k.info.txt";
        print O $o_head;
        open IN,'<',$f;
        my @s = @{$sam{$k}};
        print "$pair-$k\n";
        while(<IN>){
            chomp;
            my $bias = "no_bias";
            my @l = split/\t/;
            my @exp1;my @exp2;
            for my $e (@s){
	push @exp1, $f{$l[0]}{$e};
	push @exp2, $f{$l[1]}{$e};
            }
            my $c1 = 0;
            for my $e (@exp1){
	$c1 += 1 if $e == 0;
            }
            my @p_exp1 = ($c1 >= 2)?(0):@exp1;
            my $c2 = 0;
            for my $e (@exp2){
	$c2 += 1 if $e == 0;
            }
            my @p_exp2 = ($c2 >= 2)?(0):@exp2;
            my $tmp1 = (join",",@exp1)."-".(join",",@exp2);
            my $mean1 = sprintf("%.3f",(sum(@p_exp1)/(scalar @exp1)));
            my $mean2 = sprintf("%.3f",(sum(@p_exp2)/(scalar @exp2)));
            my $sum = sum(@p_exp1) + sum(@p_exp2);
            my $class = "Normal";
            if($sum < 0.3333){
	$class = "Low";
            }
            my $lfc;
            my $group = "all";
            if($mean1 != 0 && $mean2 != 0){
	$lfc = sprintf("%.3f",log($mean1/$mean2)/log(2));
	if ($lfc >= 1){
	    $bias = "S_bias";
	}elsif($lfc <= -1){
	    $bias = "D_bias";
	}
            }elsif($mean2 == 0 && $mean1 != 0){
	$bias = "S_bias";
	$lfc = "pair1";
	$group = "special";
            }elsif($mean1 == 0 && $mean2 != 0){
	$bias = "D_bias";
	$lfc = "pair2";
	$group = "special";
            }elsif($mean1 == 0 && $mean2 == 0){
	$lfc = "no_pair_nan";
	$group = "none";
            }
            
            my @p = ($pair,$k,"$l[0]-$l[1]",$lfc,$bias,$class,$group,(join",",@s),"$mean1-$mean2",$tmp1);
            print O (join"\t",@p),"\n";
        }
        close O;
        close IN;
    }
    chdir $h_dir;
}

my %p;
my @fr = sort {$a cmp $b} grep {/info.txt/} `find ./2.fpkm_compare`;
for my $f (@fr){
    chomp $f;
    (basename $f) =~ /.*?\.(.*?)\.info.txt/;
    push @{$p{$1}} ,$f;
}

for my $c (@m){
    open O,'>',"2.fpkm_compare.$c.txt";
    print O $o_head;
    for my $t(@{$p{$c}}){
        open IN,'<',$t;
        readline IN;
        while(<IN>){
            print O $_;
        }
        close IN;
    }
    close O;
}
    
