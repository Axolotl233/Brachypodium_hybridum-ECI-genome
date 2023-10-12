#! perl

use warnings;
use strict;
use Getopt::Long;
use File::Basename;

(my $col,my $g,my $h,my $v,my $s);

GetOptions(
           'index=s' => \$col,
           'gcompress' => \$g,
           'head=s' => \$h,
           'filter' => \$v,
           'sep=s' => \$s
          );
my $fh;
my $file = shift or die "perl $0 [-i -g -h -f]\n";
my $out_dir = (basename $file).".split";
$s //= "\t";
$col //= 0;
if($g){
    open $fh,"zcat $file |" or die "$!";
}else{
    open $fh,'<',$file;
}

my $head = "";
if($h){
    if($h eq "p"){
        $head = readline $fh;
    }elsif($h eq "un"){
        readline $fh
    }
}

my $con;
my $chr = "NA";

mkdir "$out_dir" if !-e "$out_dir";
while(<$fh>){
    next if /^$/;
    chomp;
    s/^\s+//;
    if($v){
        next if /^#/;
    }
    my @line = split/$s/;
    if($chr ne "NA" && $chr ne $line[$col]){
        mkdir "$out_dir" if ! -e "$out_dir";
        open O,'>',"$out_dir/$chr.split.file";
        print O $head.$con;
        close O;
        $chr = $line[$col];
        $con = $_."\n";
    }else{
        if($chr eq "NA"){
            $chr = $line[$col];
        }
        $con .= $_."\n";
    }
}
mkdir "$out_dir" if ! -e "$out_dir";
open O,'>',"$out_dir/$chr.split.file";
print O $head.$con;
close O;

