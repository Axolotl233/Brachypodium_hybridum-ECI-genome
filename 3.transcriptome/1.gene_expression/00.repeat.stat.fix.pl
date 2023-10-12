#! perl

use warnings;
use strict;
use MCE::Loop;
use File::Basename;
use List::Util qw(sum);

my $g_dir = "00.data/Bhyb_gene";
my $r_dir = "00.data/Bhyb_repeat/";

my $thread_mce = shift;
$thread_mce //= 5;
MCE::Loop::init {chunk_size => 1,max_workers => $thread_mce,};
my @files = sort{$a cmp $b} `ls $g_dir`;
chomp $_ for @files;
my $up_down = shift;
$up_down //= 2000;

#my $out1 = "01.summmary";
my $out2 = "01.gene_stat";
#mkdir "$out1" if ! -e "$out1";
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
        (my $sub = $l[0])=~s/Bh([DS])\d+/$1/;
        my $s = $l[2] - $up_down;
        if($s < 0){
            $s = 0;
        }
        my $e = $l[3] + $up_down;
        my $len = $e - $s + 1;
        my $c = 0;
        for(my $i = $s;$i <= $e;$i += 1){
            $c += 1 if(exists $h{$l[0]}{$i});
        }
        my $rate = $c/$len;
        push @l,($rate,$sub);
        push @gene_res, (join"\t",@l);
    }
    close $g_in;
    open my $o2,'>',"$out2/$name.out";
    print $o2 $_."\n" for @gene_res;
    close $o2;
}
