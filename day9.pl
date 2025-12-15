#!/usr/local/bin/perl

use strict;
use warnings;
use feature qw(say signatures);
use Data::Dumper qw(Dumper);
use Time::HiRes qw(time);

my( $t0, $t1, $t2 ) = ( time, 0, 0 );
my $fn = $0 =~ s{([^/]+\.)pl$}{ 'input/'.$1.(@ARGV ? 'test' : 'txt') }er;
die qq(Missing file "$fn"\n) unless -e $fn;

my @pts;
open my $fh, '<', $fn;
my @pairs;
while(<$fh>){
  my($x,$y)=m{(\d+),(\d+)};
  push @pairs, [$x,$y,@{$_},(1+abs($x-$_->[0]))*(1+abs($y-$_->[1]))] for @pts;
  push @pts,[$x,$y];
}
close $fh;
@pairs = sort { $b->[4] <=> $a->[4] } @pairs;
$t1 = $pairs[0][4];
#print Dumper(\@pairs);
my %s = map { $_->[0] => 1 } @pts; my @xs = sort { $a <=> $b } keys %s;
push @xs,1e99; my $p; my $f = -1; @xs = grep { $_->[2] >= 0 } map { $p=$f; $f=$_; ([$p+1,$_-1,$_-$p-1],[$_,$_,1]) } @xs; pop @xs;
   %s = map { $_->[1] => 1 } @pts; my @ys = sort { $a <=> $b } keys %s;
push @ys,1e99;           $f = -1; @ys = grep { $_->[2] >= 0 } map { $p=$f; $f=$_; ([$p+1,$_-1,$_-$p-1],[$_,$_,1]) } @ys; pop @ys;
my $i=0; my %xi; $xi{$_->[0]}=$i++ for @xs;
   $i=0; my %yi; $yi{$_->[0]}=$i++ for @ys;
##print Dumper(\%xi);
##print Dumper(\%yi);
my $s=$pts[-1];
my ($px,$py)=($xi{$s->[0]},$yi{$s->[1]});
my @grid;
push @grid, [ (' ') x scalar @xs ] for @ys;
$grid[$py][$px]='#';
for $s (@pts) {
  my($tx,$ty)=($xi{$s->[0]},$yi{$s->[1]});
  $grid[$ty][$tx]='#';
  if($px==$tx) {
    my($s,$e) = ($py < $ty) ? ($py,$ty) : ($ty,$py);
    $grid[$_][$px]='x' for $s+1..$e-1;
  } else {
    my($s,$e) = ($px < $tx) ? ($px,$tx) : ($tx,$px);
    $grid[$py][$_]='x' for $s+1..$e-1;
  }
  ($px,$py)=($tx,$ty);
}
my @q = [0,0];
while( my $q = shift @q) {
  next unless $grid[$q->[0]][$q->[1]] eq ' ';
  $grid[$q->[0]][$q->[1]] = '.';
  push @q,
    grep { $_->[0]>=0 && $_->[1]>=0 && $_->[0]<@ys && $_->[1] < @xs }
           [ $q->[0]+1, $q->[1] ],
           [ $q->[0]-1, $q->[1] ],
           [ $q->[0], $q->[1]-1 ],
           [ $q->[0], $q->[1]+1 ];
}
@grid = map { join '', @{$_} } @grid;
#print Dumper(\%xi); print Dumper(\%yi);
O: foreach my $pair ( @pairs ) {
  my $sx = $pair->[0] < $pair->[2] ? $xi{$pair->[0]} : $xi{$pair->[2]}; my $lx = abs($xi{$pair->[2]}-$xi{$pair->[0]});
  my ($sy,$ey) = $pair->[1] < $pair->[3] ? ( $yi{$pair->[1]}, $yi{$pair->[3]} )
                                         : ( $yi{$pair->[3]}, $yi{$pair->[1]} );

  #my $str = join '', map { substr $_, $sx, $lx } @grid[$sy..$ey]; next if index( $str , '.' ) > -1;
  ( -1 < index substr( $_, $sx, $lx ), '.' ) && next O for @grid[ $sy..$ey ];
  $t2 = $pair->[4];
  last;
}
printf "%16s %16s %15.6f\n", $t1, $t2, 1000*(time-$t0);
#foreach
__END__

print join "\n", @xs,'','', @ys,'','';
print "\n------------------\n";
my $x = shift @xs; my %d = (); push(@{$d{$_-$x}},[$x,$_]),($x=$_) for @xs;
print join " = ", sort { $a <=> $b } keys %d;
print "\n------------------\n";
   $x = shift @ys; my %d = (); push(@{$d{$_-$x}},[$x,$_]),($x=$_) for @ys;
print join " = ", sort { $a <=> $b } keys %d;
print "\n------------------\n";
#print Dumper(\@pts);
print Dumper($d{1});


