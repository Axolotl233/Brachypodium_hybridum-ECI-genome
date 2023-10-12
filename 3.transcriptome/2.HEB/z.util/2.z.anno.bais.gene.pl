#! perl

use warnings;
use strict;

my %r;
my @fs = qw/2.fpkm_compare.CR.txt 2.fpkm_compare.TR.txt/;
for my $f (@fs){
    (my $n = $f) =~ s/2.fpkm_compare.(.*).txt/$1/;
    open I,'<',$f;
    readline I;
    while(<I>){
        chomp;
        my @l = split/\t/;
        $r{$l[2]}{$n} = $l[4];
    }
    close I;
}
open IN,'<',"2.z.all.bais.gene.lst";
while(<IN>){
    chomp;
    my %t;
    print "$_";
    for my $k2 (sort {$a cmp $b} keys %{$r{$_}} ){
        my $p = $r{$_}{$k2};
        print "\t$p";
        $t{$p} = 1;
    }
    my $o = (scalar keys %t == 1)?"same":"diff";
    print "\t$o\n";
}

