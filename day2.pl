#!/usr/local/bin/perl

use strict;
use warnings;
use feature qw(say signatures);
use Data::Dumper qw(Dumper);
use Time::HiRes qw(time);

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

open my $fh, '<', $fn;
my $C;
for( map { [ split /-/ ] } <$fh>=~ m{(\d+-\d+)}g ) {
  my( $s, $e ) = @{$_};
  while( length $e > length $s ) {
    _r( $s, -1 + 10**(length $s) );
    $s = 10 ** length $s;
  }
  _r( $s, $e );
}
close $fh;

sub _r( $s, $e ) {
  my %seen;
  for my $ch ( @{$l[ length $s ]} ) {
    my($sl, $mul, $f, $m) = @{$ch};
    my $x = (substr $s,0,$sl) * $mul;
    ( $x >= $s ) && ( $t1 += $x*$f, $t2 += $m*$x ), $x += $mul while $x <= $e
  }
}

printf "%16s %16s %15.6f\n", $t1, $t2, 1000*(time-$t0);
