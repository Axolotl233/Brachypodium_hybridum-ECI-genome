#! perl

use warnings;
use strict;

my %h;
open IN,'<',shift;
while(<IN>){
    next if /#/;
    my @l = split/\t/;
    $h{$l[0]}{$l[1]} = 1;
}
close IN;
open IN,'<',shift;
while(<IN>){
    next if /#/;
    my @l = split/\t/;
    next if !exists $h{$l[0]}{$l[1]};
    print "$l[0]\t$l[1]\n";
}
close IN;
