#! perl

use warnings;
use strict;

my $f1 = shift;
my $f2 = shift;
my $c = shift;
$c //= "NA";

open IN,'<',$f1;
my %h;
while(<IN>){
    chomp;
    my @l = split/,/,$_;
    $h{"$l[0]-$l[1]"} = 1;
}
close IN;

open IN,'<',$f2;
while(<IN>){
    my @l = split/\t/;
    next if ! exists $h{"$l[0]-$l[1]"};
    print $_;
}
close IN;
