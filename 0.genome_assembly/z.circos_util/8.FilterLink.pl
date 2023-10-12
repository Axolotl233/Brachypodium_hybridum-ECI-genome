#! perl

use warnings;
use strict;
use File::Basename;

if(@ARGV != 3){
    print STDERR "perl $0 \$ky1 \$ky2 \$link\n";
    exit;
}
(my $ky1,my $ky2,my $link) = @ARGV;
my %h1 = &get_karyotype($ky1);
my %h2 = &get_karyotype($ky2);

open IN,'<',$link;
(my $n = basename $link) =~ s/(.*)\..*/$1/;
open O,'>',"$n.fix.txt";
while(<IN>){
    my @l = split/\t/;
    next if (exists $h1{$l[0]} && exists $h1{$l[3]});
    next if (exists $h2{$l[0]} && exists $h2{$l[3]});
    print O $_;
}
close O;

sub get_karyotype{
    my $f = shift @_;
    open IN,'<',$f;
    my %t;
    while(<IN>){
        chomp;
        my @l = split/\s/;
        $t{$l[2]} = 1;
    }
    close IN;
    return %t;
}
