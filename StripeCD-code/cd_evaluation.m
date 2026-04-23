%% change detection results evaluation
function [eva,eva_value]=cd_evaluation(cm,gt)

%cm, input change map,0 for unchanged pixel, 1 for changed pixel
%gt, ground truth, 0 for unchanged pixel, 1 for changed pixel
%eva, the output evaluation matrics, which includes:
%       -TP, true positive
%       -FP, false positive 
%       -TN, true negative 
%       -FN, false negative 
%       -OA, overall accuracy, OA=(TP+TN)/(TP+TN+FP+FN);
%       -Sen, sensitiviey, Sen=TP/(TP+FN); 
%       -Spe, specifity, Spe=TN/(TN+FP);

TP=length(find(cm==1&gt==1));
TN=length(find(cm==0&gt==0));
FP=length(find(cm==1&gt==0));
FN=length(find(cm==0&gt==1));
OA=(TP+TN)/(TP+TN+FP+FN);
% Sen=TP/(TP+FN);
% Spe=TN/(TN+FP);
Precision=TP/(TP+FP);
Recall=TP/(TP+FN);
F1=2*Precision*Recall/(Precision+Recall);
PRE1=(TP+FP)*(TP+FN)+(TN+FN)*(TN+FP);
PRE2=(TP+FP+TN+FN)*(TP+FP+TN+FN);
PRE=PRE1/PRE2;
Kappa=(OA-PRE)/(1-PRE);

eva=struct('TP', TP, 'TN', TN, 'FP', FP, 'FN', FN, 'Precision',Precision,'Recall',Recall,'OA', OA, 'F1',F1,'Kappa',Kappa);
eva_value=[TP,TN,FP,FN,Precision,Recall,OA,F1,Kappa];
end