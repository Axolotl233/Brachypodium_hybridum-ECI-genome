#! perl

use warnings;
use strict;
use Bio::SeqIO;
use File::Basename;

if(@ARGV == 0){
    print STDERR "perl $0 \$circos_fa \$window\n";
    exit;
}
my $fa = shift;
my $window = shift;
(my $n = basename $fa) =~ s/(.*?)\..*/$1/;
my $n_k = $window/1000;
my $seqio_obj = Bio::SeqIO -> new (-file => $fa,-format => "fasta");
open O,'>',"$n.$n_k"."K.gc.txt";
while(my $seq_obj = $seqio_obj -> next_seq){
    my $name = $seq_obj -> display_id;
    my $seq = $seq_obj -> seq;
    my $length = $seq_obj -> length;
    my $count = 0;
    while($length){
        my $count2 = 0;
        unless($window > $length){
            my $start = ($count * $window)+1;
            my $end = (($count+1) * $window);
            my $line = substr($seq,$start,$window);
            $count2 = $line =~ s/[GCcg]/N/g;
            print O "$name\t".$start;
            print O "\t".$end."\t";
            my $cg = ($count2*100)/$window;
            printf O "%.4f",$cg;
            print O "\n";
            $length = $length - $window;
            $count += 1
        }else{
            my $start = ($count*$window)+1;
            my $end = $start+$length;
            my $line = substr($seq,$start,$length);
            $count2 = $line =~s/[GCcg]/N/g;
            print O "$name\t".$start;
            print O "\t".($end)."\t";
            my $cg = ($count2*100)/$length;
            printf O "%.4f",$cg;
            print O"\n";
            $length = 0;
        }
    }
}
