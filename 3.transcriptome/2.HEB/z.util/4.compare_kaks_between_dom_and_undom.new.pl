#! perl

use strict;
use warnings;

my $kaks = "/data/01/user112/project/Brachypodium.split/bhyb/01.evolution/02.subgenome_bias/5.all.kaks/kaks.1.txt";
my %k = &get_kaks($kaks);

open O,'>',"z.all.stable.bias.gene.no_homo.lst";
open IN,'<',"z.all.stable.bias.gene.lst" or die "$!";
while(<IN>){
    chomp;
    my @l = split/\t/;
    (my $g1,my $g2) = split/\-/,$l[0];
    if(! exists $k{$g1}||!exists $k{$g2}){
        print O "$l[0]\n";
        next;
    }
    my @t1 = @{$k{$g1}};
    my @t2 = @{$k{$g2}};
    next if $t1[0] eq "no_ks";
    next if $t2[0] eq "no_ks"; 
    if($l[1] eq "S_bias"){
        print "$g1\tS\tdominant\t"."$t1[0]\t$t1[1]"."\t$l[0]\n";
        print "$g2\tD\tsubmissive\t"."$t2[0]\t$t2[1]"."\t$l[0]\n";
    }elsif ($l[1] eq "D_bias") {
        print "$g1\tS\tsubmissive\t"."$t1[0]\t$t1[1]"."\t$l[0]\n";
        print "$g2\tD\tdominant\t"."$t2[0]\t$t2[1]"."\t$l[0]\n";
    }
}

sub get_kaks{
    my $f = shift @_;
    my %h;
    my $d = 0;
    open IN,'<',$f or die "$!";
    D:while(<IN>){
        chomp;
        my @l = split/\t/;
        next if scalar @l != 6;
        my $g = $l[0];
        if ($l[-1] eq "-0.0"){
            $h{$g} = ["no_ks","no_ks"];
            next D;
        }
        my $kaks_ng86 = $l[2]/$l[3];
        my $kaks_yn00 = $l[4]/$l[5];
        $d += 1 if exists $h{$g};
        $h{$g} = [$kaks_ng86,$kaks_yn00];
    }
    close IN;
    #print STDERR $d."\n";
    return %h;
}
