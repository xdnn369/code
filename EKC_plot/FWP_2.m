clc; clear;

%% 1. 数据准备 (FWP数据)
GDP = [10513.07, 12680.88, 14093.53, 15200.53, 16347.19, 16996.17, 18063.44, 20465.12, 22458.98, 24118.14, 24527.29];
NOx = [357.8935, 391.343, 389.7938, 368.9487, 338.1034, 309.2535, 288.6632, 271.1577, 266.3369, 257.7487, 241.388]*864*12;
PM10 = [242.536, 246.5165, 244.021, 234.7632, 208.9689, 181.7004, 154.7969, 135.3659, 118.6768, 107.3665, 97.757]*864*12;
PM25 = [169.9483, 173.2775, 171.6466, 163.4249, 148.1305, 131.1356, 114.7791, 100.8388, 89.2038, 81.10292, 73.98151]*864*12;
SO2 = [441.8968, 454.5253, 417.0208, 381.059, 315.1355, 264.9136, 211.5143, 157.8265, 120.1367, 103.9895, 92.36337]*864*12;
VOC = [267.6003, 277.6305, 284.8626, 286.1539, 286.4388, 291.9033, 292.2526, 283.2387, 277.2345, 264.7794, 249.5817]*864*12;

N = 55544500;

% 注意：这里保留了您原FWP代码中的特殊计算方式
PGDP = GDP/0.555445;  % 人均GDP（元/人）
PNOx = NOx*1000/N;    % 人均NOx（千克/人）
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
fprintf('          FWP Region EKC Turning Point Analysis (Bootstrap & Robust)       \n');
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