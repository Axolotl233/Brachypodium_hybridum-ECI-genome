#! perl

use warnings;
use strict;

my %h;my %c;
open IN,'<',"0.filter.genelink.txt";
while(<IN>){
    chomp;
    my @l = split/\t/;
    $h{$l[0]} = $l[1];
    $c{$l[0]} = $l[2];
}
close IN;

open IN,'<',shift;
while(<IN>){
    chomp;
    my @l = split/\t/;
    next if $l[3] ne $h{$l[0]};
    push @l ,"color=".$c{$l[0]};
    print join"\t",@l;
    print "\n";
}
close IN;
