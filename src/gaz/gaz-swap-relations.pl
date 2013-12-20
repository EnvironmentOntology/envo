#!/usr/bin/perl
$n=0;
while(<>) {
    if (/^\[Typedef/ && $n==0) {
        $n++;
    }
    if (/^ontology/ && $n==1) {
        $n = 2;
        next;
    }
    
    if ($n == 1) {
        next;
    }
    print;
}

# /gaz-swap-relations.pl gaz-in.obo gaz-relations.obo > gaz-out.obo
