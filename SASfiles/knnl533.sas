*KNNL533.sas, nonlinear analysis of learning curve data;
data ch13tab04;
  input x1 x2 y;
  label x1 = 'Location'
        x2 = 'Week'
	y = 'Efficiency';
cards;
  1   1   .483
  1   2   .539
  1   3   .618
  1   5   .707
  1   7   .762
  1  10   .815
  1  15   .881
  1  20   .919
  1  30   .964
  1  40   .959
  1  50   .968
  1  60   .971
  1  70   .960
  1  80   .967
  1  90   .975
  0   1   .517
  0   2   .598
  0   3   .635
  0   5   .750
  0   7   .811
  0  10   .848
  0  15   .943
  0  20   .971
  0  30  1.012
  0  40  1.015
  0  50  1.007
  0  60  1.022
  0  70  1.028
  0  80  1.017
  0  90  1.023
;

proc print data = ch13tab04;
run;

*Plot the data;
title1 'Plot of the data';
symbol1 v = '1' i = none c = black;
symbol2 v = '2' i = none c = black;
proc gplot data = ch13tab04;
	plot y*x2 = x1;
run;

*Fit the model;
proc nlin data = ch13tab04 method = newton;
  parms g0=1.025 g1=-0.0459 g2=-0.5 g3=-0.122 ;
  model y = g0 + g1*x1 + g2*exp(g3*x2);
  output out = nlinout p = pred;
run;

*Plot the data with the fitted models;
data nlinout;
	set nlinout;
	if x1 = 0 then do;
		y1 = y;
		z21 = x2;
		p1 = pred;
	end;
	if x1 = 1 then do;
		y2 = y;
		z22 = x2;
		p2 = pred;
	end;
run;
symbol1 v = '1' i = none c = black;
symbol2 v = '2' i = none c = black;
symbol3 v = none i = join c = black;
symbol4 v = none i = join c = black;
proc gplot data = nlinout;
	plot y1*z21 y2*z22 p1*z21 p2*z22/overlay;
run;




