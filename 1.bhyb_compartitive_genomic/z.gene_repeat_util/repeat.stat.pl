#! perl

use warnings;
use strict;
use MCE::Loop;
use File::Basename;
use List::Util qw(sum);

my $g_dir = "gene";
my $r_dir = "repeat";

my $thread_mce = shift;
$thread_mce //= 15;
MCE::Loop::init {chunk_size => 1,max_workers => $thread_mce,};
my @files = sort{$a cmp $b} `ls $g_dir`;
chomp $_ for @files;
my $up_down = shift;
$up_down //= 2000;

my $out1 = "01.summmary";
my $out2 = "02.gene_stat";
mkdir "$out1" if ! -e "$out1";
mkdir "$out2" if ! -e "$out2";

mce_loop{ &run($_) } @files;

sub run{
    my $f = shift @_;
    my $g_f = "$g_dir/$f";
    my $r_f = "$r_dir/$f";
    (my $name = $f) =~ s/(.*?)\..*/$1/;
    print STDERR "====> analysis $name\n";
    my %h;
    open my $r_in,'<',$r_f or die "$!";
    while (<$r_in>) {
        chomp;
        my @l = split/\t/;
        for(my $i = $l[1];$i <= $l[2];$i += 1){
            $h{$l[0]}{$i} += 1;
        }
    }
    close $r_in;
    open my $g_in,'<',$g_f or die "$!";
    my @rate1;
    my @rate2;
    my @rate3;
    my @gene_res;
    while(<$g_in>){
        chomp;
        my @l = split/\t/;
        my $s = $l[2] - $up_down;
        my $e = $l[3] + $up_down;
        my $c1 = 0;
        my $c2 = 0;
        my $c3 = 0;
        for(my $i = $s;$i <= $l[2];$i += 1){
            $c1 += 1 if(exists $h{$l[0]}{$i});
        }
        for(my $i = $l[2];$i <= $l[3];$i += 1){
            $c2 += 1 if(exists $h{$l[0]}{$i});
        }
        for(my $i = $l[3];$i <= $e;$i += 1){
            $c3 += 1 if(exists $h{$l[0]}{$i});
        }
        my $rate1 = $c1/$up_down;
        my $rate2 = $c2/($l[3]-$l[2]+1);
        my $rate3 = $c3/$up_down;
        push @rate1 , $rate1;
        push @rate2 , $rate2;
        push @rate3 , $rate3;
        push @l,($rate1,$rate3,$rate2);
        push @gene_res, (join"\t",@l);
    }
    close $g_in;
    my $sum1 = sum(@rate1);
    my $sum2 = sum(@rate2);
    my $sum3 = sum(@rate3);
    my $g_n = scalar(@rate1);
    my $cov1 = $sum1/$g_n;
    my $cov2 = $sum2/$g_n;
    my $cov3 = $sum3/$g_n;
    open my $o,'>',"$out1/$name.out";
    print $o "$name\tup\t$cov1\n";
    print $o "$name\tgene\t$cov2\n";
    print $o "$name\tdown\t$cov3\n";
    close $o;
    open my $o2,'>',"$out2/$name.out";
    print $o2 $_."\n" for @gene_res;
    close $o2;
}
