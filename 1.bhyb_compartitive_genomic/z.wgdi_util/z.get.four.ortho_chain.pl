#! perl

use warnings;
use strict;

my $main_f = shift;
my $extend_f1 = shift;
my $extend_f2 = shift;
my $vaild_f = shift;

my %pe1 = pe_load_extend($extend_f1);
my %pe2 = pe_load_extend($extend_f2);

my %m;
open I1,'<',$main_f;
my %t;
D2:while(<I1>){
    chomp;
    my @l = split /,/;
    if(exists $pe1{$l[0]} && exists $pe2{$l[1]}){
        if(exists $t{$l[0]} || exists $t{$l[1]}){
            next;
        }
        $t{$l[0]} = 1;
        $t{$l[1]} = 1;
        $m{$l[0]} = "$l[1]";
        $m{$l[1]} = "$l[0]";
    }
}
close I1;

my %e1 = load_extend($extend_f1,\%m);
my %e2 = load_extend($extend_f2,\%m);

my @k1 = sort {$a cmp $b} keys %e1;
my @k2 = sort {$a cmp $b} keys %e2;

if (scalar @k1 != scalar @k2){
    print scalar @k1;
    print ":";
    print scalar @k2;
    print "\n";
    exit;
}else{
    print STDERR scalar @k1;
    print STDERR ":";
    print STDERR scalar @k2;
    print STDERR "\n";
}

my %v;
my %tt;
my $n = 0;
for(my $k = 0;$k<scalar @k1;$k++){
    die "?" if $k1[$k] ne $k2[$k];
    my @t3 = split/-/,$k1[$k];
    next if exists $tt{$k1[$k]};
    my $t1 = $e1{$k1[$k]};
    my $t2 = $e2{$k1[$k]};
    $v{"$t1-$t2"} = "$t3[0],$t3[1]";
    $v{"$t2-$t1"} = "$t3[0],$t3[1]";
    $tt{"$t3[1]-$t3[0]"} = 1;
    $n += 1;
}
print STDERR $n;
open I2,'<',$vaild_f;
while(<I2>){
    chomp;
    my @l = split/,/;
    if (exists $v{"$l[0]-$l[1]"}){
        print  $v{"$l[0]-$l[1]"}.",$l[0],$l[1]\n";
    }
}
    
sub load_extend{
    my $f = shift @_;
    my $ref = shift @_;
    my %r = %{$ref};
    my %e;
    open I,'<',$f;
    while(<I>){
        chomp;
        my @l = split /,/;
        if(exists $r{$l[0]}){
            my $tmp = $r{$l[0]};
            $e{"$l[0]-$tmp"} = "$l[1]";
            $e{"$tmp-$l[0]"} = "$l[1]";
        }
    }
    close I;
    return %e
}

sub pe_load_extend{
    my $f = shift @_;
    my %h;
    open I,'<',$f;
    D:while(<I>){
        my @l = split /,/;
        $h{$l[0]} += 1;
        if($h{$l[0]} > 1){
            delete $h{$l[0]};
            next;
        }
    }
    close I;
    return %h;
}
