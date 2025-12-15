#!/usr/local/bin/perl

use strict;
use warnings;
use feature qw(say signatures);
use Data::Dumper qw(Dumper);
use Time::HiRes qw(time);

my( $t0, $t1, $t2 ) = ( time, 0, 0 );
my $fn = $0 =~ s{([^/]+\.)pl$}{ 'input/'.$1.(@ARGV ? 'test' : 'txt') }er;
die qq(Missing file "$fn"\n) unless -e $fn;

my(%t,%r);
open my $fh, '<', $fn;
while(<$fh>) {
  my($x,@q) = m{(\w+)}g;
  $t{$x} = [@q];
  push @{$r{$_}},$x for @q
}

sub count( $s, $e ) {
  my %d = map { $_ => 0 } keys %t;
  my @z = $d{$s} = my $n = my $x = 1;
  (@z = map { ($d{$_} == $n) && exists $t{$_} ? @{$t{$_}} : () } keys %d),
    (@d{@z}= (++$n) x scalar @z) while @z;
  my %c = map { $_ => 0 } my @n = sort { $d{$a} <=> $d{$b} } grep { $d{$_} } keys %d;
  foreach my $k (@n) {
    $c{$k} = 1, next if $k eq $s;
    $c{$k} = 0; $c{$k}+=$c{$_}//0 for @{$r{$k}}
  }
  $c{$e}//0
}

$t1 = count('you','out');
$t2 = count('svr','fft') * count('fft','dac') * count('dac','out');
printf "%16s %16s %15.6f\n", $t1, $t2, 1000*(time-$t0);
