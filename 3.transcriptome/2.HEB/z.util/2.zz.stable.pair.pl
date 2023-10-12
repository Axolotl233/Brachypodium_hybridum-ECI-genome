#! perl

use warnings;
use strict;

my @fs = qw/2.fpkm_compare.CL.txt 2.fpkm_compare.CR.txt 2.fpkm_compare.TL.txt 2.fpkm_compare.TR.txt/;
my %h;
for my $f(@fs){
    open IN,'<',$f;
    readline IN;
    while(<IN>){
        chomp;
        my @l = split/\t/,$_;
        next if $l[4] eq "no_bias";
        next if $l[5] eq "Low";
        push @{$h{$l[2]}},$l[4];
    }
    close IN;
}

for my $g(sort {$a cmp $b} keys %h){
    my @t = @{$h{$g}};
    next if (scalar @t) != (scalar @fs);
    my %c;
    for my $i (@t){
        $c{$i} += 1;
    }
    next if (scalar (keys %c)) != 1;
    print $g."\t".$t[0]."\n";
}
