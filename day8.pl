#!/usr/local/bin/perl

use strict;
use warnings;
use feature qw(say signatures);
use Data::Dumper qw(Dumper);
use Time::HiRes qw(time);

my( $t0, $t1, $t2 ) = ( time, 0, 0 );
my $fn = $0 =~ s{([^/]+\.)pl$}{ 'input/'.$1.(@ARGV ? 'test' : 'txt') }er;
die qq(Missing file "$fn"\n) unless -e $fn;

my $N = $fn =~ /test/ ? 10 : 1000;

open my $fh, '<', $fn;
my @d;
my @pts;
my $c = 0;
my @x;
for(<$fh>) {
  chomp;
  my $p = [split /,/];
  push @x,$p->[0];
  my $k = 0;
  push @d, map { [ $c, $k++,
    ($p->[0]-$_->[0])*($p->[0]-$_->[0]) +
    ($p->[1]-$_->[1])*($p->[1]-$_->[1]) +
    ($p->[2]-$_->[2])*($p->[2]-$_->[2]) ] } @pts;
  push @pts,$p;
  $c++;
}
close $fh;
#say time - $t0;
@d = sort { $a->[2] <=> $b->[2] } @d;
my $KK = @d;
#say time - $t0;
#warn sprintf "%3d %3d %10d\n", @{$_} foreach @d;
my $t = shift @d;
my @c = (0) x @pts; my $k = 1;
$c[$t->[0]] = $c[$t->[1]] = 1;
my $loop = 1;
my $clusters = 1;
my $joined = 2;
my $flag = 0;
while( my $t = shift @d ) {
  last if $flag == 3;
  $loop++;
  my( $x, $y ) = @{ $t };
  if($c[$x]) {
    if( $c[$y] ) {
      my $t=$c[$x];
      if( $t != $c[$y] ) {
        ($c[$_] == $t) && ( $c[$_] = $c[$y] ) for 0..$#c;
        $clusters--;
      }
    } else {
      $c[$y] = $c[$x];
      $joined++;
    }
  } else {
    $joined++;
    unless( $c[$y] ) {
      $c[$y] = ++$k;
      $joined   ++;
      $clusters ++;
    }
    $c[$x] = $c[$y];
  }
  if( ( $clusters == 1) && ($joined == scalar @x) && $flag < 2 ) {
    $t2 = $x[$x] * $x[$y];
    $flag |= 2;
  }
  if($loop == $N) {
    $flag |= 1; #print Dumper(\@c);
    my %tmp; $tmp{$_}++ foreach grep { $_ } @c; my @q = reverse sort { $a <=> $b } values %tmp; $t1 = $q[0]*$q[1]*$q[2];
  }
}

#say join ' - ', scalar @d, $KK, $KK - scalar @d;
printf "%16s %16s %15.6f\n", $t1, $t2, 1000*(time-$t0);

