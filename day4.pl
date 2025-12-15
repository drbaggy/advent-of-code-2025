#!/usr/local/bin/perl

use strict;
use warnings;
use feature qw(say signatures);
use Data::Dumper qw(Dumper);
use Time::HiRes qw(time);

my( $t0, $t1, $t2 ) = ( time, 0, 0 );
my $fn = $0 =~ s{([^/]+\.)pl$}{ 'input/'.$1.(@ARGV ? 'test' : 'txt') }er;
die qq(Missing file "$fn"\n) unless -e $fn;
my $x = $t0;
open my $fh, '<', $fn;
my @grid = <$fh>;
close $fh;

chomp @grid,

my($f,$w) = (1,length $grid[0]);
my @g = split //, join '', '++', '+' x $w, map( {"+$_+"} @grid ), '++','+' x $w;
my @o = (-$w-3,-$w-2,-$w-1,-1,1,$w+1,$w+2,$w+3);

foreach my $p ($w+3 .. -$w - 2 + @g) {
  next unless '@' eq $g[$p];

  my $c = 0; ($g[$_+$p] eq '@' || $g[$_+$p] eq 'x' )&&($c++) for @o;
  $g[$p]= 'x',$t1++ if $c<4;
}
($g[$_] eq 'x') && ($g[$_]='.') for 0..$#g;
$t2 = $t1;
while($f) {
  $x = time;
  $f=0;
  foreach my $p ($w+3 .. -$w - 2 + @g) {
    next unless '@' eq $g[$p];
    my $c = 0; ($g[$_+$p] eq '@')&&($c++) for @o;
    $g[$p]= '.',$t2++,$f=1 if $c<4;
  }
}



printf "%16s %16s %15.6f\n", $t1, $t2, 1000*(time-$t0);

