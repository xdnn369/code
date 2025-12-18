clc; clear;

%% 1. 数据准备 (YRD Region - 用户提供数据)
GDP = [24316.47, 28727.59, 31494.48, 34342.83, 37412.88,...
       39993.37, 43538.80, 48830.43, 55308.28, 58987.96, 61130.39];
NOx = [861.3655, 895.7939, 877.3549, 835.2065, 758.899,...
       709.5309, 674.3826, 669.517, 652.1056, 638.5813, 602.6002]*240*12;
PM10 = [351.5295, 336.1206, 331.2637, 311.219, 283.4729,...
        235.0518, 196.1718, 173.4164, 155.8321, 149.7162, 141.8288]*240*12;
PM25 = [235.9154, 225.5259, 221.2694, 208.94, 191.9406,...
        161.2064, 137.462, 122.952, 111.2377, 107.4047, 102.3659]*240*12;
SO2 = [614.9808, 627.3188, 579.3593, 497.9908, 402.8242,...
       311.317, 278.6179, 216.579, 172.9599, 157.463, 152.8898]*240*12;
VOC = [837.7418, 870.7666, 913.1992, 948.6218, 975.5098,...
       1042.903, 1048.534, 1036.852, 1053.941, 1047.863, 1000.008]*240*12;

N = 230000000;

% 人均化处理 (按照用户指令 GDP/2.3)
PGDP = GDP/2.3;  
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
fprintf('          YRD Region EKC Turning Point Analysis (Bootstrap & Robust)       \n');
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