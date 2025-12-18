clc; clear;

%% 1. 数据准备 (PRD数据)
GDP = [18069.54, 21049.88, 22848.69, 25275.95, 27313.54, 27942.41, 29827.91, 33300.08, 36705.26, 38725.84, 36296.57];
NOx = [743.2463, 757.7053, 746.3904, 667.8129, 593.197, 587.0988, 547.3233, 559.2439, 554.4211, 541.7061, 521.8091]*96*12;
PM10 = [235.2663, 237.0536, 226.1573, 216.4901, 177.6967, 161.4506, 152.1251, 150.2433, 141.208, 136.3683, 130.033]*96*12;
PM25 = [149.1867, 148.4358, 141.1529, 132.9119, 114.2929, 108.9872, 107.0973, 105.5365, 99.34441, 96.43365, 92.37722]*96*12;
SO2 = [548.7554, 573.3709, 532.574, 428.6082, 325.9286, 295.0782, 262.1447, 220.9398, 189.8696, 158.8403, 142.8311]*96*12;
VOC = [1067.915, 1063.555, 1074.838, 1118.341, 1100.3, 1159.53, 1154.14, 1102.336, 1148.222, 1134.735, 1070.628]*96*12;

N = 86440000;

PGDP = GDP/0.8644;  % 人均GDP（元/人）
PNOx = NOx*1000/N;  % 人均NOx（千克/人）
PPM10 = PM10*1000/N;
PPM25 = PM25*1000/N;
PSO2 = SO2*1000/N;
PVOC = VOC*1000/N;

LPGDP = log(PGDP); 
data_y = {log(PNOx), log(PPM10), log(PPM25), log(PSO2), log(PVOC)};
names  = {'NOx', 'PM10', 'PM2.5', 'SO2', 'VOC'};

% Bootstrap 参数
n_boot = 1000;    
alpha_ci = 0.05;  

%% 2. 输出表头
fprintf('\n');
fprintf('===========================================================================\n');
fprintf('          BTH Region EKC Turning Point Analysis (Bootstrap & Robust)       \n');
fprintf('===========================================================================\n');
fprintf('%-10s | %-12s | %-20s | %-12s\n', 'Pollutant', 'OLS TP', 'Bootstrap 95% CI', 'Robust TP');
fprintf('---------------------------------------------------------------------------\n');

%% 3. 循环计算
for k = 1:5
    curr_y = data_y{k}; 
    X_vec = LPGDP;
    Y_vec = curr_y;
    n_samples = length(X_vec);
    
    % --- Step 1: 原始 OLS 拐点 ---
    p = polyfit(X_vec, Y_vec, 2);
    original_tp = -p(2)/(2*p(1)); 
    
    % --- Step 2: Bootstrap CI ---
    boot_tps = zeros(n_boot, 1);
    warning('off', 'MATLAB:polyfit:RepeatedPointsOrRescale');
    for b = 1:n_boot
        idx = randi(n_samples, n_samples, 1);
        X_sample = X_vec(idx);
        Y_sample = Y_vec(idx);
        p_boot = polyfit(X_sample, Y_sample, 2);
        
        if abs(p_boot(1)) < 1e-8
            boot_tps(b) = NaN; 
        else
            boot_tps(b) = -p_boot(2) / (2 * p_boot(1));
        end
    end
    warning('on', 'MATLAB:polyfit:RepeatedPointsOrRescale');
    ci_lower = quantile(boot_tps, alpha_ci/2);
    ci_upper = quantile(boot_tps, 1 - alpha_ci/2);
    
    % --- Step 3: Robust Regression 拐点 ---
    % 需要 Statistics Toolbox 中的 robustfit
    % 构建设计矩阵 [1, x, x^2]
    X_design = [ones(n_samples,1), X_vec', (X_vec').^2];
    try
        % robustfit 默认使用 bisquare 权重函数
        b_rob = robustfit(X_design(:,2:3), Y_vec'); 
        % b_rob 顺序: [常数项, 一次项系数, 二次项系数]
        robust_tp = -b_rob(2) / (2 * b_rob(3));
    catch
        robust_tp = NaN; % 如果未安装统计工具箱
    end
    
    % --- Step 4: 输出结果 ---
    fprintf('%-10s | %12.4f | [%.4f, %.4f]    | %12.4f\n', ...
        names{k}, original_tp, ci_lower, ci_upper, robust_tp);
end

fprintf('---------------------------------------------------------------------------\n');
fprintf('* OLS TP: 普通最小二乘法计算的拐点\n');
fprintf('* Robust TP: 使用抗异常值的稳健回归计算的拐点\n');