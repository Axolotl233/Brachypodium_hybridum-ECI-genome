#! perl

use warnings;
use strict;
use File::Basename;

if(@ARGV != 3){
    print STDERR "perl $0 \$repeat \$karyotype \$window\n";
    exit;
}
(my $repeat,my $karyotype,my $window) = @ARGV;
(my $n = basename $karyotype) =~ s/(.*?)\..*/$1/;
my $n_k = $window/1000;
open IN,'<',$repeat or die "$!" ;
my %h;
while(<IN>){
    next unless /^\w/;
    chomp;
    my @line = split/\t/;
    for(my $i = $line[1];$i<$line[2];$i++){
        $h{$line[0]}{$i} ++;
    }
}
close IN;
open IN,'<',$karyotype or die "$!";
my %h2;
while(<IN>){
    my @line = split/\s+/;
    $h2{$line[2]} = $line[5];
}
open O,'>',"$n.$n_k"."K.repeat.txt";
for my $key(sort keys %h2){
    my $length = $h2{$key};
    my $count = 0;
    while($length > 0){
        my $j = 1;
        my $count2 = 0;
        $j = 2 if $length < $window;
        my $start = ($count * $window);
        my $end = ($j == 1)?(($count+1) * $window):$length+$start;
        for(my $i = $start;$i<$end;$i++){
            $count2 ++ if exists $h{$key}{$i};
        }
        my $rate = ($count2 * 100)/$window;
        print O "$key\t$start\t$end\t";
        printf O "%.2f",$rate;
        print O "\n";
        $count += 1;
        $length = $length - $window;
    }
}
