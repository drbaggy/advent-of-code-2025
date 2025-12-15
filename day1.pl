#!/usr/local/bin/perl

use strict;
use warnings;
use feature qw(say);
use Data::Dumper qw(Dumper);
use Time::HiRes qw(time);

my( $t0, $t1, $t2 ) = ( time, 0, 0 );
my $fn = $0 =~ s{([^/]+\.)pl$}{ 'input/'.$1.(@ARGV ? 'test' : 'txt') }er;
die qq(Missing file "$fn"\n) unless -e $fn;

my $pos = 50;
open my $fh, '<', $fn;
while(<$fh>) {
  chomp;
  my( $loops, $d, $steps ) = (0,m(^([LR])(\d+)$));
  if( $steps =~ m{^(\d+)(\d\d)} ) {
    $loops = $1+0;
    $steps = $2+0;
  }
#say "($d-$steps) $pos - $t1 - $t2 ------------> ",
  $t2    += $loops;
  if( $steps ) {
    my $old_pos = $pos;
    $pos = $pos + ($d eq 'L' ? -$steps : $steps);
    $t2 ++ if $old_pos && ($pos <= 0 || $pos >= 100 );
    $pos %= 100;
    $t1 ++ unless $pos;
  }
}
#$t2++ if $pos == 0;
close $fh;
printf "%16s %16s %15.6f\n", $t1, $t2, 1000*(time-$t0);

__END__
my $fn = $0 =~ s{([^/]+\.)pl$}{ 'input/'.$1.(@ARGV ? 'test' : 'txt') }er;
die qq(Missing file "$fn"\n) unless -e $fn;

open my $fh, '<', $fn;
while(<$fh>) {
  chomp;
}
close $fh;

