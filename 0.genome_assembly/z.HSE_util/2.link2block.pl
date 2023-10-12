#! perl

use warnings;
use strict;

while(<>){
    chomp;
    my $f = "Bdis-Bsta.5div.block.bed";
    my @l = split/\t/;
    open IN,'<',$f;
    my @p = ();
    while(<IN>){
        chomp;
        my @t = split/\t/;
        if ($l[0] eq $t[0]){
            if($t[2]>=$l[3] && $l[4]>=$t[1]){
	push @p,"$t[1]-$t[2]";
            }
        }elsif($l[0] eq $t[3]){
            if($t[5]>=$l[3] && $l[4]>=$t[4]){
	push @p,"$t[4]-$t[5]";
            }
        }
    }
    if(@p > 0){
        my $p_t = join",",@p;
        push @l,$p_t;
    }
    print join"\t",@l;
    print "\n"
}
    
