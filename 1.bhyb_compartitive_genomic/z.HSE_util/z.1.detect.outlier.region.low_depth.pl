#! perl

use warnings;
use strict;
use File::Basename;
use Cwd;
use List::Util qw/max min/;

my $i_dir = shift;
my $f_chr_lst = shift;
#exit if scalar @ARGV != 2;

my $h_dir = getcwd();
my $o = "$i_dir/z.outlier_depth";
mkdir $o unless -e $o;

my $max_fold = 0.3;
my $max_cov = 50;

my %dep = &read_depth("$i_dir/chromosomes.report");
my %chr = &load_chr($f_chr_lst);

my @fs = sort{$a cmp $b} grep {/.split.file$/} `find $i_dir/region.tsv.gz.split`;
for my $f (@fs){
    chomp $f;
    (my $name = basename $f) =~ s/.split.file//;
    next if !exists $chr{$name};
    my $ave_dep = $dep{$name};
    my $max_dep = $ave_dep * $max_fold;
    open IN,'<',$f;
    open O,'>',"$o/$name.low_dep.txt";
    while(<IN>){
        chomp;
        my @l = split/\s+/;
        my $start = $l[1] - 1;
        my $end = $l[2] + 1;
        if($l[3] < $max_dep && $l[5] < $max_cov){
            my $len = $l[2]-$l[1] + 1;
            print O "$l[1]\t$l[2]\t$l[3]\t$l[5]\t$len\n";
        }
    }
    close IN;
    close O;
}

sub load_chr{
    
    my $f = shift @_;
    my %tmp;
    open IN,'<',$f;
    while(<IN>){
        chomp;
        my @l = split/\t/;
        $tmp{$l[0]} = 1;
    }
    return %tmp;
}

sub read_depth{
    my $f = shift @_;
    my %h;
    open I,'<',"$f" or die "$!";
    readline I;
    while(<I>){
        chomp;
        s/\s+//;
        my @l = split/\s+/;
        $h{$l[0]} = $l[2];
    }
    close I;   
    return %h;
}
