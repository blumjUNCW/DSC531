libname IPEDS '~/IPEDS';
options fmtsearch=(IPEDS);

ods trace on;
ods noproctitle;

%let rc=%sysfunc(dlgcdir('~'));

ods excel file='Specs/IPEDS Data Info.xlsx'
	options(sheet_interval='none' sheet_name='AgeDist');
proc contents data=ipeds.agedist varnum;
	ods select position;
run;
proc freq data=ipeds.agedist;
	table efbage;
run;

ods excel options(sheet_interval='proc' sheet_name='Aid');
proc contents data=ipeds.aid varnum;
	ods select position;
run;

ods excel options(sheet_interval='proc' sheet_name='Characteristics');
proc contents data=ipeds.characteristics varnum;
	ods select position;
run;
ods excel options(sheet_interval='none');
proc freq data=ipeds.characteristics;
	table iclevel--cbsatype;
run;

ods excel options(sheet_interval='proc' sheet_name='Graduation');
proc contents data=ipeds.graduation varnum;
	ods select position;
run;
ods excel options(sheet_interval='none');
proc freq data=ipeds.graduation;
	table group;
run;

ods excel options(sheet_interval='proc' sheet_name='Salaries');
proc contents data=ipeds.salaries varnum;
	ods select position;
run;
ods excel options(sheet_interval='none');
proc freq data=ipeds.salaries;
	table rank;
run;

ods excel options(sheet_interval='proc' sheet_name='TuitionAndCosts');
proc contents data=ipeds.tuitionandcosts varnum;
	ods select position;
run;
ods excel options(sheet_interval='none');
proc freq data=ipeds.tuitionandcosts;
	table room board;
run;

ods excel options(sheet_interval='proc' sheet_name='IPEDSFormats');
proc print data=ipeds.ipedsformats;
	var fmtname--label;
run;
ods excel close;
