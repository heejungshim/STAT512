*KNNL882.sas, two-way anova with one observation per cell
   using data in Table 21.2;

options nocenter;
data carins; 
	infile 'H:\Stat512\Datasets\CH21TA02.DAT';
  	input premium size region;
	if size=1 then sizea='1_small ';
	if size=2 then sizea='2_medium';
	if size=3 then sizea='3_large ';
proc print data=carins; 
run;

proc glm data=carins;
   class sizea region;
   model premium=sizea region/solution;
   means sizea region / tukey;
   output out=preds p=muhat;
run;
proc print data=preds; 
run;

symbol1 v='E' i=join c=black;
symbol2 v='W' i=join c=black;
title1 'Plot of the data';
proc gplot data=preds; 
   plot premium*sizea=region;
run;

symbol1 v='E' i=join c=black;
symbol2 v='W' i=join c=black;
title1 'Plot of the model estimates';
proc gplot data=preds; 
   plot muhat*sizea=region;
run;
quit;
