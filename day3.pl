#!/usr/local/bin/perl

use strict;
use warnings;
use feature qw(say signatures);
use Data::Dumper qw(Dumper);
use Time::HiRes qw(time);

my( $t0, $t1, $t2 ) = ( time, 0, 0 );
my $fn = $0 =~ s{([^/]+\.)pl$}{ 'input/'.$1.(@ARGV ? 'test' : 'txt') }er;
die qq(Missing file "$fn"\n) unless -e $fn;

open my $fh, '<', $fn;
($t1 += jolt( 2,  $_ )), ($t2 += jolt( 12, $_ )) while <$fh>;
close $fh;

sub jolt( $c, $l ) {
  return '' unless $c--;
  $l =~ m{$_(.{$c,})} && return $_.jolt($c,$1) for reverse 0..9
}

printf "%16s %16s %15.6f\n", $t1, $t2, 1000*(time-$t0);

__END__
my $fn = $0 =~ s{([^/]+\.)pl$}{ 'input/'.$1.(@ARGV ? 'test' : 'txt') }er;
die qq(Missing file "$fn"\n) unless -e $fn;

open my $fh, '<', $fn;
while(<$fh>) {
  chomp;
}
close $fh;

