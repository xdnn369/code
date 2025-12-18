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
names  = {'NO_{x}', 'PM_{10}', 'PM_{2.5}', 'SO_{2}', 'VOC'};
line_colors = lines(5); 
markers = {'o', 's', 'd', '^', 'v'}; 
x_fit_global = linspace(9.0, 10.0, 200);

% =========================================================================
% [重点修改区域] 手动调整文字位置偏移量 [x偏移, y偏移]
% 1=NOx, 2=PM10, 3=PM2.5, 4=SO2, 5=VOC
% =========================================================================
manual_offsets = cell(5, 4);
% 初始化默认偏移 (默认为向上 0.15)
for i=1:5, for j=1:4, manual_offsets{i,j} = [0, 0.15]; end; end

% ---- 请在此处根据实际图像效果修改偏移量 ----
% 例如：manual_offsets{污染物序号, 子图序号} = [x, y];
% y为正向上，为负向下；x为正向右，为负向左

% 图1 (Original)
manual_offsets{1,1} = [0, 0.20];   % NOx
manual_offsets{2,1} = [0, -0.15];  % PM10
manual_offsets{3,1} = [0, -0.15];  % PM2.5
manual_offsets{4,1} = [0, -0.30];   % SO2
manual_offsets{5,1} = [0, 0.30];   % VOC

% 图2 (Drop 2020) - 示例
manual_offsets{1,2} = [0, 0.20]; 
manual_offsets{2,2} = [0, -0.20]; 
manual_offsets{3,2} = [0, -0.20]; 
manual_offsets{4,2} = [0, -0.30]; 
manual_offsets{5,2} = [0, 0.30]; 

manual_offsets{1,3} = [0, 0.20]; 
manual_offsets{2,3} = [0, -0.20]; 
manual_offsets{3,3} = [0, -0.20]; 
manual_offsets{4,3} = [0, -0.30]; 
%manual_offsets{5,3} = [0, 0.30]; 

manual_offsets{1,4} = [0, -0.20]; 
%manual_offsets{2,4} = [0, -0.20]; 
%manual_offsets{3,4} = [0, -0.20]; 
%manual_offsets{4,4} = [0, -0.30]; 
manual_offsets{5,4} = [0, 0.20]; 

% ... 您可以继续为图3和图4设置
% =========================================================================

for s = 1:4
    subplot(2, 2, s); hold on; box on;
    idx_range = scenarios{s, 1};
    plot_title = scenarios{s, 2};
    sub_LPGDP = FULL_LPGDP(idx_range);
    
    for k = 1:5
        full_y = FULL_DATA_Y{k};
        sub_y = full_y(idx_range);
        col = line_colors(k, :);
        
        p = polyfit(sub_LPGDP, sub_y, 2);
        y_fit = polyval(p, x_fit_global);
        
        plot(sub_LPGDP, sub_y, markers{k}, 'Color', col, 'MarkerSize', 5, 'LineWidth', 1, 'HandleVisibility', 'off');
        plot(x_fit_global, y_fit, '-', 'Color', col, 'LineWidth', 1.5, 'DisplayName', names{k});
        
        x_inf = -p(2)/(2*p(1));
        y_inf = polyval(p, x_inf);
        
        % 绘制拐点和文字
        if x_inf >= 9.0 && x_inf <= 10.0 % 放宽一点判定范围以免在边缘的不显示
            plot(x_inf, y_inf, 'o', 'MarkerSize', 6, 'MarkerFaceColor', col, 'MarkerEdgeColor', 'k', 'HandleVisibility', 'off');
            
            % 获取手动偏移
            off = manual_offsets{k, s};
            
            text(x_inf + off(1), y_inf + off(2), sprintf('(%.2f, %.2f)', x_inf, y_inf), ...
                'Color', col, 'FontSize', 9, 'FontWeight', 'bold', ...
                'HorizontalAlignment', 'center');
        end
    end
    
    title(plot_title, 'FontSize', 16, 'FontWeight', 'bold');
    xlabel('LnP(GDP)', 'FontSize', 12); ylabel('LP(Pollutants)', 'FontSize', 12);
    grid on; grid minor;
    
    labels = {'(a)', '(b)', '(c)', '(d)'};
    % 0.02, 0.98 表示相对于图框宽度的2%和高度的98%的位置（左上角）
    text(0.02, 0.98, labels{s}, 'Units', 'normalized', 'FontSize', 18, ...
        'FontWeight', 'bold', 'VerticalAlignment', 'top', 'HorizontalAlignment', 'left');
    
    if s == 1, legend('Show', 'Location', 'southwest', 'FontSize', 8, 'NumColumns', 1); end
    xlim([9.0, 10.0]); ylim([0, 4.5]); 
end

%sgtitle('BTH Region EKC Sensitivity Analysis', 'FontSize', 20, 'FontWeight', 'bold');
sgtitle('BTH', 'FontSize', 20, 'FontWeight', 'bold');