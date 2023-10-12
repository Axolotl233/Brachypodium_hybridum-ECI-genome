#! perl

use warnings;
use strict;

my %r;
open IN,'<',"00.get_common_loci.HDflted.txt";
while(<IN>){
    chomp;
    my @l = split/\t/;
    $r{$l[0]}{$l[1]} = 1;
}
close IN;

open IN,'<',"BhDEC.single.gff";
while(<IN>){
    chomp;
    my @l = split/\t/;
    for my $k(sort {$a <=> $b} keys %{$r{$l[0]}}){
        if($r{$l[0]}{$k} <= $l[3] && $r{$l[0]}{$k} >= $l[2]){
            print $l[0]."\t".$k;
        }
    }
}
