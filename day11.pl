#!/usr/local/bin/perl

use strict;
use warnings;
use feature qw(say signatures);
use Data::Dumper qw(Dumper);
use Time::HiRes qw(time);

my( $t0, $t1, $t2 ) = ( time, 0, 0 );
my $fn = $0 =~ s{([^/]+\.)pl$}{ 'input/'.$1.(@ARGV ? 'test' : 'txt') }er;
die qq(Missing file "$fn"\n) unless -e $fn;

## The first thing to note is that because of the wording of the question we can
## assume this is in fact a DAG, as if not there would be an infinite number of
## solutions....

## We read the file and generate two structures - a map going forward (%t) and also 
## a map going backawards (%r)..

## If we have a -> b; a -> d; b -> d
##   %t will be a -> [ b, d ]; b -> [ d ];
##   %r will be b -> [ a ]; d -> [ a, b ];
my( %t, %r );

## For a start and end... we first of all compute the maximum depth of each node,
## i.e. the maximum number of hops... In the case above 
## We have a depth 1, b depth 2 & d depth 3 as we can write this as
## 
##  ,-->-->-->>--> DD
## AA -> BB --'
sub count( $s, @nodes ) {
  my $res = 1;
  ## Prepare depth list...  
  my %d = map { $_ => 0 } keys %t;
  my @z = $d{$s} = my $n = my $x = 1;
  ## Get the depths...
  (@z = map { ($d{$_} == $n) && exists $t{$_} ? @{$t{$_}} : () } keys %d),
    (@d{@z}= (++$n) x scalar @z) while @z;
  for my $e ( @nodes ) {
  ## Get the nodes in reverse depth order... and set the counts of each one to zero
    my %c = map { $_ => 0 } my @n = sort { $d{$a} <=> $d{$b} } grep { $d{$_} } keys %d;
    foreach my $k (@n) {
        ## If we are on the start node we set the count of routes to that node to "1"
        ## This is the trivial "zero-length" path...
      $c{$k} = 1, next if $k eq $s;
        ## If not we loop through all nodes which we can get to it from (the need for the
        ## reverse mapping.... and add the counts of routes for each one....
      $c{$k} = 0; $c{$k}+=$c{$_}//0 for @{$r{$k}} #
    $res *= $c{$e}//0;
    ## Next nodes...
    $s = $e
  }
  $res
}

sub _load_fn( $fname ) {
  %t=(); %r=();
  open my $fh, '<', $fname;
  while(<$fh>) {
    my($x,@q) = m{(\w+)}g; $t{$x} = [@q]; push @{$r{$_}},$x for @q
  }
  close $fh
}

   _load_fn $fn ;
$t1 = count qw(you out);                       ## Routes from you -> out 
   _load_fn $fn =~ s{test}{test-2}r if @ARGV;  ## Test uses a 2nd test file...
$t2 = count qw(svr fft dac out);               ## Routes from svr -> fft -> dac -> out...

printf "%16s %16s %15.6f\n", $t1, $t2, 1000*(time-$t0);
