*KNNL1036.sas, one-way random effects anova using data in Table 24.1;

options nocenter;
data interview; infile 'h:\stat512\datasets\CH24TA01.DAT';
   input rating officer;
proc print data=interview; run;

title1 'Plot of the data';
symbol1 v=circle i=none c=black;
proc gplot data=interview; 
   plot rating*officer;
run;

proc means data=interview; 
   output out=a2 mean=avrate;
   var rating;
   by officer;

title1 'Plot of the means';
symbol1 v=circle i=join c=black;
proc gplot data=a2; 
   plot avrate*officer;
run;

proc glm data=interview; 
   class officer;
   model rating=officer;
   random officer;
run;

proc varcomp data=interview; 
   class officer;
   model rating=officer;
run;

proc mixed data=interview cl; 
   class officer;
   model rating=;
   random officer/vcorr;
run;

