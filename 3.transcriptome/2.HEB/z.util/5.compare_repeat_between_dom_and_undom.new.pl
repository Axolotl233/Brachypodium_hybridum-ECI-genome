#! perl

use warnings;
use strict;

my $repeat_data = "/data/01/user112/project/Brachypodium.split/bhyb/01.evolution/02.subgenome_bias/4.repeat_and_expression_relation/01.gene_stat.txt";
my %repeat = &get_repeat($repeat_data);

open IN,'<',"z.all.stable.bias.gene.lst" or die "$!";
while(<IN>){
    chomp;
    my @l = split/\t/;
    (my $g1,my $g2) = split/\-/,$l[0];
    if(! exists $repeat{$g1}||!exists $repeat{$g2}){
        
        print STDERR "$l[0]\n";
        exit;
    }
    if($l[1] eq "S_bias"){
        print "$g1\tS\tdominant\t$repeat{$g1}\t$l[0]\n";
        print "$g2\tD\tsubmissive\t$repeat{$g2}\t$l[0]\n";
    }elsif ($l[1] eq "D_bias") {
        print "$g1\tS\tsubmissive\t$repeat{$g1}\t$l[0]\n";
        print "$g2\tD\tdominant\t$repeat{$g2}\t$l[0]\n";
    }
}
sub get_repeat{
    my $f = shift @_;
    my %h;
    open IN,'<',$f;
    while(<IN>){
        chomp;
        my @l = split/\t/;
        $h{$l[1]} = $l[4];
    }
    close IN;
    return %h;
}
