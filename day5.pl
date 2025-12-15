#!/usr/local/bin/perl

use strict;
use warnings;
use feature qw(say signatures);
use Data::Dumper qw(Dumper);
use Time::HiRes qw(time);

my( $t0, $t1, $t2 ) = ( time, 0, 0 );
my $fn = $0 =~ s{([^/]+\.)pl$}{ 'input/'.$1.(@ARGV ? 'test' : 'txt') }er;
die qq(Missing file "$fn"\n) unless -e $fn;

my ( @l, @ranges ) = ( 0, -1 );

open my $fh, '<', $fn;
while(<$fh>) {
  next unless my @p = m{(\d+)}g;
  if( @p > 1 ) {
    push @ranges,\@p;
  } else {
    $p[0] > $_->[0] && $p[0] <= $_->[1] && ++$t1 && last for @ranges;
  }
}
close $fh;
                  ## New range doesn't overlap old range       ## Overlaps & extends...
$_->[0] > $l[1] ? ( ( $t2 += $l[1] - $l[0] + 1 ), @l=@{$_} ) : $l[1] < $_->[1] && ( $l[1] = $_->[1] )
      ## Sort into start order
  for sort { $a->[0] <=> $b->[0] } @ranges;

$t2 += $l[1] - $l[0] + 1; ## Add the last range length in!!

printf "%16s %16s %15.6f\n", $t1, $t2, 1000*(time-$t0);

