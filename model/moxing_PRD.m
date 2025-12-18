GDP = [18069.54, 21049.88, 22848.69, 25275.95, 27313.54, 27942.41, 29827.91, 33300.08, 36705.26, 38725.84, 36296.57];
NOx = [743.2463, 757.7053, 746.3904, 667.8129, 593.197, 587.0988, 547.3233, 559.2439, 554.4211, 541.7061, 521.8091]*96*12;
PM10 = [235.2663, 237.0536, 226.1573, 216.4901, 177.6967, 161.4506, 152.1251, 150.2433, 141.208, 136.3683, 130.033]*96*12;
PM25 = [149.1867, 148.4358, 141.1529, 132.9119, 114.2929, 108.9872, 107.0973, 105.5365, 99.34441, 96.43365, 92.37722]*96*12;
SO2 = [548.7554, 573.3709, 532.574, 428.6082, 325.9286, 295.0782, 262.1447, 220.9398, 189.8696, 158.8403, 142.8311]*96*12;
VOC = [1067.915, 1063.555, 1074.838, 1118.341, 1100.3, 1159.53, 1154.14, 1102.336, 1148.222, 1134.735, 1070.628]*96*12;

N = 86440000;

PGDP = GDP/0.8644;  %人均GDP（元/人）
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
%tbl = table(LPGDP', LPNOx1', LPPM101', LPPM251', LPSO21', LPVOC1', LPNOx3', LPPM103', LPPM253', LPSO23', LPVOC3', 'VariableNames', {'LPGDP', 'LPNOx1', 'LPPM101', 'LPPM251', 'LPSO21', 'LPVOC1', 'LPNOx3', 'LPPM103', 'LPPM253', 'LPSO23', 'LPVOC3'});
%tbl = table(LPGDP', LPNOx2', LPPM102', LPPM252', LPSO22', LPVOC2', LPNOx3', LPPM103', LPPM253', LPSO23', LPVOC3', 'VariableNames', {'LPGDP', 'LPNOx2', 'LPPM102', 'LPPM252', 'LPSO22', 'LPVOC2', 'LPNOx3', 'LPPM103', 'LPPM253', 'LPSO23', 'LPVOC3'});
%tbl = table(LPGDP', LPNOx1', LPPM101', LPPM251', LPSO21', LPVOC1', LPNOx2', LPPM102', LPPM252', LPSO22', LPVOC2', LPNOx3', LPPM103', LPPM253', LPSO23', LPVOC3', 'VariableNames', {'LPGDP', 'LPNOx1', 'LPPM101', 'LPPM251', 'LPSO21', 'LPVOC1', 'LPNOx2', 'LPPM102', 'LPPM252', 'LPSO22', 'LPVOC2', 'LPNOx3', 'LPPM103', 'LPPM253', 'LPSO23', 'LPVOC3'});  
%tbl = table(LPGDP', LPNOx1', LPVOC1', LPNOx2', LPVOC2', 'VariableNames', {'LPGDP', 'LPNOx1', 'LPVOC1', 'LPNOx2', 'LPVOC2'});
%tbl = table(LPGDP', LPNOx1', LPVOC1', LPNOx3', LPVOC3', 'VariableNames', {'LPGDP', 'LPNOx1', 'LPVOC1', 'LPNOx3', 'LPVOC3'});
%tbl = table(LPGDP', LPNOx2', LPVOC2', LPNOx3', LPVOC3', 'VariableNames', {'LPGDP', 'LPNOx2', 'LPVOC2', 'LPNOx3', 'LPVOC3'});
%tbl = table(LPGDP', LPNOx1', LPSO21', LPVOC1', LPNOx2', LPSO22', LPVOC2', LPNOx3', LPSO23', LPVOC3', 'VariableNames', {'LPGDP', 'LPNOx1', 'LPSO21', 'LPVOC1', 'LPNOx2', 'LPSO22', 'LPVOC2', 'LPNOx3', 'LPSO23', 'LPVOC3'});
%tbl = table(LPGDP', LPNOx1', LPSO21', LPVOC1', LPNOx2', LPSO22', LPVOC2', 'VariableNames', {'LPGDP', 'LPNOx1', 'LPSO21', 'LPVOC1', 'LPNOx2', 'LPSO22', 'LPVOC2'});
%tbl = table(LPGDP', LPNOx2', LPSO22', LPVOC2', LPNOx3', LPSO23', LPVOC3', 'VariableNames', {'LPGDP', 'LPNOx2', 'LPSO22', 'LPVOC2', 'LPNOx3', 'LPSO23', 'LPVOC3'});
%tbl = table(LPGDP', LPNOx1', LPSO21', LPVOC1', LPNOx3', LPSO23', LPVOC3', 'VariableNames', {'LPGDP', 'LPNOx1', 'LPSO21', 'LPVOC1', 'LPNOx3', 'LPSO23', 'LPVOC3'});
%tbl = table(LPGDP', LPNOx1', LPPM101', LPSO21', LPVOC1', LPNOx2', LPPM102', LPSO22', LPVOC2', 'VariableNames', {'LPGDP', 'LPNOx1', 'LPPM101', 'LPSO21', 'LPVOC1', 'LPNOx2', 'LPPM102', 'LPSO22', 'LPVOC2'});
tbl = table(LPGDP', LPNOx2', LPPM102', LPSO22', LPVOC2', LPNOx3', LPPM103', LPSO23', LPVOC3', 'VariableNames', {'LPGDP', 'LPNOx2', 'LPPM102', 'LPSO22', 'LPVOC2', 'LPNOx3', 'LPPM103', 'LPSO23', 'LPVOC3'});


% 使用 fitlm 进行多元线性回归
%mdl = fitlm(tbl, 'LPGDP ~ LPNOx1 + LPPM101 + LPPM251 + LPSO21 + LPVOC1');
%mdl = fitlm(tbl, 'LPGDP ~ LPNOx2 + LPPM102 + LPPM252 + LPSO22 + LPVOC2');
%mdl = fitlm(tbl, 'LPGDP ~ LPNOx3 + LPPM103 + LPPM253 + LPSO23 + LPVOC3');
%mdl = fitlm(tbl, 'LPGDP ~ LPNOx1 + LPPM101 + LPPM251 + LPSO21 + LPVOC1 + LPNOx2 + LPPM102 + LPPM252 + LPSO22 + LPVOC2'); 
%mdl = fitlm(tbl, 'LPGDP ~ LPNOx1 + LPPM101 + LPPM251 + LPSO21 + LPVOC1 + LPNOx3 + LPPM103 + LPPM253 + LPSO23 + LPVOC3');  
%mdl = fitlm(tbl, 'LPGDP ~ LPNOx2 + LPPM102 + LPPM252 + LPSO22 + LPVOC2 + LPNOx3 + LPPM103 + LPPM253 + LPSO23 + LPVOC3');
%mdl = fitlm(tbl, 'LPGDP ~ LPNOx1 + LPPM101 + LPPM251 + LPSO21 + LPVOC1 + LPNOx2 + LPPM102 + LPPM252 + LPSO22 + LPVOC2 + LPNOx3 + LPPM103 + LPPM253 + LPSO23 + LPVOC3'); 
%mdl = fitlm(tbl, 'LPGDP ~ LPNOx1 + LPVOC1 + LPNOx2 + LPVOC2');
%mdl = fitlm(tbl, 'LPGDP ~ LPNOx1 + LPVOC1 + LPNOx3 + LPVOC3');
%mdl = fitlm(tbl, 'LPGDP ~ LPNOx2 + LPVOC2 + LPNOx3 + LPVOC3');
%mdl = fitlm(tbl, 'LPGDP ~ LPNOx1 + LPSO21 + LPVOC1 + LPNOx2 + LPSO22 + LPVOC2 + LPNOx3 + LPSO23 + LPVOC3');
%mdl = fitlm(tbl, 'LPGDP ~ LPNOx1 + LPSO21 + LPVOC1 + LPNOx2 + LPSO22 + LPVOC2');
%mdl = fitlm(tbl, 'LPGDP ~ LPNOx2 + LPSO22 + LPVOC2 + LPNOx3 + LPSO23 + LPVOC3');
%mdl = fitlm(tbl, 'LPGDP ~ LPNOx1 + LPSO21 + LPVOC1 + LPNOx3 + LPSO23 + LPVOC3');
%mdl = fitlm(tbl, 'LPGDP ~ LPNOx1 + LPPM101 + LPSO21 + LPVOC1 + LPNOx2 + LPPM102 + LPSO22 + LPVOC2'); 
mdl = fitlm(tbl, 'LPGDP ~ LPNOx2 + LPPM102 + LPSO22 + LPVOC2 + LPNOx3 + LPPM103 + LPSO23 + LPVOC3'); 

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