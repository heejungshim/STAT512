
*This program shows the commands necessary to form a set of 
	95% confidence intervals (mean) and prediction
	intervals (indiv obs) and plot them on a scatterplot;
data a1; 
   infile 'H:\Stat512\Datasets\Ch01ta01.dat';
   input size hours;

*confidence intervals;
symbol1 v=circle i=rlclm95;
proc gplot data=a1; 
   plot hours*size; 
run;

*prediction intervals;
symbol1 v=circle i=rlcli95;
proc gplot data=a1; 
   plot hours*size; 
run;
