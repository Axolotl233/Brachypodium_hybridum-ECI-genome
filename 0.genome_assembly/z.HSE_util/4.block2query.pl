#! perl

use warnings;
use strict;
use Cwd;

my $h_dir = getcwd();

my %b = &read_bed("Bhyb-merge.div1.block.bed");
open I,'<',"3.block.identify.txt";
mkdir "$0.out" if ! -e "$0.out";
my $c = 0;
while(<I>){
    chdir "$0.out";
    chomp;
    my @l = split/\t/;
    my @chr = split/\-/,$l[0];
    my @loc = split/,/,$l[1];
    my @type = split/\-/,$l[2];
    open O,'>',"$l[0]\_$c.txt";
    $c += 1;
    print O "###\n";
    for(my $i =0 ;$i <=1;$i++){
        my @p = ($chr[$i],$loc[$i],$type[$i]);
        (my $q_s,my $q_e) = split/\-/,$loc[$i];
        my @t1 = sort{$a->[2] <=> $b->[2]} @{$b{$chr[$i]}};
        my @t2;
        push @p , $t1[0] -> [4];
        for my $e (@t1){
            my $r_s = $e -> [0];
            my $r_e = $e -> [1];
            my $b_s = $e -> [2];
            my $b_e = $e -> [3];
            die "$b_s:$b_e\n" if($b_s > $b_e);
            if($r_e > $q_s && $q_e > $r_s){
	push @t2 ,"$b_s-$b_e";
            }
        }
        push @p , (join",",@t2);
        print O join"\t",@p,"\n";
    }
    chdir $h_dir;
}
    
sub read_bed{
    my $f = shift @_;
    my %h;
    open IN,'<',$f;
    while(<IN>){
        chomp;
        my @l = split/\t/;
        push @{$h{$l[0]}}, [$l[1],$l[2],$l[4],$l[5],$l[3]];
    }
    close IN;
    return %h;
}
        
