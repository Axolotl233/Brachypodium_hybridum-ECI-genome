#! perl

use warnings;
use strict;
use File::Basename;
use Cwd;

my $h_dir = getcwd();
my $chr_pair = "0.data/0.chr.pair.lst";
my $gene_pair = "0.data/BhD-BhS.alignment.fixed.csv";
my @ref = ("0.data/BhD.wgdi.convert","0.data/BhS.wgdi.convert");
my %r;
for my $f (@ref){
    open IN,'<',$f;
    while(<IN>){
        chomp;
        my @l = split/\t/;
        $r{$l[0]} = $l[1];
    }
    close IN;
}

open IN,'<',$gene_pair;
my %h;
while(<IN>){
    chomp;
    my @l = split/,/,$_;
    (my $c1 = $l[0]) =~ s/Bh[DS](.*?)g\d+/$1/;
    (my $c2 = $l[1]) =~ s/Bh[DS](.*?)g\d+/$1/;
    push @{$h{"$c2-$c1"}}, [$r{$l[1]},$r{$l[0]}];
}
close IN;
open IN,'<',$chr_pair;
mkdir "1.gene_pair" if ! -e "1.gene_pair";
while(<IN>){
    chdir "1.gene_pair";
    chomp;
    my @l = split/\t/;
    open O,'>',"$l[0]-$l[1].genepair.txt";
    for my $g_p (@{$h{"$l[0]-$l[1]"}}){
        print O ${$g_p}[0]."\t".${$g_p}[1]."\n";
    }
    close O;
    chdir $h_dir;
}
close IN;
