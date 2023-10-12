#!/usr/bin/perl
use strict;
use warnings;
use Bio::SeqIO;

my ($ingenbank,$outprefix)=@ARGV;
die "perl $0 input_genbank outprefix\n" if (! $outprefix);

my %h;
my $seq;
open (F,"$ingenbank");
while (<F>) {
    chomp;
    s/^\s+//;
    if (/^CDS\s+\S+\.\.\S+/){
        my $line=$_;
        my %flt;
        my $strand="+";
        $strand="-" if $line=~/complement/;
        while ($line=~/(\d+)\.\.(\d+)/g) {
            $flt{cds}{$1}=$2;
        }
        my $trans=0;
        while (<F>) {
            chomp;
            s/^\s+//;
            last if $trans == 1;
            if (/^\/gene=['"]([^"']+)["']/){
		$flt{geneid}=$1;
		$trans++;
            }elsif (/^\/(protein_id|locus_tag)=["']([^"']+)["']/){
		#$flt{protein_id}=$2;
            }elsif (/^\/translation=["']([^"']+)/){
	#$flt{protein} .= $1;
		#$trans++;
		#$trans++ if $_=~/["']$/;
            }elsif ($trans == 1){
		#$flt{protein} .= $_;
		#$trans++ if $_=~/['"]$/;
            }
        }
        my ($geneid)=($flt{geneid});
        #print "($geneid,$protein_id,$protein)\n";
        #$protein=~s/\"//g;
        #$protein=~s/\'//g;
        $h{$geneid}{protein_id}=$geneid;
        #$h{$geneid}{protein}=$protein;
        $h{$geneid}{strand}=$strand;
        for my $ks (sort keys %{$flt{cds}}){
            $h{$geneid}{cds}{$ks}=$flt{cds}{$ks};
        }
    }
    if (/^\d+\s+[agct]/){
        $_=~s/\d+|\s+//g;
        $seq .= uc($_);
    }
}

#open (O,">$outprefix.pep.fa");
#for my $k (sort keys %h){
#    print O ">$k\t$h{$k}{protein_id}:$h{$k}{strand}\n$h{$k}{protein}\n";
#}
#close O;

open (O,">$outprefix.cds.fa");
for my $k (sort keys %h){
    my $strand=$h{$k}{strand};
    my $outcds;
    my @cds=sort{$a<=>$b} keys %{$h{$k}{cds}};
    for my $cdss (@cds){
        my $cdse=$h{$k}{cds}{$cdss};
        my $len=$cdse-$cdss+1;
        my $subseq=substr($seq,$cdss-1,$len);
        $outcds .= $subseq;
    }
    if ($strand eq '-'){
        $outcds = reverse $outcds;
        $outcds=~tr/[AGCT]/[TCGA]/;
    }
    print O ">$k\t$h{$k}{protein_id}:$strand\n$outcds\n";
}
close O;
