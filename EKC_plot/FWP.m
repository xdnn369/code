clc; clear; close all;

%% 1. 数据准备
GDP = [10513.07, 12680.88, 14093.53, 15200.53, 16347.19, 16996.17, 18063.44, 20465.12, 22458.98, 24118.14, 24527.29];
NOx = [357.8935, 391.343, 389.7938, 368.9487, 338.1034, 309.2535, 288.6632, 271.1577, 266.3369, 257.7487, 241.388]*864*12;
PM10 = [242.536, 246.5165, 244.021, 234.7632, 208.9689, 181.7004, 154.7969, 135.3659, 118.6768, 107.3665, 97.757]*864*12;
PM25 = [169.9483, 173.2775, 171.6466, 163.4249, 148.1305, 131.1356, 114.7791, 100.8388, 89.2038, 81.10292, 73.98151]*864*12;
SO2 = [441.8968, 454.5253, 417.0208, 381.059, 315.1355, 264.9136, 211.5143, 157.8265, 120.1367, 103.9895, 92.36337]*864*12;
VOC = [267.6003, 277.6305, 284.8626, 286.1539, 286.4388, 291.9033, 292.2526, 283.2387, 277.2345, 264.7794, 249.5817]*864*12;

N = 55544500;

% 数据处理
PGDP = GDP/0.555445;  
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
manual_offsets{1,1} = [0, -0.15];   % NOx
manual_offsets{2,1} = [0, -0.15];  % PM10
manual_offsets{3,1} = [0, -0.15];  % PM2.5
%manual_offsets{4,1} = [0, -0.30];   % SO2
manual_offsets{5,1} = [0, -0.15];   % VOC

% 图2 (Drop 2020) - 示例
manual_offsets{1,2} = [0, -0.15]; 
manual_offsets{2,2} = [0, -0.15]; 
manual_offsets{3,2} = [0, -0.15]; 
%manual_offsets{4,2} = [0, -0.30]; 
manual_offsets{5,2} = [0, -0.15]; 

manual_offsets{1,3} = [0, -0.15]; 
manual_offsets{2,3} = [0, -0.15]; 
manual_offsets{3,3} = [0, -0.15]; 
%manual_offsets{4,3} = [0, -0.30]; 
manual_offsets{5,3} = [0, 0.20]; 

manual_offsets{1,4} = [0, -0.15]; 
%manual_offsets{2,4} = [0, -0.20]; 
%manual_offsets{3,4} = [0, -0.20]; 
%manual_offsets{4,4} = [0, -0.30]; 
manual_offsets{5,4} = [0, 0.25]; 

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
    xlim([9.8, 10.8]); ylim([1.5, 5.5]); 
end

sgtitle('FWP', 'FontSize', 20, 'FontWeight', 'bold');