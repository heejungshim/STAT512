options nocenter;
data powercell; 
   infile 'H:\Stat512\Datasets\Ch07ta09.dat';
   input cycles chrate temp;
proc print data=powercell; 
run;
symbol1 v=circle i=rl;
proc gplot data=powercell;
	plot cycles*chrate;
	plot cycles*temp;
run;
*Defining the squares and crossproduct terms;
data powercell; set powercell;
  chrate2=chrate*chrate;
  temp2=temp*temp;
  ct=chrate*temp;

proc reg data=powercell;
   model cycles=chrate temp chrate2 temp2 ct / ss1 ss2;
run;

*Checking the pairwise correlations among variables;
proc corr data=powercell noprob;
   var chrate temp chrate2 temp2 ct;
run;

*Define new data set with same info, different 
   explanatory variable names.  The drop tells SAS 
   which variables to throw away (opposite is keep);
data copy; set powercell; 
   schrate=chrate; stemp=temp;
   drop chrate2 temp2 ct;

*center the variables and put them in
    dataset std;
proc standard data=copy out=std mean=0;
   var schrate stemp;
* schrate and stemp now have mean 0;
proc print data=std;
run;

*Defining the squares and crossproduct terms;
data std; set std;
  schrate2=schrate*schrate;
  stemp2=stemp*stemp;
  sct=schrate*stemp;

proc reg data=std;
  model cycles= chrate temp schrate2 stemp2 sct / ss1 ss2;
  second:  test schrate2, stemp2, sct;
run;
proc corr data=std noprob;
	var chrate temp schrate2 stemp2 sct;
run;
quit;



