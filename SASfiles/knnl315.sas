options nocenter;
data insurance;
   infile 'H:\Stat512\Datasets\Ch11ta01.dat';
   input months size stock;
proc print data=insurance;
run;

*The c= option specifies color, the l= option specifies
  line type.  You do not need to set the color to black
  if you use the goptions colors=(none) command;

symbol1 v=M i=sm70 c=black l=1;
symbol2 v=S i=sm70 c=black l=3;
title1 'Insurance Innovation';
proc sort data=insurance; 
	by stock size;
title2 'with smoothed lines';
proc gplot data=insurance;
   plot months*size=stock;
run;
data insurance; set insurance;
   sizestock=size*stock;

proc reg data=insurance;
   model months = stock size sizestock;
   sameline: test stock, sizestock;
run;

proc reg data=insurance;
   model months = size stock;
   model months = stock size;
run;
title2 'with straight lines';
symbol1 v=M i=rl c=black;
symbol2 v=S i=rl c=black;
proc gplot data=insurance;
   plot months*size=stock;
run;
quit;
