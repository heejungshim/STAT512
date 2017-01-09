*KNNL101, diagnostics for simple linear regression;

options nocenter;
*This goption turns off the color in plots;
goptions colors=(none);

*reads in external file.  A new variable seq is created which
	represents the observation or sequence number; 
data toluca;
	infile 'H:\Stat512\Datasets\CH01TA01.dat';
	input lotsize workhrs;
	seq=_n_;

proc print data=toluca; 
run;

*generates summary statistics and a qqplot for both x and y.;
proc univariate data=toluca plot; 
	var lotsize workhrs;
run;

*generates a plot of Y based on sequence order;
title1 'Sequence plot for X with smooth curve';
symbol1 v=circle i=sm70;
proc gplot data=toluca; 
	plot lotsize*seq; 
run;
* 	The normal option in qqplot assesses fit to the normal 
 	distribution.  The other options draw the line the 
	observations should follow;
title1 'QQPlot (normal probability plot)';
proc univariate data=toluca noprint; 
	qqplot lotsize workhrs / normal (L=1 mu=est sigma=est); 
run;
quit;
