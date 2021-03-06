#!/usr/bin/env perl
use v5.14;
use JSON;

my @concepts;
my $base = "https://www.ixtheo.de/classification/";

while (<>) {
    my ( $notation, $label );

    if ( $_ =~ /<a href="\/classification[^>]+>([A-Z]+) ([^<]+)</ ) {
        ( $notation, $label ) = ( $1, $2 );
    }
    elsif ( $_ =~ /<li><em>([A-Z]+) ([^<]+)/ ) {
        ( $notation, $label ) = ( $1, $2 );
    }
    else {
        next;
    }

    my $uri     = "$base$notation";
    my %concept = (
        uri       => $uri,
        notation  => [$notation],
        prefLabel => { en => $label },
        inScheme  => [ { uri => $base } ],
    );

    if ( length $notation > 1 ) {
        $concept{broader} = [ { uri => substr $uri, 0, length($uri) - 1 } ];
    }

    push @concepts, \%concept;
}

say JSON->new->pretty->encode( \@concepts );
