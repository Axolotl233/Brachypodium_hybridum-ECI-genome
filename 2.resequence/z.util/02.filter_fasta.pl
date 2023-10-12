#! perl

use warnings;
use strict;
use Bio::SeqIO;

my $thre = 0.2;
my $group = "z.sample.lst";
my %fa;

my %gr = &get_group($group);
my $sam_num = 0;
for my $f (@ARGV){
    chomp $f;
    my $s_obj = Bio::SeqIO -> new (-file => $f, -format => "fasta");
    while(my $s_io = $s_obj -> next_seq){
        my $id = $s_io -> display_id;
        my $new_id;
        if (exists $gr{$id}){
            $new_id = $gr{$id};
        }else{
            $new_id = $id;
        }
        my $seq = $s_io -> seq;
        my @split = split//,$seq;
        for (my $i = 0;$i < @split;$i++){
            $fa{$i}{$new_id} = $split[$i];
        }
        $sam_num += 1;
    }
    undef $s_obj;
}
my %out;
for my $pos (sort {$a <=> $b} keys %fa){
    my %t;
    $t{"-"} = 0;
    for my $sam (sort {$a cmp $b}keys %{$fa{$pos}}){
        my $base = $fa{$pos}{$sam};
        $t{$base} += 1;
    }
    my $miss = ($t{"-"})/$sam_num;
    next if $miss > $thre;
    for my $sam (sort {$a cmp $b}keys %{$fa{$pos}}){
        my $base = $fa{$pos}{$sam};
        $out{$sam} .= $base;
    }
}
print ">$_\n$out{$_}\n" for sort{$a cmp $b} keys %out;

sub get_group{
    my $f = shift @_;
    my %h;
    open IN,'<',"$f";
    while(<IN>){
        chomp;
        my @l = split/\t/;
        $h{$l[0]} = $l[1];
    }
    close IN;
    return %h;
}
