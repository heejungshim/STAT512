options nocenter;
data bodyfat; 
   infile 'H:\Stat512\Datasets\Ch07ta01.dat';
   input skinfold thigh midarm fat;
proc print data=bodyfat; 
run;

*Fit model and it appears set of variables are helpful but 
  each individual parameter is not helpful;
proc reg data=bodyfat; 
   model fat=skinfold thigh midarm;
run;

*How to look at both Type I and Type II SS;
proc reg data=bodyfat; 
   model fat=skinfold thigh midarm /ss1 ss2;
run;

*Fit just one variable and it is helpful.  Why does this 
  happen?;
proc reg data=bodyfat; 
   model fat = skinfold;
   model fat = thigh;
   model fat = midarm;
run;

*Test if the other two variables are helpful after skinfold 
  is fit;
proc reg data=bodyfat; 
   model fat=skinfold thigh midarm;
   skinonly: test thigh, midarm;
   thighonly:  test skinfold, midarm;
   skinmid:  test thigh;
run;

*How to compute the partial correlation (SAS gives squared 
  correlation);
proc reg data=bodyfat; 
   model fat=skinfold thigh midarm / pcorr1 pcorr2;
run;

*Using standardized variables;
proc reg data=bodyfat; 
   model fat=skinfold thigh midarm / stb;
run;

*Getting correlation coefficients between each variable
   in the model.  Also looking at correlation among several
   variables;
proc reg data=bodyfat corr; 
   model fat=skinfold thigh midarm;
   model midarm = skinfold thigh;
   model skinfold = thigh midarm;
   model thigh = skinfold midarm;
run;
proc reg data=bodyfat;
	model fat = thigh skinfold midarm /selection=cp b best=10;
run;
proc reg data=bodyfat;
	model fat = thigh skinfold;
	model fat = skinfold midarm;
	model fat= thigh midarm;
run;
proc corr data=bodyfat noprob;
run;
quit;