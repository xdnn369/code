clc; clear; close all;

%% 1. 数据准备 (YRD Data)
GDP = [24316.47, 28727.59, 31494.48, 34342.83, 37412.88, 39993.37, 43538.80, 48830.43, 55308.28, 58987.96, 61130.39];
NOx = [861.3655, 895.7939, 877.3549, 835.2065, 758.899, 709.5309, 674.3826, 669.517, 652.1056, 638.5813, 602.6002]*240*12;
PM10 = [351.5295, 336.1206, 331.2637, 311.219, 283.4729, 235.0518, 196.1718, 173.4164, 155.8321, 149.7162, 141.8288]*240*12;
PM25 = [235.9154, 225.5259, 221.2694, 208.94, 191.9406, 161.2064, 137.462, 122.952, 111.2377, 107.4047, 102.3659]*240*12;
SO2 = [614.9808, 627.3188, 579.3593, 497.9908, 402.8242, 311.317, 278.6179, 216.579, 172.9599, 157.463, 152.8898]*240*12;
VOC = [837.7418, 870.7666, 913.1992, 948.6218, 975.5098, 1042.903, 1048.534, 1036.852, 1053.941, 1047.863, 1000.008]*240*12;

N = 230000000;

% 数据处理
PGDP = GDP/2.3;  
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
x_fit_global = linspace(9.2, 10.2, 200); % YRD X轴范围

% =========================================================================
% [重点修改区域] 手动调整文字位置偏移量 [x偏移, y偏移]
% =========================================================================
manual_offsets = cell(5, 4);
% 初始化默认偏移 (默认为向上 0.20)
for i=1:5, for j=1:4, manual_offsets{i,j} = [0, 0.20]; end; end

% --- 根据 YRD 数据特点预设偏移 ---
% VOC 通常在上方
manual_offsets{5,1} = [0, 0.25];   
manual_offsets{5,2} = [0, 0.25]; 
manual_offsets{5,3} = [0, 0.25]; 
manual_offsets{5,4} = [0, 0.25];

% SO2 通常在下方
manual_offsets{4,1} = [0, -0.25];
manual_offsets{4,2} = [0, -0.25];
manual_offsets{4,3} = [0, -0.25];

% 打印表头到命令行
fprintf('\n================================================================================================================\n');
fprintf('REGION: YRD (Yangtze River Delta)\n');
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
        
        % 绘制拐点和文字 (范围: 9.2 - 10.2)
        if x_inf >= 9.2 && x_inf <= 10.2
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
    xlim([9.2, 10.2]); ylim([0, 3.5]); 
end

sgtitle('YRD EKC Analysis (with P-Values)', 'FontSize', 20, 'FontWeight', 'bold');
fprintf('================================================================================================================\n');