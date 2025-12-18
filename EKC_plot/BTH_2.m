clc; clear;

%% 1. 数据准备 (BTH Region)
GDP = [10770.965, 12857.65, 14315.3025, 15543.05, 16618.6125, 17328.2225, 18653.1275, 20639.9325, 19740.875, 21119.785, 21491.27];
NOx = [585.7331, 623.2894, 638.4343, 605.7401, 549.142, 499.37706, 494.3961, 480.6006, 478.0624, 465.4029, 429.3172]*336*12;
PM10 = [317.9904, 321.0648, 326.3581, 314.1876, 276.4355, 231.1147, 206.3284, 182.978, 171.0636, 157.5864, 140.0591]*336*12;
PM25 = [224.7712, 226.8864, 230.7608, 223.7198, 198.6783, 168.0337, 151.7818, 135.5784, 126.5828, 116.8682, 104.0053]*336*12;
SO2 = [528.0241, 545.705, 542.8578, 518.3412, 393.1095, 307.2036, 251.6545, 199.4211, 173.9469, 150.4162, 130.6884]*336*12;
VOC = [471.4384, 483.9073, 496.1671, 501.6432, 504.1259, 523.2058, 524.4208, 499.5984, 491.471, 472.8905, 439.2494]*336*12;

N = 112000000;

% 人均化与对数化
PGDP = GDP/1.12;  
PNOx = NOx*1000/N; 
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