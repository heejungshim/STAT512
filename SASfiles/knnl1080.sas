*KNNL1080.sas, two-way random effects anova using data for problem 24.15;
options nocenter;

data efficiency; 
   infile 'h:\stat512\datasets\CH24PR15.DAT';
   input mpg driver car;
proc print data=efficiency; 
run;
data efficiency; 
   set efficiency;
   dc = driver*10 + car;
title1 'Plot of the data';
symbol1 v=circle i=none c=black;
proc gplot data=efficiency; 
   plot mpg*dc;
*/ haxis = 11 12 13 14 15 21 22 23 24 25 31 32 33 34 35 41 42 43 44 45;
run;

proc means data=efficiency; 
   output out=effout mean=avmpg;
   var mpg;
   by driver car;
title1 'Plot of the means';
symbol1 v='A' i=join c=black;
symbol2 v='B' i=join c=black;
symbol3 v='C' i=join c=black;
symbol4 v='D' i=join c=black;
symbol5 v='E' i=join c=black;
proc gplot data=effout; 
   plot avmpg*driver=car;
run;

proc glm data=efficiency; 
   class driver car;
   model mpg=driver car driver*car;
   random driver car driver*car/test;
run;

proc varcomp data=efficiency; 
   class driver car;
   model mpg=driver car driver*car;
run;

proc mixed data=efficiency cl; 
   class car driver;
   model mpg=;
   random car driver car*driver/vcorr;
run;

