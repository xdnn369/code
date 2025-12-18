clc; clear;

%% 1. 数据准备 (CC Region - 成渝地区)
GDP = [6198.21, 7759.45, 8827.20, 9729.38, 10700.52, 11455.71, 12559.82, 14120.12, 16122.73, 17492.38, 18385.77];
NOx = [211.7535, 219.8885, 231.2751, 227.3143, 214.7103, 204.0944, 196.3559, 191.6953, 187.6683, 183.0575, 173.3192]*448*12;
PM10 = [186.5676, 176.6986, 176.3333, 167.4231, 153.1331, 138.094, 122.9401, 114.4706, 104.5831, 99.75909, 92.38957]*448*12;
PM25 = [137.9454, 130.5915, 129.0357, 120.8866, 112.3823, 103.0199, 94.47189, 88.38704, 81.28024, 77.9324, 72.69312]*448*12;
SO2 = [423.9638, 433.232, 447.4058, 407.6285, 306.989, 237.0381, 187.0147, 148.1375, 106.9549, 91.94138, 83.13609]*448*12;
VOC = [286.9745, 296.0299, 299.3253, 300.2199, 303.8161, 317.2034, 328.2599, 325.2101, 321.8946, 310.0437, 292.5713]*448*12;

N = 91000000; % 人口

% 人均化处理 (注意系数调整：CC数据 GDP系数为0.91)
PGDP = GDP/0.91;  
PNOx = NOx*1000/N; 
PPM10 = PM10*1000/N;
PPM25 = PM25*1000/N;
PSO2 = SO2*1000/N;
PVOC = VOC*1000/N;

% 取对数
LPGDP = log(PGDP); 
data_y = {log(PNOx), log(PPM10), log(PPM25), log(PSO2), log(PVOC)};
names  = {'NOx', 'PM10', 'PM2.5', 'SO2', 'VOC'};

% Bootstrap 参数
n_boot = 1000;    
alpha_ci = 0.05;  

%% 2. 输出表头
fprintf('\n');
fprintf('===========================================================================\n');
fprintf('          CC Region EKC Turning Point Analysis (Bootstrap & Robust)        \n');
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
    % 构建设计矩阵 [1, x, x^2]
    X_design = [ones(n_samples,1), X_vec', (X_vec').^2];
    try
        % robustfit 默认使用 bisquare 权重函数
        b_rob = robustfit(X_design(:,2:3), Y_vec'); 
        % b_rob 顺序: [常数项, 一次项系数, 二次项系数]
        robust_tp = -b_rob(2) / (2 * b_rob(3));
    catch
        robust_tp = NaN; 
    end
    
    % --- Step 4: 输出结果 ---
    fprintf('%-10s | %12.4f | [%.4f, %.4f]    | %12.4f\n', ...
        names{k}, original_tp, ci_lower, ci_upper, robust_tp);
end

fprintf('---------------------------------------------------------------------------\n');
fprintf('* OLS TP: 普通最小二乘法计算的拐点\n');
fprintf('* Robust TP: 使用抗异常值的稳健回归计算的拐点\n');