#! perl

use warnings;
use strict;
use File::Basename;

if(@ARGV != 2){
    print STDERR "perl $0 \$gff \$mcscanx_res\n";
    exit;
}
(my $gff,my $mcscan) = @ARGV;
(my $n = basename $mcscan) =~ s/(.*?)\..*/$1/;

my %g;
open R,'<',$gff;
while(<R>){
    chomp;
    my @line = split/\t/;
    @{$g{$line[1]}} = ($line[0],$line[2],$line[3]);
}
close R;

open IN,'<',$mcscan;
open O,'>',"$n.genelink.txt";
while(<IN>){
    next if /^#/;
    my @row = split/\t/;
    next if ${$g{$row[1]}}[0] eq ${$g{$row[2]}}[0];
    my $g1 = join"\t",@{$g{$row[1]}};
    my $g2 = join"\t",@{$g{$row[2]}};
    print O $g1."\t".$g2."\n";
}
close IN;
