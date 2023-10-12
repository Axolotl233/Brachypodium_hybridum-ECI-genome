# perl

use warnings;
use strict;
use File::Basename;
my $out = "1.mafft";
mkdir $out if ! -e $out;
map {chomp;(my $name = basename $_) =~ s/(.*?)\..*/$1/; print "mafft --auto $_ > $out/$name\.mafft.fas\n"}
grep {/fasta/}
my @a = `find ./0.gene.data -print`;
