#! perl

use warnings;
use strict;

my $ref_file = shift;
my $treat_file = shift;
my $prefix = shift;

my %r;
my @g_p;
open IN,'<',$ref_file or die $!;
readline IN;
while(<IN>){
    my @l = split/\t/;
    next if $l[4] eq "no_bias";
    next if $l[5] eq "Low";
    my $t = -1;
    if ($l[4] eq "S_bias"){
        $t = 1;
    }
    $r{$l[2]}{ref} = [$l[3],$l[4],$t];
    push @g_p,$l[2];
}
close IN;
open IN,'<',$treat_file or die $!;
readline IN;
while(<IN>){
    my @l = split/\t/;
    next if $l[4] eq "no_bias";
    next if $l[5] eq "Low";
    my $t = -1;
    if ($l[4] eq "S_bias"){
        $t = 1;
    }
    $r{$l[2]}{tre} = [$l[3],$l[4],$t];
    push @g_p,$l[2];
}
close IN;
my %f;
for my $e(@g_p){
    $f{$e} += 1;
}
@g_p = sort {$a cmp $b} keys %f;

for my $e(@g_p){
    my @p;
    push @p, $e;
    if(exists $r{$e}{ref} && exists $r{$e}{tre}){
        push @p,"all";
        my @re = @{$r{$e}{ref}};
        my @tr = @{$r{$e}{tre}};
        if($re[1] ne $tr[1]){
            push @p,"change";
            if($re[2] == 1){
	push @p,"StoD";
            }else{
	push @p,"DtoS";
            }
        }else{
            push @p,"same";
            if($re[2] == 1){
	push @p,"S";
            }else{
	push @p,"D";
            }
        }
        push @p ,($re[0],$tr[0]);
    }else{
        if(exists $r{$e}{ref}){
            my @re = @{$r{$e}{ref}};
            if($re[2] == 1){
	push @p,("control","NA","S");
            }else{
	push @p,("control","NA","D");
            }
            push @p ,($re[0],"NA");
        }
        if(exists $r{$e}{tre}){
            my @tr = @{$r{$e}{tre}};
            if($tr[2] == 1){
	push @p,("treatment","NA","S");
            }else{
	push @p,("treatment","NA","D");
            }
            push @p ,("NA",$tr[0]);
        }
    }
    print (join"\t",@p);
    print "\n";
}
