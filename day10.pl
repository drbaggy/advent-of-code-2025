#!/usr/local/bin/perl

use strict;
use warnings;
use feature qw(say signatures);
use Data::Dumper qw(Dumper);
use Time::HiRes qw(time);

my( $t0, $t1, $t2 ) = ( time, 0, 0 );

my @BUTTONS;
my $fn = $0 =~ s{([^/]+\.)pl$}{ 'input/'.$1.(@ARGV ? 'test' : 'txt') }er;
die qq(Missing file "$fn"\n) unless -e $fn;

open my $fh, '<', $fn;

my( $MAX, %cache, @buttons, @but_2 ) = 1e99;

for(<$fh>) {
  chomp;
  next unless $_;
  %cache = ();
  my($t,$buttons,$weights) = m{\[([.#]+)\]\s\((.*?)\)\s\{(.*?)\}};
  my @weights = split /,/, $weights;
  my $res=0; $res*=2, ($_ eq '#') && ($res++) for reverse split //,$t;
  @buttons = map { my $o = 0; $o+=1<<$_ for @{$_}; $o }
    @but_2 = map { [split /,/] }
             split /\) \(/, $buttons;
  my @f;
  $f[$_]++ for map { split /,/ } split /\) \(/,$buttons;
  #say join ' ', '','',map { $f[$_].','.$_ } sort { $f[$a] <=> $f[$b] } 0..$#f;
  my @index = @{buttons(scalar @buttons)};
  foreach( @index ) {
    my $v = 0; $v^=$buttons[$_] for @{$_};
    next if $v != $res;
    $t1 += @{$_};
    last;
  }
  my $QQQ = best_score( \@weights, \@index );
  $t2 += $QQQ unless $QQQ == $MAX;
}
close $fh;
printf "%16s %16s %15.6f\n", $t1, $t2, 1000*(time-$t0);

sub best_score( $w, $i ) {
  my($best,$key,@q) = ($MAX,join' ',@{$w});
  return 0 unless $key =~ /[^ 0]/;
  return $cache{$key} if exists $cache{$key};
  O: foreach my $idx ( @{$i} ) {
    @q = @{$w};
    foreach my $x (@{$idx}) { $q[$_]-- || next O for @{$but_2[$x]}; }
    ( $_ & 1 ) && (next O) foreach( @q );
    my $t = @{$idx} + 2 * best_score( [ map { $_>>1 } @q ], $i );
    $best = $t if $best > $t;
  }
  $cache{$key} = $best
}
sub buttons( $t ) {
  unless( $BUTTONS[$t] ) {
    $BUTTONS[$t] = [ [],
      map  { my @x = @{$_}; [ grep { 0 + $x[$_] } 0 .. $t-1] }
      map  { [ split //, sprintf '%0'.$t.'b', $_->[0]] }
      sort { $a->[1] <=> $b->[1] }
      map  { [ $_, ( sprintf '%b', $_ ) =~ tr/1/1/ ] }
      1 .. -1 + (1<<$t)
    ];
  }
  $BUTTONS[$t]
}
