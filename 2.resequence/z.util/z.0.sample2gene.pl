#! perl

use warnings;
use strict;
use File::Basename;
use Cwd;
use Bio::SeqIO;

my $c_dir = "/data/01/user112/project/Brachypodium/06.chloroplast/Chr_Tree/z.test/0.data";
my @files = grep{/cds.fa/} sort {$a cmp $b} `find $c_dir`;
my %s;my %g;my %h;
open IN,'<',"0.sample.lst";
while(<IN>){
    chomp;
    $s{$_} = 1;
}
my $s_n = scalar(keys %s);
my @s_name = sort {$a cmp $b} keys %s;
close IN;
for my $f (@files){
    chomp $f;
    (my $name = basename $f ) =~ s/(.*?)\..*/$1/;
    next if (! exists $s{$name});
    my $s_obj = Bio::SeqIO -> new (-file => $f, -format => "fasta");
    while(my $s_io = $s_obj -> next_seq){
        my $id = $s_io -> display_id;
        my $seq = $s_io -> seq;
        push @{$g{$id}} ,"$name";
        push @{$h{$id}}, ">$name\n$seq\n";
    }
    $s{$name} += 1;
}
for my $k (keys %s){
    print "$k file have problem " if $s{$k} != 2;
}
mkdir "0.gene.data" if ! -e "0.gene.data";
for my $k (sort {$a cmp $b} keys %h){
    my $t = scalar(@{$g{$k}});
    my @ts = sort {$a cmp $b} @{$g{$k}};
    #print "$k:\n";print join"," ,@s_name;print "\n";print join",", @ts;print "\n\n";
    #print "$k\t$t\t$s_n\n";
    next if ($t != $s_n);
    open O,'>',"0.gene.data/$k.fasta";
    print O $_ for @{$h{$k}};
    print O "\n";
    close O
}
