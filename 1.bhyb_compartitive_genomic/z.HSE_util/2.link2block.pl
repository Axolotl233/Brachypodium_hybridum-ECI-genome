#! perl

use warnings;
use strict;
use File::Basename;

my @fs = grep{/txt$/} `find 1.depthlink`;
for my $f (@fs){
    chomp $f;
    (my $name = basename $f) =~ s/1.(.*).hse.link.txt/$1/;
    next if -e "2.link2block/2.$name.hse.link.txt";
    print $name."\n";
    open IN1,'<',$f;
    open O,'>',"2.link2block/2.$name.hse.link.txt";
    while(<IN1>){
        chomp;
        my $ref = "z.bsta-bdis.div5.block.bed";
        my @l = split/\t/;
        open IN2,'<',$ref;
        my @p = ();
        while(<IN2>){
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
        print O join"\t",@l;
        print O "\n";
        close IN2;
    }
    close O;
    close IN1;
}
