#!/usr/local/bin/perl

use strict;
use warnings;
use feature qw(say signatures);
use Data::Dumper qw(Dumper);
use Time::HiRes qw(time);

## See: https://adventofcode.com/2025/day/2

## A bit of a cheat here - manually create the list of multipliers which
## correspond to numbers that are of the form ^(.*){2+}$
## So 1 means that the numbe is of the form aaaaaaaaaa
##    2 means that it is the form           ababababab
##    etc
## The 2nd number is the multiplier for that length of string -
##    so for 4 - 101 gives you 1010 1111 1212 ... 1919 2020 ....
## 3rd number just indicates if the pattern is repeated twice
## 4th number is to avoid caching - so e.g. for length 6
##   We have length 2 & length 3 loops ababab & abcabc... In both
##   cases we count aaaaaa, and so we count aaaaaa twice so we
##   have to "uncount" these once... same for the case for
##   length 10.
my @l = (
   [],
   [],
   [ [ 1,         11, 1,  1 ] ], # 2
   [ [ 1,        111, 0,  1 ] ], # 3
   [ [ 2,        101, 1,  1 ] ], # 4
   [ [ 1,      11111, 0,  1 ] ], # 5
   [ [ 2,      10101, 0,  1 ],
     [ 3,       1001, 1,  1 ],
     [ 1,     111111, 0, -1 ] ], # 6
   [ [ 1,    1111111, 0,  1 ] ], # 7
   [ [ 4,      10001, 1,  1 ] ], # 8
   [ [ 3,    1001001, 0,  1 ] ], # 9
   [ [ 2,  101010101, 0,  1 ],
     [ 5,     100001, 1,  1 ],
     [ 1, 1111111111, 0, -1 ] ] # 10
);

my( $t0, $t1, $t2 ) = ( time, 0, 0 );
my $fn = $0 =~ s{([^/]+\.)pl$}{ 'input/'.$1.(@ARGV ? 'test' : 'txt') }er;
die qq(Missing file "$fn"\n) unless -e $fn;

## read in data of the form - 11-22,95-115 - split ranges which have different
## lengths e.g. 95-115 -> 95-99 & 100->115.. As how we approach this depends
## on length...
open my $fh, '<', $fn;
my $C;
for( map { [ split /-/ ] } <$fh>=~ m{(\d+-\d+)}g ) {
  my( $s, $e ) = @{$_};
  while( length $e > length $s ) {
    _r( $s, -1 + 10**(length $s) ); ## Process range
    $s = 10 ** length $s;           ## update start
  }
  _r( $s, $e ); ## process whats left...
}
close $fh;

sub _r( $s, $e ) {
  for my $ch ( @{$l[ length $s ]} ) {
    my($sl, $mul, $f, $m) = @{$ch};
    my $x = ( substr $s, 0, $sl ) * $mul;
    ## Loop through until we pass the "$e" value, adding up the counts
    ## see flags above (obviously the start of the loop may be less than
    ## start of the interval so skip counting those values...
    ( $x >= $s ) && ( $t1 += $x*$f, $t2 += $m*$x ), $x += $mul while $x <= $e
  }
}

printf "%16s %16s %15.6f\n", $t1, $t2, 1000*(time-$t0);
