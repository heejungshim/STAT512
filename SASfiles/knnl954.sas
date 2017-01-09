*KNNL954.sas, two-way anova with unequal numbers of observations
   using data in Table 22.1;
options nocenter;
data hormone; 
	infile 'h:\Stat512\Datasets\CH22TA01.DAT';
	input growth gender bone;
proc print data=hormone; 
run;
data hormone; set hormone;
   if (gender eq 1)*(bone eq 1) then gb='1_Msev ';
   if (gender eq 1)*(bone eq 2) then gb='2_Mmod ';
   if (gender eq 1)*(bone eq 3) then gb='3_Mmild';
   if (gender eq 2)*(bone eq 1) then gb='4_Fsev ';
   if (gender eq 2)*(bone eq 2) then gb='5_Fmod ';
   if (gender eq 2)*(bone eq 3) then gb='6_Fmild';
run;
title1 'Plot of the data';
symbol1 v=circle i=none c=black;
proc gplot data=hormone; 
   plot growth*gb;
run;
proc means data=hormone; 
   output out=means mean=avgrowth;
   by gender bone;
title1 'Plot of the means';
symbol1 v='M' i=join c=black;
symbol2 v='F' i=join c=black;
proc gplot data=means; 
   plot avgrowth*bone=gender;
run;
proc glm data=hormone; 
   class gender bone;
   model growth=gender|bone/solution;
   means gender*bone;
   contrast 'gender Type III' 
     gender 3 -3 
     gender*bone 1 1 1 -1 -1 -1;
   estimate 'gender Type III' 
     gender 3 -3 
     gender*bone 1 1 1 -1 -1 -1;
   contrast 'gender Type I' 
     gender 7 -7 
     bone 2 -1 -1
     gender*bone 3 2 2 -1 -3 -3;
   estimate 'gender Type I' 
     gender 7 -7 
     bone 2 -1 -1
     gender*bone 3 2 2 -1 -3 -3;
   contrast 'bone Type III' 
     bone 2 -2 0
     gender*bone 1 -1 0 1 -1 0,
     bone 0 2 -2
     gender*bone 0 1 -1 0 1 -1;
*note bone Type I contrast SS does not match Type I SS exactly because it's second in the model;
   contrast 'bone Type I'
 	 gender 7 -7
	 bone 20 -20 0
	 gender*bone 15 -8 0 5 -12 0,
   	 bone 0 5 -5
	 gender*bone 0 2 -2 0 3 -3;
   contrast 'gender*bone Type I and III' 
     gender*bone 1 -1 0 -1 1 0,
     gender*bone 0 1 -1 0 -1 1;
proc glm data=hormone; 
   class bone gender;
   model growth=bone|gender;
   contrast 'bone Type I'
 	 bone 20 -20 0
	 gender 7 -7
	 bone*gender 15 -8 0 5 -12 0,
   	 bone 0 5 -5
	 bone*gender 0 2 -2 0 3 -3;
run;
proc glm data=hormone; 
   class gender bone;
   model growth=gender bone/solution;
   means gender bone/ tukey lines;
run;
quit;
