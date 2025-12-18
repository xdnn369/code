GDP = [24316.47, 28727.59, 31494.48, 34342.83, 37412.88, 39993.37, 43538.80, 48830.43, 55308.28, 58987.96, 61130.39];   % GDP总量（亿元）
NOx = [861.3655, 895.7939, 877.3549, 835.2065, 758.899, 709.5309, 674.3826, 669.517, 652.1056, 638.5813, 602.6002]*240*12;     % NOx(吨）
PM10 = [351.5295, 336.1206, 331.2637, 311.219, 283.4729, 235.0518, 196.1718, 173.4164, 155.8321, 149.7162, 141.8288]*240*12;     % PM10
PM25 = [235.9154, 225.5259, 221.2694, 208.94, 191.9406, 161.2064, 137.462, 122.952, 111.2377, 107.4047, 102.3659]*240*12;     % PM2.5
SO2 = [614.9808, 627.3188, 579.3593, 497.9908, 402.8242, 311.317, 278.6179, 216.579, 172.9599, 157.463, 152.8898]*240*12;     % SO2
VOC = [837.7418, 870.7666, 913.1992, 948.6218, 975.5098, 1042.903, 1048.534, 1036.852, 1053.941, 1047.863, 1000.008]*240*12;     % VOC(百万摩尔)

N = 230000000;     %人口总数

PGDP = GDP/2.3;  %人均GDP（元/人）
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
%tbl = table(LPGDP', LPNOx1', LPPM101', LPPM251', LPSO21', LPVOC1', LPNOx2', LPPM102', LPPM252', LPSO22', LPVOC2', LPNOx3', LPPM103', LPPM253', LPSO23', LPVOC3', %'VariableNames', {'LPGDP', 'LPNOx1', 'LPPM101', 'LPPM251', 'LPSO21', 'LPVOC1', 'LPNOx2', 'LPPM102', 'LPPM252', 'LPSO22', 'LPVOC2', 'LPNOx3', 'LPPM103', 'LPPM253', 'LPSO23', 'LPVOC3'});  
%tbl = table(LPGDP', LPNOx1', LPVOC1', LPNOx2', LPVOC2', 'VariableNames', {'LPGDP', 'LPNOx1', 'LPVOC1', 'LPNOx2', 'LPVOC2'});
%tbl = table(LPGDP', LPNOx1', LPVOC1', LPNOx3', LPVOC3', 'VariableNames', {'LPGDP', 'LPNOx1', 'LPVOC1', 'LPNOx3', 'LPVOC3'});
%tbl = table(LPGDP', LPNOx2', LPVOC2', LPNOx3', LPVOC3', 'VariableNames', {'LPGDP', 'LPNOx2', 'LPVOC2', 'LPNOx3', 'LPVOC3'});
%tbl = table(LPGDP', LPNOx1', LPSO21', LPVOC1', LPNOx2', LPSO22', LPVOC2', LPNOx3', LPSO23', LPVOC3', 'VariableNames', {'LPGDP', 'LPNOx1', 'LPSO21', 'LPVOC1', 'LPNOx2', 'LPSO22', 'LPVOC2', 'LPNOx3', 'LPSO23', 'LPVOC3'});
%tbl = table(LPGDP', LPNOx1', LPSO21', LPVOC1', LPNOx2', LPSO22', LPVOC2', 'VariableNames', {'LPGDP', 'LPNOx1', 'LPSO21', 'LPVOC1', 'LPNOx2', 'LPSO22', 'LPVOC2'});
%tbl = table(LPGDP', LPNOx2', LPSO22', LPVOC2', LPNOx3', LPSO23', LPVOC3', 'VariableNames', {'LPGDP', 'LPNOx2', 'LPSO22', 'LPVOC2', 'LPNOx3', 'LPSO23', 'LPVOC3'});
tbl = table(LPGDP', LPNOx1', LPSO21', LPVOC1', LPNOx3', LPSO23', LPVOC3', 'VariableNames', {'LPGDP', 'LPNOx1', 'LPSO21', 'LPVOC1', 'LPNOx3', 'LPSO23', 'LPVOC3'});
    
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
mdl = fitlm(tbl, 'LPGDP ~ LPNOx1 + LPSO21 + LPVOC1 + LPNOx3 + LPSO23 + LPVOC3');

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