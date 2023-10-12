#! perl

use warnings;
use strict;
use File::Basename;

my @fs = sort {$a cmp $b} grep {/blockinfo.csv/} `find ./`;
print "compare\tmedian\taverage\n";
for my $f (@fs) {
    chomp $f;
    (my $n = basename $f ) =~ s/\.blockinfo\.csv//;
    open IN,'<',$f;
    readline IN;
    while(<IN>){
        chomp;
        my @l = split/,/;
        print "$n\t$l[9]\t$l[10]\n" if $l[8] > 10;
    }
}
