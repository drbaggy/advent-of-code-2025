#!/usr/local/bin/perl

use strict;
use warnings;
use feature qw(say);
use Data::Dumper qw(Dumper);
use Time::HiRes qw(time);

## See: https://adventofcode.com/2025/day/1

my( $t0, $t1, $t2 ) = ( time, 0, 0 );
my $fn = $0 =~ s{([^/]+\.)pl$}{ 'input/'.$1.(@ARGV ? 'test' : 'txt') }er;
die qq(Missing file "$fn"\n) unless -e $fn;

my $pos = 50;
open my $fh, '<', $fn;
while(<$fh>) {
  chomp;
  my( $loops, $d, $steps ) = (0,m(^([LR])(\d+)$));
  ## Because the dial has 100 positions - the hundreds section
  ##   just counts the number of full rotations... the tens/units
  ##   the number to move the dial by...
  if( $steps =~ m{^(\d+)(\d\d)} ) {
    $loops = $1+0;
    $steps = $2+0;
  }
  $t2    += $loops;  ## So we know we pass zero this number of times
  if( $steps ) {
    my $old_pos = $pos;
    $pos = $pos + ( $d eq 'L' ? -$steps : $steps );
    $t2 ++ if $old_pos && ($pos <= 0 || $pos >= 100 );
          ## We don't count loops where we start on the 0 - as we
          ## have already counted them....
    $pos %= 100;
    $t1 ++ unless $pos;
          ## Task 1 only counts the times we finish on the 0...
  }
}
close $fh;

printf "%16s %16s %15.6f\n", $t1, $t2, 1000*(time-$t0);
