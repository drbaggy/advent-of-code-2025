#!/usr/local/bin/perl

use strict;
use warnings;
use feature qw(say signatures);
use Data::Dumper qw(Dumper);
use Time::HiRes qw(time);

my( $t0, $t1, $t2 ) = ( time, 0, 0 );
my $fn = $0 =~ s{([^/]+\.)pl$}{ 'input/'.$1.(@ARGV ? 'test' : 'txt') }er;
die qq(Missing file "$fn"\n) unless -e $fn;

my( @cl,@vs,@ch,$c);

open my $fh, '<', $fn;
while(<$fh>) {
  chomp;
  if( m{\d} ) {
    $c = 0; push @{$cl[ $c++]}, $_                   for split;
    $c = 0; ( $_ eq ' ' ) || ( $vs[$c] .= $_ ), $c++ for split //;
    next;
  }
  $_ ? push( @{$ch[-1]}, $_ ) : ( push @ch, [] ) for 0, @vs;
  $t1 += e( $_, @{ shift @cl }), $t2 += e( $_, @{ shift @ch   }) for split
}
close $fh;

sub e( $op, $v, @x ) {
  if( $op eq '+' ) { $v += $_ for @x } else { $v *= $_ for @x }
  $v
}


printf "%16s %16s %15.6f\n", $t1, $t2, 1000*(time-$t0);

