#! perl

use warnings;
use strict;

my $f = shift;
my $col = shift;

(my $i1,my $i2) = split/,/,$col;

my %h;
open IN,'<',"z.get.four.ortho_chain.D.csv";
while(<IN>){
    chomp;
    my @l = split/,/;
    $h{"$l[$i1]-$l[$i2]"} = 1;
}
close IN;

open IN,'<',$f;
while(<IN>){
    my @l = split/\t/;
    print $_ if exists $h{"$l[0]-$l[1]"};
}
close IN;
