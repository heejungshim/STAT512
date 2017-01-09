options nocenter;
data a1; 
   infile 'H:\Stat512\Datasets\Ch06fi05.dat';
   input young income sales;
*Remember to always check your data is read in correctly;
proc print data=a1; 
run;

*Confidence intervals for the parameters;
proc reg data=a1; 
   model sales=young income/clb;
run;

*Confidence intervals for the mean of Y;
proc reg data=a1; 
   model sales=young income/clm;
   id young income;
run;

*Prediction intervals for future Y;
proc reg data=a1; 
   model sales=young income/cli;
   id young income;
run;
