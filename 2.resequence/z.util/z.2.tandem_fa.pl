#! perl

use warnings;
use strict;
use File::Basename;
use Bio::SeqIO;

my $out = "2.tandem_out";
mkdir $out if ! -e $out;
my @files = sort {$a cmp $b } grep {/.mafft.fas/} `find 1.mafft`;
my %h;
my @g_list;
for my $f (@files){
    chomp $f;
    (my $name = basename $f) =~ s/(.*?)\..*/$1/;
    my $s_obj = Bio::SeqIO -> new (-file => $f, -format => "fasta");
    while(my $s_io = $s_obj -> next_seq){
        my $id = $s_io -> display_id;
        my $seq = $s_io -> seq;
        $h{$id} .= "$seq";
    }
    push @g_list, $name;
}
my $p = "";
for my $k (sort {$a cmp $b } keys %h){
    $p .= ">$k\n$h{$k}\n";
}
open O,'>',"$out/All.gene.fasta";
print O $p;
close O;
open O,'>',"$out/All.gene.list";
print O $_."\n" for @g_list;
close O;
open O,'>',"$out/0.run.sh";
print O "raxmlHPC-PTHREADS -s ./All.gene.fasta -n All.gene -m GTRGAMMAI -f a -x 12345 -N 100 -p 12345 -T 20";
close O;
