clc; clear; close all;

%% 1. 数据准备
GDP = [18069.54, 21049.88, 22848.69, 25275.95, 27313.54, 27942.41, 29827.91, 33300.08, 36705.26, 38725.84, 36296.57];
NOx = [743.2463, 757.7053, 746.3904, 667.8129, 593.197, 587.0988, 547.3233, 559.2439, 554.4211, 541.7061, 521.8091]*96*12;
PM10 = [235.2663, 237.0536, 226.1573, 216.4901, 177.6967, 161.4506, 152.1251, 150.2433, 141.208, 136.3683, 130.033]*96*12;
PM25 = [149.1867, 148.4358, 141.1529, 132.9119, 114.2929, 108.9872, 107.0973, 105.5365, 99.34441, 96.43365, 92.37722]*96*12;
SO2 = [548.7554, 573.3709, 532.574, 428.6082, 325.9286, 295.0782, 262.1447, 220.9398, 189.8696, 158.8403, 142.8311]*96*12;
VOC = [1067.915, 1063.555, 1074.838, 1118.341, 1100.3, 1159.53, 1154.14, 1102.336, 1148.222, 1134.735, 1070.628]*96*12;

N = 86440000;

% 数据处理
PGDP = GDP/0.8644;  
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
x_fit_global = linspace(9.8, 10.8, 200);

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
%manual_offsets{1,1} = [0, 0.20];   % NOx
%manual_offsets{2,1} = [0, -0.15];  % PM10
%manual_offsets{3,1} = [0, -0.15];  % PM2.5
%manual_offsets{4,1} = [0, -0.30];   % SO2
manual_offsets{5,1} = [0, 0.20];   % VOC

% 图2 (Drop 2020) - 示例
%manual_offsets{1,2} = [0, 0.20]; 
%manual_offsets{2,2} = [0, -0.20]; 
%manual_offsets{3,2} = [0, -0.20]; 
%manual_offsets{4,2} = [0, -0.30]; 
manual_offsets{5,2} = [0, 0.20]; 

%manual_offsets{1,3} = [0, 0.20]; 
%manual_offsets{2,3} = [0, -0.20]; 
%manual_offsets{3,3} = [0, -0.20]; 
%manual_offsets{4,3} = [0, -0.30]; 
manual_offsets{5,3} = [0, 0.20]; 

manual_offsets{1,4} = [0, 0.20]; 
manual_offsets{2,4} = [0, -0.15]; 
manual_offsets{3,4} = [0, -0.15]; 
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
        if x_inf >= 9.8 && x_inf <= 10.8 % 放宽一点判定范围以免在边缘的不显示
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
    xlim([9.8, 10.8]); ylim([0, 4]); 
end

sgtitle('PRD', 'FontSize', 20, 'FontWeight', 'bold');