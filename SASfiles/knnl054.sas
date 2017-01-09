
*Here we read in a data set from an external file using the 
	infile statement.  The path to where you have this file
	will be different but this gives you the basic idea;
data a1; 
   infile 'H:\Stat512\Datasets\Ch01ta01.dat';
   input size hours;

*create a data set with two values for size;
data a2; size=65;  output;
         size=100; output;

*merge files a1 and a2.  hours will be missing for the two
	observations in data set a2;
data a3; set a1 a2; 

proc print data=a3; run;

*the clm option generates confidence intervals for the mean at
	a specified value of x;
proc reg data=a3; 
   model hours=size/clm; 
   id size;
run; 
