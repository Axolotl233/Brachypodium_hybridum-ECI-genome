#! perl

use warnings;
use strict;
use Bio::SeqIO;
use File::Basename;
my $fa = shift;
(my $n = basename $fa) =~ s/(.*?)\..*/$1/;
open O,'>',"$n.karyotype.txt";
my $seqio_obj = Bio::SeqIO -> new (-file => $fa, -format=>"fasta");
my %h;
while(my $seq_obj = $seqio_obj-> next_seq){
    my $id = $seq_obj -> display_id;
    my $length = $seq_obj -> length;
    $h{$id} = $length;
}

my $count = 1;
for my $k (sort {$a cmp $b} keys %h){    
    print O "chr - $k Chr$count 0 $h{$k} chr$count\n";
    $count ++;
}
close O;
