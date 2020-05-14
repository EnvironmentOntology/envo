#!/usr/bin/perl
while (<>) {
    chomp;
    if (m@^id: ENVO:(\d+)@) {
        $n = int($1);
        if ($seen{$n}) {
            warn "DUPLICATE: $seen{$n} == $_";
            $bad++;
        }
        $seen{$n} = $_;
    }
}
if ($bad) {
    print STDERR "DUPES: $bad\n";
    exit 1;
}
