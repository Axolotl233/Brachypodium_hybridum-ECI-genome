#! perl

use warnings;
use strict;
use File::Basename;

my @fs = sort {$a cmp $b} grep {/block.kaks.txt/} `find ./`;
print "compare\tNG86\tYN00\n";
for my $f (@fs) {
    chomp $f;
    (my $n = basename $f ) =~ s/\.block\.kaks\.txt//;
    open IN,'<',$f;
    readline IN;
    while(<IN>){
        chomp;
        my @l = split/\t/;
        next if scalar @l < 6;
        $l[3] =~ s/-//;
        $l[5] =~ s/-//;
        print "$n\t$l[3]\t$l[5]\n";
    }
}
