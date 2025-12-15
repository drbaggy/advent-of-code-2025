#!/usr/local/bin/perl

use strict;
use warnings;
use feature qw(say signatures);
use Data::Dumper qw(Dumper);
use Time::HiRes qw(time);

my( $t0, $t1, $t2 ) = ( time, 0, 0 );
my $fn = $0 =~ s{([^/]+\.)pl$}{ 'input/'.$1.(@ARGV ? 'test' : 'txt') }er;
die qq(Missing file "$fn"\n) unless -e $fn;

$t2 = 1;
open my $fh, '<', $fn;
my @c = map { $_ eq 'S' ? 1 : 0 } split //,<$fh>;
for(<$fh>) {
  chomp;
  next unless $_;
  my @d = map { 0 } my @e = map { 0 } my @l = split //,$_;
  for( 0 .. $#c ) {
    next unless $c[$_];
    if( $l[$_] eq '^' ) {
      $t1++;        $d[$_-1]  = 1;      $d[$_+1]  = 1;
      $t2+= $c[$_]; $e[$_-1] += $c[$_]; $e[$_+1] += $c[$_];
    } else {
      $d[$_] = 1;
      $e[$_] += $c[$_];
    }
  }
  @c=@e;
}
close $fh;

printf "%16s %16s %15.6f\n", $t1, $t2, 1000*(time-$t0);

