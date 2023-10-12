#! perl

use warnings;
use strict;

my $f = shift;
my %r = load_res($f);

open I,'<',"../0.genome/out_l50_c100_b2k_g2k_mum.coord";
while(<I>){
    chomp;
    my @l = split/\t/;
    my @t1 = sort{$a <=> $b} ($l[0],$l[1]);
    my @t2 = sort{$a <=> $b} ($l[2],$l[3]);
    my $len1 = $t1[1]-$t1[0];
    my $len2 = $t2[1]-$t2[0];
    if(exists $r{"$l[9]-$t1[0]-$t1[1]"} && exists $r{"$l[10]-$t2[0]-$t2[1]"}){
        #next if $r{"$l[9]-$t1[0]-$t1[1]"} eq $r{"$l[10]-$t2[0]-$t2[1]"};
        print "$l[9]-$l[10]\t$t1[0],$t1[1]\t$t2[0],$t2[1]\t$len1,$len2\t";
        print $r{"$l[9]-$t1[0]-$t1[1]"}.",".$r{"$l[10]-$t2[0]-$t2[1]"};
        print "\n";
    }
    
}

sub load_res{
    my $f = shift;
    my %h;
    open IN,'<',$f;
    while(<IN>){
        chomp;
        my @l = split/\t/;
        if(exists $h{"$l[0]-$l[1]-$l[2]"}){
            print "$l[0]-$l[1]-$l[2]";
            exit;
        }
        $h{"$l[0]-$l[1]-$l[2]"} = $l[3];
    }
    close IN;
    return %h;
}
