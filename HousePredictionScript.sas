*Part 1 - Carlos Vargas;

libname BAS220 "/home/u63010744/myfolders";

*Following instructions to create a categorical variable.;

/*Creating a categorical variable called kitchen_category*/

data bas220.houseOut;

set bas220.house;

if upcase(strip(KitchenQual))="PO" then kitchen_category=1;

else if upcase(strip(KitchenQual))="FA" then kitchen_category=2;

else if upcase(strip(KitchenQual))="TA" then kitchen_category=3;

else if upcase(strip(KitchenQual))="GD" then kitchen_category=4;

else if upcase(strip(KitchenQual))="EX" then kitchen_category=5;

else kitchen_category=.;

if kitchen_category=. then

do;

excellent_vs_poor=.;

good_vs_poor=.;

typical_average_vs_poor=.;

fair_vs_poor=.;

end;

else

do;

if kitchen_category=2 then

fair_vs_poor=1;

else

fair_vs_poor=0;

if kitchen_category=3 then

typical_average_vs_poor=1;

else

typical_average_vs_poor=0;

if kitchen_category=4 then

good_vs_poor=1;

else

good_vs_poor=0;

if kitchen_category=5 then

excellent_vs_poor=1;

else

excellent_vs_poor=0;

end;

run;

*Part 2 – Bradley Jordan;

title "Exploratory Scattor Plots 1";

proc sgscatter data=bas220.houseOut;

matrix saleprice OverallQual OverallCond YearBuilt YearRemodAdd

Fullbath;

run;

title "Exploratory Scattor Plots 2";

proc sgscatter data=bas220.houseOut;

matrix saleprice LotArea GrLivArea garagearea good_vs_poor excellent_vs_poor;

run;

*this plot is included because of the positive corelation between the sale price and garage area;

title "Sales Price vs Garage Area";

proc sgscatter data=bas220.houseOut;

plot saleprice*garagearea;

run;

*this plot is included because of the positive corelation between sale price and overall quallity;

title "Sales Price vs Overall Quality of the House Finish/Materials";

proc sgscatter data=bas220.houseOut;

plot saleprice*OverallQual;

run;

*these are the correlations for the plots I have chosen, overallqual and saleprice would be one correlation to include in the final report due to its high correlation;

proc corr data=bas220.houseOut;

title "scatter plot correlations";

var saleprice garagearea OverallQual;

run;

*Part 3 – Elizabeth Etchells and Clayton Dombrowski

/* reset title */

title;

proc reg data=BAS220.houseOut;

model SalePrice=

/* TotRmsAbvGrd - Did not pass T Test */

GrLivArea

OverallQual

GarageArea

/* FullBath - Did not pass T Test */

/* fair_vs_poor - Did not pass T Test*/

/* typical_average_vs_poor - Did not pass VIF*/

good_vs_poor

excellent_vs_poor

/VIF;

run;

data BAS220.houseOut2;

set BAS220.houseOut;

yhat=-64237

+ 48.04341*GrLivArea

+ 21532*OverallQual

+ 63.85506*GarageArea

+ 15307*good_vs_poor

+ 68272*excellent_vs_poor;

resid = SalePrice - yhat;

absolute = abs(resid);

square = (resid)**2;

percent=(absolute/SalePrice)*100;

label resid="Error" absolute="MAD=|Error|" square="MSE=ERROR^2" percent="MAPE=%|Error|";

run;

proc means data=BAS220.houseOut2;

var absolute square p
