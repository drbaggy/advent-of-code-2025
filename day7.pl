#!/usr/local/bin/perl

use strict;
use warnings;
use feature qw(say signatures);
use Data::Dumper qw(Dumper);
use Time::HiRes qw(time);

my( $t0, $t1, $t2 ) = ( time, 0, 0 );
my $fn = $0 =~ s{([^/]+\.)pl$}{ 'input/'.$1.(@ARGV ? 'test' : 'txt') }er;
die qq(Missing file "$fn"\n) unless -e $fn;

=cut
.......S.......
...............
.......^.......
...............
......^.^......
...............
.....^.^.^.....
...............
....^.^...^....
=cut

## A beam enters at S if it hit's a "^" it gets split into two beams
## one 1 dot to the left and 1 dot to the right
## Task 1 count the different number times the beam is split
##    this is the number of "^" it hit...
## Task 2 count the total different beam patterns....
##    when we hit a splitter we need to count the number of values in..
$t2 = 1;
open my $fh, '<', $fn;
my @c = map { $_ eq 'S' ? 1 : 0 } split //,<$fh>;
for(<$fh>) {
  chomp;
  next unless $_;
  my @d = map { 0 } my @e = map { 0 } my @l = split //,$_;
  for( 0 .. $#c ) {
    next unless $c[$_];
      ## Hit the splitter
    if( $l[$_] eq '^' ) {
      ## Move beams left and right...
      $t1++;        $d[$_-1]  = 1;      $d[$_+1]  = 1;
      $t2+= $c[$_]; $e[$_-1] += $c[$_]; $e[$_+1] += $c[$_];
    } else {
      ## Move beam down
      $d[$_] = 1;
      $e[$_] += $c[$_];
    }
  }
  ## Update states
  @c=@e;
}
close $fh;

printf "%16s %16s %15.6f\n", $t1, $t2, 1000*(time-$t0);

