clc; clear; close all;

%% 1. 数据准备 (CC Data)
GDP = [6198.21, 7759.45, 8827.20, 9729.38, 10700.52, 11455.71, 12559.82, 14120.12, 16122.73, 17492.38, 18385.77];
NOx = [211.7535, 219.8885, 231.2751, 227.3143, 214.7103, 204.0944, 196.3559, 191.6953, 187.6683, 183.0575, 173.3192]*448*12;
PM10 = [186.5676, 176.6986, 176.3333, 167.4231, 153.1331, 138.094, 122.9401, 114.4706, 104.5831, 99.75909, 92.38957]*448*12;
PM25 = [137.9454, 130.5915, 129.0357, 120.8866, 112.3823, 103.0199, 94.47189, 88.38704, 81.28024, 77.9324, 72.69312]*448*12;
SO2 = [423.9638, 433.232, 447.4058, 407.6285, 306.989, 237.0381, 187.0147, 148.1375, 106.9549, 91.94138, 83.13609]*448*12;
VOC = [286.9745, 296.0299, 299.3253, 300.2199, 303.8161, 317.2034, 328.2599, 325.2101, 321.8946, 310.0437, 292.5713]*448*12;

N = 91000000;

% 数据处理
PGDP = GDP/0.91;  
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
x_fit_global = linspace(8.8, 10.0, 200); % CC X轴范围

% =========================================================================
% [重点修改区域] 手动调整文字位置偏移量 [x偏移, y偏移]
% =========================================================================
manual_offsets = cell(5, 4);
% 初始化默认偏移 (默认为向上 0.15)
for i=1:5, for j=1:4, manual_offsets{i,j} = [0, 0.15]; end; end

% --- 根据 CC 原始代码中的设置预设偏移 ---

% 场景 1 (Original)
manual_offsets{4,1} = [0, 0.20];   % SO2
manual_offsets{5,1} = [0, 0.20];   % VOC

% 场景 2 (COVID-19)
manual_offsets{4,2} = [0, 0.20]; 
manual_offsets{5,2} = [0, 0.20]; 

% 场景 3 (Pre-2017)
manual_offsets{2,3} = [0, -0.15]; 
manual_offsets{3,3} = [0, -0.15]; 
manual_offsets{4,3} = [0, 0.20]; 
manual_offsets{5,3} = [0.05, 0.20]; 

% 场景 4 (APPCP)
manual_offsets{1,4} = [0, 0.20]; 
manual_offsets{5,4} = [0, 0.20]; 

% 打印表头到命令行
fprintf('\n================================================================================================================\n');
fprintf('REGION: CC (Chengdu-Chongqing)\n');
fprintf('================================================================================================================\n');
fprintf('%-25s %-10s %-40s %-10s %-10s\n', 'Scenario', 'Pollutant', 'EKC Equation (y = ax^2 + bx + c)', 'R-Squared', 'P-Value');
fprintf('----------------------------------------------------------------------------------------------------------------\n');

for s = 1:4
    subplot(2, 2, s); hold on; box on;
    idx_range = scenarios{s, 1};
    plot_title = scenarios{s, 2};
    sub_LPGDP = FULL_LPGDP(idx_range);
    
    % 转置为列向量以便 fitlm 使用
    x_data = sub_LPGDP(:); 
    
    for k = 1:5
        full_y = FULL_DATA_Y{k};
        sub_y = full_y(idx_range);
        y_data = sub_y(:);
        col = line_colors(k, :);
        
        % --- 使用 fitlm 进行拟合以获取 P 值 ---
        % 模型：y ~ 1 + x + x^2
        tbl = table(x_data, y_data, 'VariableNames', {'x', 'y'});
        lm = fitlm(tbl, 'y ~ x + x^2');
        
        % 提取系数 (Matlab fitlm 系数顺序通常是：Intercept, x, x^2)
        % 注意：ax^2 + bx + c 对应 lm.Coefficients.Estimate(3), (2), (1)
        coeffs = lm.Coefficients.Estimate;
        c_val = coeffs(1); % c
        b_val = coeffs(2); % b
        a_val = coeffs(3); % a
        
        % 提取 R2
        r_squared = lm.Rsquared.Ordinary;
        
        % --- 获取整个模型 F 检验的 p 值 (兼容旧版本) ---
        try
            % 尝试使用 coefTest (适用于较新版本及部分旧版本)
            % 检验 x 和 x^2 是否同时为 0
            p_val = coefTest(lm, [0 1 0; 0 0 1]); 
        catch
            % 如果报错，手动计算 F 统计量和 P 值
            dof_model = lm.NumCoefficients - 1; % 自由度 (k=2)
            dof_error = lm.DFE;                 % 误差自由度 (n-k-1)
            f_stat = (lm.SSR / dof_model) / (lm.SSE / dof_error); % F统计量
            p_val = 1 - fcdf(f_stat, dof_model, dof_error);       % 计算P值
        end
        
        % --- 打印到命令行 ---
        eq_str = sprintf('y = %.2fx^2 + %.2fx + %.2f', a_val, b_val, c_val);
        
        % P值显示格式处理
        if p_val < 0.001
            p_str_disp = '<0.001';
        else
            p_str_disp = sprintf('%.4f', p_val);
        end
        
        fprintf('%-25s %-10s %-40s %.4f     %s\n', plot_title, names_raw{k}, eq_str, r_squared, p_str_disp);
        
        % --- 计算拟合曲线用于绘图 ---
        y_fit = a_val .* x_fit_global.^2 + b_val .* x_fit_global + c_val;
        
        % --- 构建图例名称 (包含R2 和 P) ---
        if p_val < 0.01
            p_legend = 'P<0.01';
        elseif p_val < 0.05
            p_legend = 'P<0.05';
        else
            p_legend = sprintf('P=%.2f', p_val);
        end
        display_name = sprintf('%s (R^2=%.2f, %s)', names_raw{k}, r_squared, p_legend);
        
        % 绘图
        plot(sub_LPGDP, sub_y, markers{k}, 'Color', col, 'MarkerSize', 5, 'LineWidth', 1, 'HandleVisibility', 'off');
        plot(x_fit_global, y_fit, '-', 'Color', col, 'LineWidth', 1.5, 'DisplayName', display_name);
        
        % 拐点计算 x = -b / 2a
        x_inf = -b_val / (2 * a_val);
        y_inf = a_val * x_inf^2 + b_val * x_inf + c_val;
        
        % 绘制拐点和文字 (范围: 8.8 - 10.0)
        if x_inf >= 8.8 && x_inf <= 10.0
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
    xlim([8.8, 10.0]); ylim([0, 5]); 
end

sgtitle('CC EKC Analysis (with P-Values)', 'FontSize', 20, 'FontWeight', 'bold');
fprintf('================================================================================================================\n');