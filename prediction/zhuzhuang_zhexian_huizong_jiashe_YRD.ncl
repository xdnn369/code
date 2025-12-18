;================================================;
;  YRD (CSJ) Emission Projection based on 2010-2012 Trend
;================================================;
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/contributed.ncl"

begin

; 1. 定义原始数据 (Original Data - CSJ)
; ------------------------------------------------
annual_GDP_csj = (/24316.47, 28727.59, 31494.48, 34342.83, 37412.88, 39993.37, 43538.80, 48830.43, 55308.28, 58987.96, 61130.39/)
annual_NOx_csj = (/861.3655, 895.7939, 877.3549, 835.2065, 758.899, 709.5309, 674.3826, 669.517, 652.1056, 638.5813, 602.6002/)*240/10000
annual_PM10_csj = (/351.5295, 336.1206, 331.2637, 311.219, 283.4729, 235.0518, 196.1718, 173.4164, 155.8321, 149.7162, 141.8288/)*240/10000
annual_PM25_csj = (/235.9154, 225.5259, 221.2694, 208.94, 191.9406, 161.2064, 137.462, 122.952, 111.2377, 107.4047, 102.3659/)*240/10000
annual_SO2_csj = (/614.9808, 627.3188, 579.3593, 497.9908, 402.8242, 311.317, 278.6179, 216.579, 172.9599, 157.463, 152.8898/)*240/10000
annual_VOC_csj = (/837.7418, 870.7666, 913.1992, 948.6218, 975.5098, 1042.903, 1048.534, 1036.852, 1053.941, 1047.863, 1000.008/)*240/10000
annual_GDP_csj_1 = (/24316.47, 28727.59, 31494.48, 34769.56, 37579.13, 39705.12, 40974.19, 41270.60, 40556.54, 38882.52, 36385.017/)

; 2. 数据推算处理 (Data Projection Calculation)
; ------------------------------------------------
; 保持逻辑不变：基于2010和2012的斜率进行线性外推
undef("project_trend")
procedure project_trend(data_arr:numeric)
local diff, i
begin
  ; 计算2010-2012的平均增量: (Value2012 - Value2010) / 2
  diff = (data_arr(2) - data_arr(0)) / 2.0
  
  ; 从2013年(索引3)开始到2020年(索引10)，应用这个增量
  do i = 3, 10
      data_arr(i) = data_arr(i-1) + diff
      ; 防止出现负数 (对于PM10和SO2这种下降趋势的变量很有必要)
      if(data_arr(i) .lt. 0) then 
         data_arr(i) = 0 
      end if
  end do
end

; 对长三角数据应用推算
project_trend(annual_GDP_csj)
project_trend(annual_NOx_csj)
project_trend(annual_PM10_csj)
project_trend(annual_PM25_csj)
project_trend(annual_SO2_csj)
project_trend(annual_VOC_csj)


; 3. 绘图设置 (Plotting)
; ------------------------------------------------
x = fspan(0.1, 10.1, 11)
colors = (/"red", "green", "blue", "purple", "black"/)
labels = (/"NO~B~x~N~", "PM~B~10~N~", "PM~B~2.5~N~", "SO~B~2~N~", "VOC"/)

wks = gsn_open_wks("png", "bysj_zhuzhuang_zhexian_huizong_jiashe_csj") ; 文件名改为csj

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

; [重点调整] 长三角GDP基数大，2020年预测值约为60200左右
res2@trYMaxF = 70000  
res2@trYMinF = 20000  ; 起始值也相应调高一点，避免下方留白太多

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
res1@tiMainString = "YRD" ; 标题改为YRD
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

; [重点调整] 
; 长三角VOCs在2010-2012年增长明显，推测到2020年数值接近30
res1@trYMaxF = 32 
res1@trYMinF = 0

res1@tmYLLabelFontHeightF = 0.03
res1@gsnXYBarChart = True
res1@gsnXYBarChartBarWidth = 0.2
res1@trXMinF = 0.0
res1@trXMaxF = 11.0

; 4. 绘图循环 (Draw Plots)
; ------------------------------------------------
res1@gsnXYBarChartColors = colors(0)
plot1 = gsn_csm_x2y2(wks, x, x+0.4, annual_NOx_csj, annual_GDP_csj_1, res1, res2)

res1@gsnXYBarChartColors = colors(1)
plot2 = gsn_csm_x2y2(wks, x+0.2, x+0.4, annual_PM10_csj, annual_GDP_csj_1, res1, res2)

res1@gsnXYBarChartColors = colors(2)
plot3 = gsn_csm_x2y2(wks, x+0.4, x+0.4, annual_PM25_csj, annual_GDP_csj_1, res1, res2)

res1@gsnXYBarChartColors = colors(3)
plot4 = gsn_csm_x2y2(wks, x+0.6, x+0.4, annual_SO2_csj, annual_GDP_csj_1, res1, res2)

res1@gsnXYBarChartColors = colors(4)
plot5 = gsn_csm_x2y2(wks, x+0.8, x+0.4, annual_VOC_csj, annual_GDP_csj_1, res1, res2)

; 5. 图例和标注 (Legend and Labels)
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

; === 左上角编号 ===  
; 如果这是第二张图，您可能想把 "(a)" 改成 "(b)"
txres               = True  
txres@txFontHeightF = 0.022     
txres@txJust        = "TopLeft"      
gsn_text_ndc(wks,"(b)", 0.14, 0.72, txres)

frame(wks)

end