;================================================;
;  PRD (YGA) Emission Projection based on 2010-2012 Trend
;================================================;
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/contributed.ncl"

begin

; 1. 定义原始数据 (Original Data - YGA/PRD)
; ------------------------------------------------
annual_GDP_yga = (/18069.54, 21049.88, 22848.69, 25275.95, 27313.54, 27942.41, 29827.91, 33300.08, 36705.26, 38725.84, 36296.57/)
annual_NOx_yga = (/743.2463, 757.7053, 746.3904, 667.8129, 593.197, 587.0988, 547.3233, 559.2439, 554.4211, 541.7061, 521.8091/)*96/10000
annual_PM10_yga = (/235.2663, 237.0536, 226.1573, 216.4901, 177.6967, 161.4506, 152.1251, 150.2433, 141.208, 136.3683, 130.033/)*96/10000
annual_PM25_yga = (/149.1867, 148.4358, 141.1529, 132.9119, 114.2929, 108.9872, 107.0973, 105.5365, 99.34441, 96.43365, 92.37722/)*96/10000
annual_SO2_yga = (/548.7554, 573.3709, 532.574, 428.6082, 325.9286, 295.0782, 262.1447, 220.9398, 189.8696, 158.8403, 142.8311/)*96/10000
annual_VOC_yga = (/1067.915, 1063.555, 1074.838, 1118.341, 1100.3, 1159.53, 1154.14, 1102.336, 1148.222, 1134.735, 1070.628/)*96/10000
annual_GDP_yga_1 = (/18069.54, 21049.88, 22848.69, 25469.67, 27397.45, 29167.68, 30723.46, 32010.01, 32978.13, 33586.89, 33806.86/)

; 2. 数据推算处理 (Data Projection Calculation)
; ------------------------------------------------
undef("project_trend")
procedure project_trend(data_arr:numeric)
local diff, i
begin
  ; 计算2010-2012的平均增量
  diff = (data_arr(2) - data_arr(0)) / 2.0
  
  ; 从2013年(索引3)开始到2020年(索引10)，应用这个增量
  do i = 3, 10
      data_arr(i) = data_arr(i-1) + diff
      ; 防止出现负数 
      if(data_arr(i) .lt. 0) then 
         data_arr(i) = 0 
      end if
  end do
end

; 对粤港澳数据应用推算
project_trend(annual_GDP_yga)
project_trend(annual_NOx_yga)
project_trend(annual_PM10_yga)
project_trend(annual_PM25_yga)
project_trend(annual_SO2_yga)
project_trend(annual_VOC_yga)


; 3. 绘图设置 (Plotting)
; ------------------------------------------------
x = fspan(0.1, 10.1, 11)
colors = (/"red", "green", "blue", "purple", "black"/)
labels = (/"NO~B~x~N~", "PM~B~10~N~", "PM~B~2.5~N~", "SO~B~2~N~", "VOC"/)

wks = gsn_open_wks("png", "bysj_zhuzhuang_zhexian_huizong_jiashe_yga") 

; --- 设置右侧Y轴 (GDP) 资源 ---
res2 = True
res2@tmYRLabelsOn = True
res2@tmYUseLeft = False
res2@tiXAxisSide = "Top"
res2@tiXAxisFontHeightF = 0.018
res2@tiXAxisOffsetYF = 0.02
res2@tiYAxisString = "GDP (YiYuan)"
res2@tiYAxisAngleF = 270
res2@tiYAxisFontHeightF = 0.03
res2@tiYAxisOffsetXF = 0.02
res2@tmXTMode = "Explicit" 
res2@tmXTValues = ispan(1, 11, 1)-0.5
res2@tmXTLabelFontHeightF = 0.02
res2@tmXTMajorLengthF = 0.018
res2@tmXTLabelDeltaF = 0.2
res2@trXMinF = 0.0
res2@trXMaxF = 11.0

; [重点调整]
; 按2010-2012增速，2020年GDP约为 41900 左右。
; 原值 40000 会导致折线溢出，改为 44000。
res2@trYMaxF = 40000
res2@trYMinF = 17000

res2@tmYRLabelFontHeightF = 0.03
res2@xyMarkLineModes = (/"Lines"/)
res2@xyDashPatterns = (/0/)
res2@xyLineColors = (/"red"/)
res2@xyLineThicknesses = (/8/)


; --- 设置左侧Y轴 (Emissions) 资源 ---
res1 = True
res1@gsnFrame = False
res1@vpWidthF = 1   
res1@vpHeightF = 0.618  
res1@gsnMaximize = True
res1@tmXBMode = "Explicit"
res1@tmXBValues = ispan(1, 11, 1)-0.5
res1@tmXBLabels = (/"2010", "2011", "2012", "2013", "2014", "2015", "2016", "2017", "2018", "2019", "2020"/)
res1@tmXBLabelFontHeightF = 0.023 
res1@tmXBMajorLengthF = 0.018
res1@tmXBLabelDeltaF = 0.2
res1@tiMainString = "PRD" ; 标题改为 PRD
res1@tiMainOffsetYF = -0.05
res1@tiMainFontHeightF = 0.05
res1@tiXAxisSide = "Bottom"
res1@tiXAxisFontHeightF = 0.018
res1@tiXAxisOffsetYF = -0.02
res1@tiYAxisString = "Emissions [ten thousand tons/year (NOx PM10 PM2.5 SO2) ~C~                             10~S~6~N~mol/year (VOC)]"
res1@tiYAxisSide = "Left"
res1@tiYAxisAngleF = 90
res1@tiYAxisFontHeightF = 0.02
res1@tiYAxisOffsetXF = -0.02

; [保持原状] 
; 粤港澳的排放基数较小，且部分呈下降趋势，15足够容纳
res1@trYMaxF = 15
res1@trYMinF = 0

res1@tmYLLabelFontHeightF = 0.03
res1@gsnXYBarChart = True
res1@gsnXYBarChartBarWidth = 0.2
res1@trXMinF = 0.0
res1@trXMaxF = 11.0

; 4. 绘图循环
; ------------------------------------------------
res1@gsnXYBarChartColors = colors(0)
plot1 = gsn_csm_x2y2(wks, x, x+0.4, annual_NOx_yga, annual_GDP_yga_1, res1, res2)

res1@gsnXYBarChartColors = colors(1)
plot2 = gsn_csm_x2y2(wks, x+0.2, x+0.4, annual_PM10_yga, annual_GDP_yga_1, res1, res2)

res1@gsnXYBarChartColors = colors(2)
plot3 = gsn_csm_x2y2(wks, x+0.4, x+0.4, annual_PM25_yga, annual_GDP_yga_1, res1, res2)

res1@gsnXYBarChartColors = colors(3)
plot4 = gsn_csm_x2y2(wks, x+0.6, x+0.4, annual_SO2_yga, annual_GDP_yga_1, res1, res2)

res1@gsnXYBarChartColors = colors(4)
plot5 = gsn_csm_x2y2(wks, x+0.8, x+0.4, annual_VOC_yga, annual_GDP_yga_1, res1, res2)


; 5. 图例和标注
; ------------------------------------------------
lbres = True
lbres@vpWidthF = 0.2
lbres@vpHeightF = 0.15
lbres@lbBoxMajorExtentF = 0.15
lbres@lbMonoFillPattern = True
lbres@lbLabelFontHeightF = 0.02
lbres@lbLabelJust = "CenterLeft"
lbres@lbPerimOn = False

xpos = (/0.10, 0.25, 0.4, 0.55, 0.7/)
do i =0, 4
   lbres@lbFillColors = colors(i)
   gsn_labelbar_ndc(wks, 1, labels(i), xpos(i), 0.28, lbres)
end do

; === 在左上角加 “(c)” ===  
txres               = True  
txres@txFontHeightF = 0.022          
txres@txJust        = "TopLeft"      
gsn_text_ndc(wks,"(c)", 0.14, 0.72, txres)

frame(wks)

end