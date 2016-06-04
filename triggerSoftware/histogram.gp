set terminal png enhanced 20; 
set size 1.0,1.0;
set output 'histogram.png';
set grid xtics ytics;
set xlabel 'Toggle Rate';
set ylabel "Proportion of Wires";
unset key;
set yrange [0.0:0.03]
set xrange [0:0.25]

set arrow from .17,0 to .17,.03 nohead lt 0 lw 5 lc rgb "red"
#set arrow from .12,0 to .12,.03 nohead lt 0 lw 5 lc rgb "red"

plot 'histogram.txt' using 3:4 with boxes lc rgb "grey" linetype 1 linewidth 4 title 'Base' ,\
'div.txt' using 3:4 with boxes lc rgb "red" linetype 1 linewidth 4 title 'Base' ;
