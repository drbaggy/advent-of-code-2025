echo ''
echo '                  Part 1           Part 2            Time          Part 1           Part 2            Time'
echo ''
start=`date +%s%6N`
RUNNING=0
T_RUN=0
R_RUN=0
for i in {1..12}
do
  if [ -f "day$i.pl" ]
  then
    O=`perl day$i.pl x`;# input/day$i.txt`
    T=`echo $O | grep -Eo '[.0-9]+$'`
    RUNNING=`perl -e "print $RUNNING + $T"`
    T_RUN=`perl -e "print $T_RUN + $T"`
    perl -e "printf ' Day %2d ', $i"
    perl -e "print qq($O)";
    O=`perl day$i.pl`;# input/day$i.txt`
    Z=`echo $O | grep -Eo '[.0-9]+$'`
    R_RUN=`perl -e "print $R_RUN + $Z"`
    RUNNING=`perl -e "print $RUNNING + $Z"`
    echo "$O"
  fi
done
end=`date +%s%6N`

perl -e 'printf "\n Running Total                            %15.6f                                  %15.6f %15.6f", @ARGV' $T_RUN, $R_RUN, $RUNNING
perl -e 'printf "\n Wall clock total                                                                                          %15.6f\n\n", ($ARGV[1]-$ARGV[0])/1e3' $start $end
