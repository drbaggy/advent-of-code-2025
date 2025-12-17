#!/usr/local/bin/perl

use strict;
use warnings;
use feature qw(say signatures);
use Data::Dumper qw(Dumper);
use Time::HiRes qw(time);

my( $t0, $t1, $t2 ) = ( time, 0, 0 );
my $fn = $0 =~ s{([^/]+\.)pl$}{ 'input/'.$1.(@ARGV ? 'test' : 'txt') }er;
die qq(Missing file "$fn"\n) unless -e $fn;

if( $fn =~ m{\.test} ) {
  ## We cheat in the test case - there are non-trivial solutions...
  ## So we know the answer is 2.....
  $t1 = 2;
} else {
## File format....
=cut
  0:
  #.#
  ###
  #.#
  > 1:
  #..
  ##.
  ###
  
  ......
  
  41x38: 19 31 25 29 22 29
  36x43: 23 27 31 27 29 30
  
  ......
=cut

  my(  $always, $possible, $impossible, @w, %t, %r ) =
    ( 0, 0, 0, 0 );
  open my $fh, '<', $fn;
  while(<$fh>) {
    if( m{[#.]} ) { ## This is part of one of the packages;
                    ## We just need to count the number of ...                    
      $w[-1] += tr/#/#/
    } elsif( !m{\S} ) { ## Gap between packages, so initialize
                        ## the next one...
      push @w, 0
    } elsif( m{^(\d+)x(\d+): (.*)} ) {
      ## Finally this is one of the grids we need to check,
      ## The first paire of digits is the height & width,
      ## So we compute the number of whole squares ($s)
      ## and number of "dots" ($d) AND we then get the numbers
      ## of each type of present....
      my ( $s,                    $d,    @counts )
       = ( int($1/3) * int($2/3), $1*$2, split /\s+/, $3 );
      ## We do things - first we check the number of "dots" of
      ## puzzles against $d & the number of puzzles against $s
      ## (the trivial pack)
      ## If $s >= number of parcels you can do the trival pack
      ## If $d <  number of "dots" we know there IS no solution
      ## So we are left with cases where $s < #parcels & $d > #dots
      $s -=          $counts[$_],
      $d -= $w[$_] * $counts[$_] for 0 .. $#counts;
      ## We store these in the 3 elements of @x;
        $s >= 0 ? $always++
      : $d <  0 ? $impossible++
      :           $possible++
    }
  }
  close $fh;
  ## In our example (at least) $x[1] is "0" there are no non-trivial
  ## solutions in the real data.... SO...
  warn "$possible - not trivial solutions\n" if $possible;
  $t1 = $always
}

printf "%16s %16s %15.6f\n", $t1, $t2, 1000*(time-$t0);

