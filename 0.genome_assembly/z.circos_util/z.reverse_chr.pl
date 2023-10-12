#! perl

use warnings;
use strict;

my $karyotype = "/data/01/user112/project/Brachypodium/07.evo/03.circos/three_species/all/All.karyotype.txt";
my $file = shift;
open IN,'<',$karyotype or die "$!";
my %h2;
while(<IN>){
    my @line = split/\s+/;
    $h2{$line[2]} = $line[5];
}
close IN;
my %c;
my @chr = ("Bd1","Chr03","Chr06","Chr10","Chr05");
for my $p (@chr){
    $c{$p} = 1;
}
$^I=".bak";

open IN,'<',"$file";
while(<IN>){
    chomp;
    my @l = split/\t/;
    if(scalar @l == 4){
        if(exists $c{$l[0]}){
            my $tmp = $l[1];
            $l[1] = $h2{$l[0]} -$l[2];
            $l[1] = 0 if $l[1] < 0;
            $l[2] = $h2{$l[0]} -$tmp;
        }
    }elsif(scalar @l == 7){
        if(exists $c{$l[0]}){
            my $tmp = $l[1];
            $l[1] = $h2{$l[0]} -$l[2];
            $l[2] = $h2{$l[0]} - $tmp;
        }elsif(exists $c{$l[3]}){
            my $tmp = $l[4];
            $l[4] = $h2{$l[3]} -$l[5];
            $l[5] = $h2{$l[3]} - $tmp;
        }
    }
    print join"\t",@l;
    print "\n";
}
