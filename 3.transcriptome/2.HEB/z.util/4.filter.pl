#! perl;

open IN,'<',shift;
while(<IN>){
    my $n_l = readline IN;
    if ($_ =~ /no/ || $n_l=~/no/){
        next;
    }else{
        print $_;
        print $n_l;
    }
}
