*program used to generate ANOVA table output;
data a1; 
   infile 'H:\Stat512\Datasets\Ch01ta01.dat';
   input size hours;
proc reg data=a1; 
   model hours=size; 
run;
