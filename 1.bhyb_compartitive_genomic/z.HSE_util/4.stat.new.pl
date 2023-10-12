#! perl

use warnings;
use strict;
use File::Basename;


my $dir = "1.depthlink";
my %sam = &read_table("z.sample.lst");
my %sub = &read_table("z.chr_sub.lst");

for my $k1 (sort {$a cmp $b} keys %sam){
    my $gr = $sam{$k1};
    my $f_dup = "$dir/1.$k1.dup.hse.link.txt";
    my $f_del = "$dir/1.$k1.del.hse.link.txt";
    my %h_dup = &summary_f($f_dup);
    my %h_del = &summary_f($f_del);
    for my $k2 ("S","D"){
        #open O,'>>',"4.stat.$k2.txt";
        #my $gr2 = $sub{$k2};
        print join"\t",($k1,$h_del{$k2}{"c"},$h_dup{$k2}{"c"},$h_del{$k2}{"l"},$h_dup{$k2}{"l"},$gr,$k2);
        print  "\n";
        #close O; 
    }
}

sub read_table{
    my $f = shift @_;
    open IN,'<',"$f";
    my %h;
    while(<IN>){
        chomp;
        my @l = split/\t/;
        $h{$l[0]} = $l[1];
    }
    close IN;
    return(%h);
}

sub summary_f{
    my $f = shift @_;
    open IN,'<',$f;
    my %h;
    while(<IN>){
        chomp;
        my @l = split/\t/;
        my $len = $l[4] - $l[3];
        my $sub_g = $sub{$l[0]};
        $h{$sub_g}{"c"} += 1;
        $h{$sub_g}{"l"} += $len;
    }
    close IN;
    return %h;
}
