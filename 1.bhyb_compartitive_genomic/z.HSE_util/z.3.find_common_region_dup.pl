#! perl

use warnings;
use strict;

open IN,'<',"1.outlier_high_dep.txt";
my %h;
while(<IN>){
    chomp;
    my @l = split/\t/;
    $h{$l[0]}{$l[1]}{$l[2]} = $l[3];
}
close IN;

open IN,'<',"1.outlier_low_dep.txt";
while(<IN>){
    chomp;
    my @l = split/\t/;
    if(exists $h{$l[0]}{$l[1]}{$l[2]}){
        print "$l[0]\t$l[1]\t$l[2]\thigh-low\t";
        print $h{$l[0]}{$l[1]}{$l[2]}.",".$l[3];
        print "\n";
    }
}
