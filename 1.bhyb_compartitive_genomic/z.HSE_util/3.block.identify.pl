#! perl

use warnings;
use strict;

my $f = "z.sample.lst";
my $f3 = "z.bsta-bdis.div5.block.bed";
my $f4 = "0.bsta-bdis.pair.txt";

my %r = &read_chr($f4);
my %b = &read_bed($f3);

open I,'<',$f;
my $t_p = "chr_pair\tregion\tclass\tsample\n";
while(<I>){
    chomp;
    my $n = $_;
    my $f1 = "2.link2block/2.$_.del.hse.link.txt";
    my $f2 = "2.link2block/2.$_.dup.hse.link.txt";
    my %j;
    next if -e "3.identify_homo_region/$_.txt";
    
    open O,'>',"3.identify_homo_region/$_.txt";
    open I1,'<',$f1;
    while(<I1>){
        chomp;
        my @l1 = split/\t/;
        my @b1 = split/,/,$l1[-1];
        next if scalar @l1 == 5;
        open I2,'<',$f2;
        while(<I2>){
            chomp;
            my @l2 = split/\t/;
            next if scalar @l2 == 5;
            next if !exists $r{"$l1[0]-$l2[0]"};
            my @b2 = split/,/,$l2[-1];
            for my $e2 (@b2){
	for my $e1 (@b1){
	    my $t = "$l1[0]-$l2[0]-$l1[3]-$l1[4]-$l2[3]-$l2[4]";
	    next if (exists $j{$t});
	    $j{$t} = 1;
	    if($b{"$l2[0]-$e2"} eq "$l1[0]-$e1"){
	        print O "$l1[0]-$l2[0]\t$l1[3]-$l1[4],$l2[3]-$l2[4]\tdel-dup\n";
	        $t_p .= "$l1[0]-$l2[0]\t$l1[3]-$l1[4],$l2[3]-$l2[4]\tdel-dup\t$n\tABR114-Bd21\n";
	    }
	}
            }
        }
        close I2;
    }
    close I1;
    close O;
}
open O2,'>',"3.block.identify.txt";
print O2 $t_p;
close O2;

sub read_chr{
    my $f = shift @_;
    my %h;
    open IN,'<',$f;
    while(<IN>){
        chomp;
        my @l = split/\t/,$_;
        $h{"$l[0]-$l[1]"} = 1;
        $h{"$l[1]-$l[0]"} = 1;
    }
    close IN;
    return %h;
}

sub read_bed{
    my $f = shift @_;
    my %h;
    open IN,'<',$f;
    while(<IN>){
        chomp;
        my @l = split/\t/;
        $h{"$l[0]-$l[1]-$l[2]"} = "$l[3]-$l[4]-$l[5]";
        $h{"$l[3]-$l[4]-$l[5]"} = "$l[0]-$l[1]-$l[2]";
    }
    close IN;
    return %h;
}
