#!/usr/local/bin/perl

use strict;
use warnings;
use feature qw(say signatures);
use Data::Dumper qw(Dumper);
use Time::HiRes qw(time);

my( $t0, $t1, $t2 ) = ( time, 0, 0 );
my $fn = $0 =~ s{([^/]+\.)pl$}{ 'input/'.$1.(@ARGV ? 'test' : 'txt') }er;
die qq(Missing file "$fn"\n) unless -e $fn;

## Each line of input is a string of digits...
## For each row find the largest number that can be taken by choosing 
## digits (in order they appear) of a given length - #1 length 2, #2 length 12
## e.g. 312 -> 32; 132 -> 32, 132 -> 13 ....
## We go for a recursive approach here - once we have chosen a digit from the
## string - we can then repeat - with the shorter string and 1 less digit to choose.

my %cache;
open my $fh, '<', $fn;
(   %cache = ()             ),
  ( $t1   += jolt( 2,  $_ ) ),
  ( $t2   += jolt( 12, $_ ) )
  while <$fh>;
close $fh;

sub jolt( $c, $l ) {
  my $k = "$c $l";
  return $cache{$k} if exists $cache{$k};
  return '' unless $c--;
  $l =~ m{$_(.{$c,})} && return $cache{$k} = $_.jolt($c,$1) for 9,8,7,6,5,4,3,2,1;
}


printf "%16s %16s %15.6f\n", $t1, $t2, 1000*(time-$t0);

