#! perl

use warnings;
use strict;
use File::Basename;
use List::Util qw/sum/;

my $tpm = "/data/01/user112/project/Brachypodium/07.evo/07.bhyb_subgenome_bias/1.gene_expression/0.data/Bhyb.tpm.txt";
my $group = "/data/01/user112/project/Brachypodium/07.evo/07.bhyb_subgenome_bias/1.gene_expression/0.data/Sample.txt";
my %tpm = &load_tpm($tpm);
my %group = &load_group($group);

while(1){
    print "==> please input gene name\n";
    chomp(my $g = <STDIN>);
    print "\n==> please input group info\n";
    chomp(my $o = <STDIN>);
    my @y = split/\s+/,$o;
    print "==> gene expression:\n";
    my @ave;
    my @head = ();
    my @tmp =();
    for my $v (@y) {
        my $sum = 0;
        for my $s (@{$group{$v}}){
            push @head,$s;
            my $n= sprintf("%.4f",$tpm{$s}{$g});
            push @tmp,$n;
            $sum += $n
        }
        my $j = sprintf("%.4f", ($sum/(scalar @{$group{$v}})) );
        push @ave, $j;
    }
    push @head , @y;
    push @tmp ,@ave;
    for(my $i = 0;$i < @head;$i++){
        print "$head[$i]\t$tmp[$i]\n";
    }
}


sub load_tpm{
    my $f = shift;
    my %h;
    open IN,'<',$f;
    chomp(my $tmp = readline IN);
    my @head = split/\t/,$tmp;
    while(<IN>){
        chomp;
        my @l = split/\t/,$_;
        my $g = $l[0];
        for(my $i = 1 ;$i < @l;$i++){
            $h{$head[$i]}{$g} = $l[$i];
        }
    }
    close IN;
    return %h;
}
sub load_group{
    my $f = shift;
    my %h;
    open IN,'<',$f;
    readline IN;
    while(<IN>){
        s/\r\n//;
        chomp;
        next if /^#/;
        my @l = split/\t/,$_;
        my $g = $l[1];
        push @{$h{$g}} , $l[0];
    }
    close IN;
    return %h;
}
