libname IPEDS '~/IPEDS';

/**I typically want variable information from any original data set I will
	use**/
ods trace on;
ods noproctitle;

%let rc=%sysfunc(dlgcdir('~'));
/**setting the working directory to my home directory**/

ods excel file='Specs/Graduation Data Specs.xlsx';
proc contents data=ipeds.graduation varnum;
	ods select position;
run;

proc freq data=ipeds.graduation;
	table group;
run;
ods excel close;
