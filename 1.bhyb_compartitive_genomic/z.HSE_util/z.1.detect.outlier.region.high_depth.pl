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

my $min_cov = 40;
my $min_depth = 10;
my $max_depth = 200;

my %chr = load_chr($f_chr_lst);

my @fs = sort{$a cmp $b} grep {/.split.file$/} `find $i_dir/region.tsv.gz.split`;
for my $f (@fs){
    chomp $f;
    (my $name = basename $f) =~ s/.split.file//;
    
    next if !exists $chr{$name};
    open IN,'<',$f;
    open O,'>',"$o/$name.high_dep.txt";
    while(<IN>){
        chomp;
        my @l = split/\s+/;
        my $start = $l[1];
        my $end = $l[2];
        if($l[5] > $min_cov && $l[3] > $min_depth){
            if($l[3] < $max_depth){
	my $len = $l[2]-$l[1] + 1;
	print O "$l[1]\t$l[2]\t$l[3]\t$l[5]\t$len\n";
            }
        }
    }
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
