#! perl

use strict;
use warnings;
use File::Basename;
use List::Util qw/max min/;

my %low;
my %high;

for my $dir(@ARGV){
    my $n = basename $dir;
    my @fs = sort{$a cmp $b} grep{/txt$/} `find $dir/z.outlier_depth`;
    for my $f (@fs){
        chomp $f;
        my @tmp1 = split/\./,(basename $f);
        open IN,'<',$f;
        while(<IN>){
            chomp;
            my @l = split/\t/,$_;
            if($tmp1[1] eq "low_dep"){
	push @{$low{$tmp1[0]}{$l[0]}{$l[1]}},$n;
	#print O1 "$tmp1[0]\t$l[0]\t$l[1]\t$l[2]\t$l[3]\t$n\n";
            }elsif($tmp1[1] eq "high_dep"){
	push @{$high{$tmp1[0]}{$l[0]}{$l[1]}},$n;
	#print O2 "$tmp1[0]\t$l[0]\t$l[1]\t$l[2]\t$l[3]\t$n\n";
            }
        }
    }
}

&print_res("1.outlier_low_dep.txt",\%low);
&print_res("1.outlier_high_dep.txt",\%high);

sub print_res{
    my $o = shift;
    open O,'>',$o;
    my $ref = shift;
    my %h = %{$ref};
    for my $k1 (sort {$a cmp $b} keys %h){
        for my $k2 (sort {$a <=> $b} keys %{$h{$k1}}){
            for my $k3 (sort {$a <=> $b} keys %{$h{$k1}{$k2}}){
	print O "$k1\t$k2\t$k3\t";
	print O join",",@{$h{$k1}{$k2}{$k3}};
	print O "\n";
            }
        }
    }
}
