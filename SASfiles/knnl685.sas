*knnl685.sas, one way anova using data in Table 16.1;
options nocenter;
data cereal; 
   infile 'H:\Stat512\Datasets\CH16TA01.DAT';
   input cases pkgdes store;

proc print data=cereal; 
run;

proc glm data=cereal; 
   class pkgdes; 
   model cases=pkgdes;
   means pkgdes;
run;

symbol1 v=circle i=none;
proc gplot data=cereal; 
   plot cases*pkgdes;
run;
proc means data=cereal; 
   var cases; by pkgdes;
   output out=cerealmeans mean=avcases;
proc print data=cerealmeans;

symbol1 v=circle i=join;
proc gplot data=cerealmeans; 
   plot avcases*pkgdes;
run;
quit;
