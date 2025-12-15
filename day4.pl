#!/usr/local/bin/perl

use strict;
use warnings;
use feature qw(say signatures);
use Data::Dumper qw(Dumper);
use Time::HiRes qw(time);

#https://adventofcode.com/2025/day/4

my( $t0, $t1, $t2 ) = ( time, 0, 0 );
my $fn = $0 =~ s{([^/]+\.)pl$}{ 'input/'.$1.(@ARGV ? 'test' : 'txt') }er;
die qq(Missing file "$fn"\n) unless -e $fn;

## load in the grid
open my $fh, '<', $fn;
my @grid = <$fh>;
close $fh;

chomp @grid;

## We need to sweep grid to find space which have less than 4 neighbours. We
## make the grid 2d - by adding a boundary of "+" and wrapping into a long
## single array...

## Pass 1 we count the deletions that we sould make as well as removing the barrels
## We can't remove them until the full scan so we mark them as deleted - and then
## remove at the end...
my($f,$w) = (1,length $grid[0]);
my @g = split //, join '', '++', '+' x $w, map( {"+$_+"} @grid ), '++','+' x $w;
my @o = (-$w-3,-$w-2,-$w-1,-1,1,$w+1,$w+2,$w+3);

foreach my $p ($w+3 .. -$w - 2 + @g) {
  next unless '@' eq $g[$p];

  my $c = 0; ($g[$_+$p] eq '@' || $g[$_+$p] eq 'x' )&&($c++) for @o;
  $g[$p]= 'x',$t1++ if $c<4;
}
## Remove marked barrels...
($g[$_] eq 'x') && ($g[$_]='.') for 0..$#g;
$t2 = $t1;
## Now we continue looping through the nodes and deleting the points {as we are
## no longer worried which pass we are in we can remove them immediately}
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

