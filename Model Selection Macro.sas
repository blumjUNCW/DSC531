%macro ModelSelect(library=work,dataset= ,class= ,response= ,quant= ,method=stepwise,select=aic,stop=aic,choose=aic,outputData=);
proc glmselect data=&library..&dataset;
	class &class;
	model &response = &class &quant /selection=&method(select=&select stop=&stop choose=&choose);
	ods output modelInfo=modelInfo
						NObs=Obs
						SelectionSummary=Selection
						ParameterEstimates=Estimates;				
run;

proc transpose data=modelInfo(where=(label1 in ('Selection Method','Select Criterion','Stop Criterion','Choose Criterion'))) 
		out=model(drop=_name_);
	var cValue1;
	id label1;
run;

proc sql;
	create table &outputData as
	select model.*, "&class" as class, "&quant" as quant, NObsRead, NObsUsed, Step, case when Parameter ne '' then Parameter else EffectEntered end as Parameter, CriterionValue,
		estimate, stdErr, StandardizedEst
	from model, obs(where=(label contains 'Read')),
		selection(rename=(SBC=CriterionValue)) left join estimates on EffectEntered eq scan(parameter,1,' ')
	order by 'Selection Method'n,'Stop Criterion'n,'Choose Criterion'n, Step, Parameter
	;
quit;
%mend;

options mprint;
ods exclude all;
%ModelSelect(dataset=regmodel,class=iclevel--c21enprf board,response=rate,quant=cohort grantrate--inStateF roomAmt--ScaledHousingCap,outputData=out1);
%ModelSelect(dataset=regmodel,class=iclevel--c21enprf board,response=rate,quant=cohort grantrate--inStateF roomAmt--ScaledHousingCap,choose=SBC,outputData=out2);
%ModelSelect(dataset=regmodel,response=rate,quant=cohort grantrate--inStateF roomAmt--ScaledHousingCap,choose=SBC,outputData=out3);

data modelresults;
	set out1 out2 out3;
run;