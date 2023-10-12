#! perl

use warnings;
use strict;

my %h;

open IN,'<',"z.chr.lst";
while(<IN>){
    chomp;
    my @l = split/\t/;
    $h{$l[0]} = $l[1];
}
close IN;

open IN,'<',shift;
while(<IN>){
    chomp;
    my @l = split/\t/;
    (my $c = $l[0]) =~ s/\_(.*)//;
    my $t = $1;
    (my $d = $h{$c}) =~ s/\d+//;
    print $_."\t".$c."\t".$d."\t".$h{$c}."_$t"."\n";
}
