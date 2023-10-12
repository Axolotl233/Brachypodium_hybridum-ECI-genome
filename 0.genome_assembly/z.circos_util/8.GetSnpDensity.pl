#! perl

use warnings;
use strict;

print STDERR "perl $0 \$karyotype.txt \$vcf_file \[\$window]\n";

open IN,'<',shift or die "need karyotype\n";
my %h;
while(<IN>){
    my @line = split/\s+/,$_;
    $h{$line[2]} = $line[5];
}
close IN;

my $vcf = shift or die "need vcf\n";
my %v;
open IN,"cat $vcf |";
while(<IN>){
    next if /^#/;
    my @l = split/\t/;
    $v{$l[0]}{$l[1]} = 1;
}
close IN;

my $window = shift;
$window //= 100000;
open O,'>',"$0.1.txt";
for my $key (sort keys %h){
    my $length = $h{$key};
    my $count = 0;
    my @m = sort{$a <=> $b} keys %{$v{$key}};
    while($length > 0){
        my $j = 1;
        my $count2 = 0;
        $j = 2 if $length < $window;
        #print "$length\n";
        my $start = ($count * $window);
        my $end = ($j == 1)?(($count+1) * $window):$length+$start;
        for my $v(@m){
            if($v >= $start && $v < $end){
	$count2 += 1;
            }
        }
        print O "$key\t$start\t$end\t$count2\n";
        $count += 1;
        $length = $length - $window;
    }
}
