#! perl

use warnings;
use strict;

my $f1 = "2.Bsta-Bdis.del.hse.link.txt";
my $f2 = "2.Bsta-Bdis.dup.hse.link.txt";
my $f3 = "Bdis-Bsta.5div.block.bed";
my $f4 = "chr.pair.lst";

my %r = &read_chr($f4);
my %b = &read_bed($f3);
my %j;
#print $b{"Bd3-32305880-33041481"};exit;
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
	print "$l1[0]-$l2[0]\t$l1[3]-$l1[4],$l2[3]-$l2[4]\tdel-dup\n" if $b{"$l2[0]-$e2"} eq "$l1[0]-$e1";
            }
        }
    }
    close I2;
}
close I1;

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
