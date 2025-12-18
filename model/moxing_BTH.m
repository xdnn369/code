GDP = [10770.965, 12857.65, 14315.3025, 15543.05, 16618.6125, 17328.2225, 18653.1275, 20639.9325, 19740.875, 21119.785, 21491.27];
NOx = [585.7331, 623.2894, 638.4343, 605.7401, 549.142, 499.37706, 494.3961, 480.6006, 478.0624, 465.4029, 429.3172]*336*12;
PM10 = [317.9904, 321.0648, 326.3581, 314.1876, 276.4355, 231.1147, 206.3284, 182.978, 171.0636, 157.5864, 140.0591]*336*12;
PM25 = [224.7712, 226.8864, 230.7608, 223.7198, 198.6783, 168.0337, 151.7818, 135.5784, 126.5828, 116.8682, 104.0053]*336*12;
SO2 = [528.0241, 545.705, 542.8578, 518.3412, 393.1095, 307.2036, 251.6545, 199.4211, 173.9469, 150.4162, 130.6884]*336*12;
VOC = [471.4384, 483.9073, 496.1671, 501.6432, 504.1259, 523.2058, 524.4208, 499.5984, 491.471, 472.8905, 439.2494]*336*12;

N = 112000000;

PGDP = GDP/1.12;  %人均GDP（元/人）
PNOx = NOx*1000/N;  %人均NOx（千克/人）
PPM10 = PM10*1000/N;
PPM25 = PM25*1000/N;
PSO2 = SO2*1000/N;
PVOC = VOC*1000/N;

% 取对数  
LPGDP = log(PGDP);  
LPNOx1 = log(PNOx);  
LPPM101 = log(PPM10);  
LPPM251 = log(PPM25);  
LPSO21 = log(PSO2);  
LPVOC1 = log(PVOC); 

%LPGDP = log(PGDP);  
LPNOx2 = (log(PNOx)).^2;  
LPPM102 = (log(PPM10)).^2;  
LPPM252 = (log(PPM25)).^2;  
LPSO22 = (log(PSO2)).^2;  
LPVOC2 = (log(PVOC)).^2; 

%LPGDP = log(PGDP);  
LPNOx3 = (log(PNOx)).^3;  
LPPM103 = (log(PPM10)).^3;  
LPPM253 = (log(PPM25)).^3;  
LPSO23 = (log(PSO2)).^3;  
LPVOC3 = (log(PVOC)).^3; 

% 创建表格数据  
%tbl = table(LPGDP', LPNOx1', LPPM101', LPPM251', LPSO21', LPVOC1', 'VariableNames', {'LPGDP', 'LPNOx1', 'LPPM101', 'LPPM251', 'LPSO21', 'LPVOC1'});
%tbl = table(LPGDP', LPNOx2', LPPM102', LPPM252', LPSO22', LPVOC2', 'VariableNames', {'LPGDP', 'LPNOx2', 'LPPM102', 'LPPM252', 'LPSO22', 'LPVOC2'});
%tbl = table(LPGDP', LPNOx3', LPPM103', LPPM253', LPSO23', LPVOC3', 'VariableNames', {'LPGDP', 'LPNOx3', 'LPPM103', 'LPPM253', 'LPSO23', 'LPVOC3'});
%tbl = table(LPGDP', LPNOx1', LPPM101', LPPM251', LPSO21', LPVOC1', LPNOx2', LPPM102', LPPM252', LPSO22', LPVOC2', 'VariableNames', {'LPGDP', 'LPNOx1', 'LPPM101', 'LPPM251', 'LPSO21', 'LPVOC1', 'LPNOx2', 'LPPM102', 'LPPM252', 'LPSO22', 'LPVOC2'});
tbl = table(LPGDP', LPNOx1', LPPM101', LPPM251', LPSO21', LPVOC1', LPNOx3', LPPM103', LPPM253', LPSO23', LPVOC3', 'VariableNames', {'LPGDP', 'LPNOx1', 'LPPM101', 'LPPM251', 'LPSO21', 'LPVOC1', 'LPNOx3', 'LPPM103', 'LPPM253', 'LPSO23', 'LPVOC3'});
%tbl = table(LPGDP', LPNOx2', LPPM102', LPPM252', LPSO22', LPVOC2', LPNOx3', LPPM103', LPPM253', LPSO23', LPVOC3', 'VariableNames', {'LPGDP', 'LPNOx2', 'LPPM102', 'LPPM252', 'LPSO22', 'LPVOC2', 'LPNOx3', 'LPPM103', 'LPPM253', 'LPSO23', 'LPVOC3'});
%tbl = table(LPGDP', LPNOx1', LPPM101', LPPM251', LPSO21', LPVOC1', LPNOx2', LPPM102', LPPM252', LPSO22', LPVOC2', LPNOx3', LPPM103', LPPM253', LPSO23', LPVOC3', 'VariableNames', {'LPGDP', 'LPNOx1', 'LPPM101', 'LPPM251', 'LPSO21', 'LPVOC1', 'LPNOx2', 'LPPM102', 'LPPM252', 'LPSO22', 'LPVOC2', 'LPNOx3', 'LPPM103', 'LPPM253', 'LPSO23', 'LPVOC3'});  
%tbl = table(LPGDP', LPNOx1', LPVOC1', LPNOx2', LPVOC2', 'VariableNames', {'LPGDP', 'LPNOx1', 'LPVOC1', 'LPNOx2', 'LPVOC2'});
%tbl = table(LPGDP', LPNOx1', LPVOC1', LPNOx3', LPVOC3', 'VariableNames', {'LPGDP', 'LPNOx1', 'LPVOC1', 'LPNOx3', 'LPVOC3'});
%tbl = table(LPGDP', LPNOx2', LPVOC2', LPNOx3', LPVOC3', 'VariableNames', {'LPGDP', 'LPNOx2', 'LPVOC2', 'LPNOx3', 'LPVOC3'});
%tbl = table(LPGDP', LPNOx1', LPSO21', LPVOC1', LPNOx2', LPSO22', LPVOC2', LPNOx3', LPSO23', LPVOC3', 'VariableNames', {'LPGDP', 'LPNOx1', 'LPSO21', 'LPVOC1', 'LPNOx2', 'LPSO22', 'LPVOC2', 'LPNOx3', 'LPSO23', 'LPVOC3'});
%tbl = table(LPGDP', LPNOx1', LPSO21', LPVOC1', LPNOx2', LPSO22', LPVOC2', 'VariableNames', {'LPGDP', 'LPNOx1', 'LPSO21', 'LPVOC1', 'LPNOx2', 'LPSO22', 'LPVOC2'});
%tbl = table(LPGDP', LPNOx2', LPSO22', LPVOC2', LPNOx3', LPSO23', LPVOC3', 'VariableNames', {'LPGDP', 'LPNOx2', 'LPSO22', 'LPVOC2', 'LPNOx3', 'LPSO23', 'LPVOC3'});
%tbl = table(LPGDP', LPNOx1', LPSO21', LPVOC1', LPNOx3', LPSO23', LPVOC3', 'VariableNames', {'LPGDP', 'LPNOx1', 'LPSO21', 'LPVOC1', 'LPNOx3', 'LPSO23', 'LPVOC3'});

% 使用 fitlm 进行多元线性回归
%mdl = fitlm(tbl, 'LPGDP ~ LPNOx1 + LPPM101 + LPPM251 + LPSO21 + LPVOC1');
%mdl = fitlm(tbl, 'LPGDP ~ LPNOx2 + LPPM102 + LPPM252 + LPSO22 + LPVOC2');
%mdl = fitlm(tbl, 'LPGDP ~ LPNOx3 + LPPM103 + LPPM253 + LPSO23 + LPVOC3');
%mdl = fitlm(tbl, 'LPGDP ~ LPNOx1 + LPPM101 + LPPM251 + LPSO21 + LPVOC1 + LPNOx2 + LPPM102 + LPPM252 + LPSO22 + LPVOC2'); 
mdl = fitlm(tbl, 'LPGDP ~ LPNOx1 + LPPM101 + LPPM251 + LPSO21 + LPVOC1 + LPNOx3 + LPPM103 + LPPM253 + LPSO23 + LPVOC3');  
%mdl = fitlm(tbl, 'LPGDP ~ LPNOx2 + LPPM102 + LPPM252 + LPSO22 + LPVOC2 + LPNOx3 + LPPM103 + LPPM253 + LPSO23 + LPVOC3');
%mdl = fitlm(tbl, 'LPGDP ~ LPNOx1 + LPPM101 + LPPM251 + LPSO21 + LPVOC1 + LPNOx2 + LPPM102 + LPPM252 + LPSO22 + LPVOC2 + LPNOx3 + LPPM103 + LPPM253 + LPSO23 + LPVOC3'); 
%mdl = fitlm(tbl, 'LPGDP ~ LPNOx1 + LPVOC1 + LPNOx2 + LPVOC2');
%mdl = fitlm(tbl, 'LPGDP ~ LPNOx1 + LPVOC1 + LPNOx3 + LPVOC3');
%mdl = fitlm(tbl, 'LPGDP ~ LPNOx2 + LPVOC2 + LPNOx3 + LPVOC3');
%mdl = fitlm(tbl, 'LPGDP ~ LPNOx1 + LPSO21 + LPVOC1 + LPNOx2 + LPSO22 + LPVOC2 + LPNOx3 + LPSO23 + LPVOC3');
%mdl = fitlm(tbl, 'LPGDP ~ LPNOx1 + LPSO21 + LPVOC1 + LPNOx2 + LPSO22 + LPVOC2');
%mdl = fitlm(tbl, 'LPGDP ~ LPNOx2 + LPSO22 + LPVOC2 + LPNOx3 + LPSO23 + LPVOC3');
%mdl = fitlm(tbl, 'LPGDP ~ LPNOx1 + LPSO21 + LPVOC1 + LPNOx3 + LPSO23 + LPVOC3');

% 显示回归结果  
disp(mdl);  

% 显示系数和 p 值  
disp('回归系数和 p 值：');  
disp(mdl.Coefficients); 
disp(['调整后的 R²：', num2str(mdl.Rsquared.Adjusted)]);
disp(['AIC 信息准则: ', num2str(mdl.ModelCriterion.AIC)]);
disp(['BIC 信息准则: ', num2str(mdl.ModelCriterion.BIC)]);

% 1. 提取模型中实际使用的自变量数据 (X矩阵)
% mdl.PredictorNames 存储了模型中所有自变量的名字
pred_names = mdl.PredictorNames;

% 从原始 tbl 中提取这些列
X_table = tbl(:, pred_names);

% 转换为矩阵
X = table2array(X_table);

% 2. 计算 VIF
% corrcoef 会自动计算相关系数矩阵（相当于对数据做了标准化处理，无需手动去均值）
R0 = corrcoef(X); 

% 计算逆矩阵对角线
try
    VIF_values = diag(inv(R0));
    
    % 3. 显示结果
    disp('----------------------------------------------------');
    disp('各变量的 VIF 值 (方差膨胀因子):');
    T_VIF = table(pred_names', VIF_values, 'VariableNames', {'Variable', 'VIF'});
    disp(T_VIF);
    
    % 4. 简单的判定提示
    if any(VIF_values > 10)
        disp('提示: 存在 VIF > 10 的变量，说明模型存在严重的多重共线性。');
        disp('这在包含 log(x) 和 log(x)^2 或 log(x)^3 的多项式模型中是正常的结构性共线性。');
    end
catch
    disp('错误: 无法计算 VIF。可能是变量间完全相关(奇异矩阵)，或者样本量太少。');
end 