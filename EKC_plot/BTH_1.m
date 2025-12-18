clc; clear; close all;

%% 1. 数据准备
GDP = [10770.965, 12857.65, 14315.3025, 15543.05, 16618.6125, 17328.2225, 18653.1275, 20639.9325, 19740.875, 21119.785, 21491.27];
NOx = [585.7331, 623.2894, 638.4343, 605.7401, 549.142, 499.37706, 494.3961, 480.6006, 478.0624, 465.4029, 429.3172]*336*12;
PM10 = [317.9904, 321.0648, 326.3581, 314.1876, 276.4355, 231.1147, 206.3284, 182.978, 171.0636, 157.5864, 140.0591]*336*12;
PM25 = [224.7712, 226.8864, 230.7608, 223.7198, 198.6783, 168.0337, 151.7818, 135.5784, 126.5828, 116.8682, 104.0053]*336*12;
SO2 = [528.0241, 545.705, 542.8578, 518.3412, 393.1095, 307.2036, 251.6545, 199.4211, 173.9469, 150.4162, 130.6884]*336*12;
VOC = [471.4384, 483.9073, 496.1671, 501.6432, 504.1259, 523.2058, 524.4208, 499.5984, 491.471, 472.8905, 439.2494]*336*12;
N = 112000000;

% 数据处理
PGDP = GDP/1.12;  
PNOx = NOx*1000/N; PPM10 = PM10*1000/N; PPM25 = PM25*1000/N; PSO2 = SO2*1000/N; PVOC = VOC*1000/N;
FULL_LPGDP = log(PGDP);
FULL_DATA_Y = {log(PNOx), log(PPM10), log(PPM25), log(PSO2), log(PVOC)};

%% 2. 定义情景
scenarios = {
    1:11, '2010-2020 (Original)';
    1:10, '2010-2019 (COVID-19)';
    1:7,  '2010-2016 (VOC controls Pre-2017)';
    4:10, '2013-2019 (APPCP)'
};

%% 3. 绘图设置
figure('Position',[50 50 1200 900], 'Color', 'w');
names_raw  = {'NO_{x}', 'PM_{10}', 'PM_{2.5}', 'SO_{2}', 'VOC'}; 
line_colors = lines(5); 
markers = {'o', 's', 'd', '^', 'v'}; 
x_fit_global = linspace(9.0, 10.0, 200);

% =========================================================================
% 文字位置偏移量
% =========================================================================
manual_offsets = cell(5, 4);
for i=1:5, for j=1:4, manual_offsets{i,j} = [0, 0.15]; end; end

% 图1 (Original)
manual_offsets{1,1} = [0, 0.20];   % NOx
manual_offsets{2,1} = [0, -0.15];  % PM10
manual_offsets{3,1} = [0, -0.15];  % PM2.5
manual_offsets{4,1} = [0, -0.30];  % SO2
manual_offsets{5,1} = [0, 0.30];   % VOC

% 图2 (Drop 2020)
manual_offsets{1,2} = [0, 0.20]; 
manual_offsets{2,2} = [0, -0.20]; 
manual_offsets{3,2} = [0, -0.20]; 
manual_offsets{4,2} = [0, -0.30]; 
manual_offsets{5,2} = [0, 0.30]; 

% 图3
manual_offsets{1,3} = [0, 0.20]; 
manual_offsets{2,3} = [0, -0.20]; 
manual_offsets{3,3} = [0, -0.20]; 
manual_offsets{4,3} = [0, -0.30]; 

% 图4
manual_offsets{1,4} = [0, -0.20]; 
manual_offsets{5,4} = [0, 0.20]; 

% 打印表头到命令行
fprintf('================================================================================================================\n');
fprintf('%-25s %-10s %-40s %-10s %-10s\n', 'Scenario', 'Pollutant', 'EKC Equation (y = ax^2 + bx + c)', 'R-Squared', 'P-Value');
fprintf('================================================================================================================\n');

for s = 1:4
    subplot(2, 2, s); hold on; box on;
    idx_range = scenarios{s, 1};
    plot_title = scenarios{s, 2};
    sub_LPGDP = FULL_LPGDP(idx_range);
    
    % 转置为列向量
    x_data = sub_LPGDP(:); 
    
    for k = 1:5
        full_y = FULL_DATA_Y{k};
        sub_y = full_y(idx_range);
        y_data = sub_y(:);
        col = line_colors(k, :);
        
        % --- 使用 fitlm 进行拟合 ---
        tbl = table(x_data, y_data, 'VariableNames', {'x', 'y'});
        lm = fitlm(tbl, 'y ~ x + x^2');
        
        % 提取系数
        coeffs = lm.Coefficients.Estimate;
        c_val = coeffs(1); % Intercept
        b_val = coeffs(2); % x
        a_val = coeffs(3); % x^2
        
        % 提取 R2
        r_squared = lm.Rsquared.Ordinary;
        
        % --- 修改部分：兼容旧版本的 P 值提取方法 ---
        % 方法：对回归模型做方差分析 (ANOVA)
        anova_tbl = anova(lm, 'summary'); 
        % 模型的 P 值通常位于 ANOVA 表的第二行（Model 行）或者最后一行倒数第二
        % 在 'summary' 模式下，p值在第一行（Model）的 'pValue' 列
        if istable(anova_tbl)
             % 新版本 table 格式
             p_val = anova_tbl.pValue(2); % 通常第2行是Model，第1行是x，具体取决于版本，更稳妥是直接用 coefTest
             
             % 更稳妥的方法：直接比较 常数模型 和 当前模型
             % F-test of the regression model vs. constant model
             p_val = coefTest(lm, [0 1 0; 0 0 1]); % 同时检验 x 和 x^2 是否都为0
        else
            % 旧版本 dataset 格式或其他，尝试直接访问属性
            % 如果上面报错，使用下面的通用计算方式：
            dof_model = lm.NumCoefficients - 1; % 自由度 (k)
            dof_error = lm.DFE;                 % 误差自由度 (n-k-1)
            f_stat = (lm.SSR / dof_model) / (lm.SSE / dof_error); % F统计量
            p_val = 1 - fcdf(f_stat, dof_model, dof_error);       % 计算P值
        end
        
        % --- 打印到命令行 ---
        eq_str = sprintf('y = %.2fx^2 + %.2fx + %.2f', a_val, b_val, c_val);
        
        if p_val < 0.001
            p_str_disp = '<0.001';
        else
            p_str_disp = sprintf('%.4f', p_val);
        end
        
        fprintf('%-25s %-10s %-40s %.4f     %s\n', plot_title, names_raw{k}, eq_str, r_squared, p_str_disp);
        
        % --- 绘图曲线 ---
        y_fit = a_val .* x_fit_global.^2 + b_val .* x_fit_global + c_val;
        
        % --- 图例 ---
        if p_val < 0.01
            p_legend = 'P<0.01';
        elseif p_val < 0.05
            p_legend = 'P<0.05';
        else
            p_legend = sprintf('P=%.2f', p_val);
        end
        display_name = sprintf('%s (R^2=%.2f, %s)', names_raw{k}, r_squared, p_legend);
        
        plot(sub_LPGDP, sub_y, markers{k}, 'Color', col, 'MarkerSize', 5, 'LineWidth', 1, 'HandleVisibility', 'off');
        plot(x_fit_global, y_fit, '-', 'Color', col, 'LineWidth', 1.5, 'DisplayName', display_name);
        
        % 拐点
        x_inf = -b_val / (2 * a_val);
        y_inf = a_val * x_inf^2 + b_val * x_inf + c_val;
        
        if x_inf >= 9.0 && x_inf <= 10.0
            plot(x_inf, y_inf, 'o', 'MarkerSize', 6, 'MarkerFaceColor', col, 'MarkerEdgeColor', 'k', 'HandleVisibility', 'off');
            off = manual_offsets{k, s};
            text(x_inf + off(1), y_inf + off(2), sprintf('(%.2f, %.2f)', x_inf, y_inf), ...
                'Color', col, 'FontSize', 8, 'FontWeight', 'bold', ...
                'HorizontalAlignment', 'center');
        end
    end
    
    title(plot_title, 'FontSize', 16, 'FontWeight', 'bold');
    xlabel('LnP(GDP)', 'FontSize', 12); ylabel('LP(Pollutants)', 'FontSize', 12);
    grid on; grid minor;
    
    labels = {'(a)', '(b)', '(c)', '(d)'};
    text(0.02, 0.98, labels{s}, 'Units', 'normalized', 'FontSize', 18, ...
        'FontWeight', 'bold', 'VerticalAlignment', 'top', 'HorizontalAlignment', 'left');
    
    legend('Show', 'Location', 'southwest', 'FontSize', 6, 'NumColumns', 1, 'Interpreter', 'tex');
    xlim([9.0, 10.0]); ylim([0, 4.5]); 
end

sgtitle('BTH EKC Analysis (with P-Values)', 'FontSize', 20, 'FontWeight', 'bold');