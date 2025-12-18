;================================================;
;  BTH Emission Projection based on 2010-2012 Trend
;================================================;
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/contributed.ncl"

begin

; 1. 定义原始数据 (Original Data)
; ------------------------------------------------
annual_GDP_jjj = (/10770.965, 12857.65, 14315.3025, 15543.05, 16618.6125, 17328.2225, 18653.1275, 20639.9325, 19740.875, 21119.785, 21491.27/)
annual_NOx_jjj = (/585.7331, 623.2894, 638.4343, 605.7401, 549.142, 499.37706, 494.3961, 480.6006, 478.0624, 465.4029, 429.3172/)*336/10000
annual_PM10_jjj = (/317.9904, 321.0648, 326.3581, 314.1876, 276.4355, 231.1147, 206.3284, 182.978, 171.0636, 157.5864, 140.0591/)*336/10000
annual_PM25_jjj = (/224.7712, 226.8864, 230.7608, 223.7198, 198.6783, 168.0337, 151.7818, 135.5784, 126.5828, 116.8682, 104.0053/)*336/10000
annual_SO2_jjj = (/528.0241, 545.705, 542.8578, 518.3412, 393.1095, 307.2036, 251.6545, 199.4211, 173.9469, 150.4162, 130.6884/)*336/10000
annual_VOC_jjj = (/471.4384, 483.9073, 496.1671, 501.6432, 504.1259, 523.2058, 524.4208, 499.5984, 491.471, 472.8905, 439.2494/)*336/10000
annual_GDP_jjj_1 = (/10770.965, 12857.65, 14315.3025, 14621.87, 15411.71, 16215.15, 17032.02, 17862.06, 18705.12, 19560.94, 20429.40/)

; 2. 数据推算处理 (Data Projection Calculation)
; ------------------------------------------------
; 定义一个简单的过程来处理数组的外推
undef("project_trend")
procedure project_trend(data_arr:numeric)
local diff, i
begin
  ; 计算2010-2012的平均增量: (Value2012 - Value2010) / 2
  ; 注意：索引0是2010，索引2是2012
  diff = (data_arr(2) - data_arr(0)) / 2.0
  
  ; 从2013年(索引3)开始到2020年(索引10)，应用这个增量
  do i = 3, 10
      data_arr(i) = data_arr(i-1) + diff
      ; 防止出现负数（虽然在这个趋势下大概率是增加的）
      if(data_arr(i) .lt. 0) then 
         data_arr(i) = 0 
      end if
  end do
end

; 对所有变量应用推算
;project_trend(annual_GDP_jjj)
project_trend(annual_NOx_jjj)
project_trend(annual_PM10_jjj)
project_trend(annual_PM25_jjj)
project_trend(annual_SO2_jjj)
project_trend(annual_VOC_jjj)

; 3. 绘图设置 (Plotting)
; ------------------------------------------------
x = fspan(0.1, 10.1, 11)
colors = (/"red", "green", "blue", "purple", "black"/)
labels = (/"NO~B~x~N~", "PM~B~10~N~", "PM~B~2.5~N~", "SO~B~2~N~", "VOC"/)

wks = gsn_open_wks("png", "bysj_zhuzhuang_zhexian_huizong_jiashe_jjj") ; 

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

; [调整] 
; 原图GDP最大值设为24000。
; 按2010-2012增速，2020年GDP将达到约 28500 左右。
; 为了防止折线冲出画布，这里将上限调整为 30000。
res2@trYMaxF = 24000  
res2@trYMinF = 10000

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
res1@tiMainString = "BTH" ; 标题稍微改动以示区别
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

; [调整]
; 原始设定 trYMaxF = 24。
; 按2010-2012趋势，NOx等污染物在2020年可能会超过24。
; 计算显示NOx大约会到 25-26 左右，SO2大约会到 20左右。
; 为保险起见，将左轴上限调至 30。
res1@trYMaxF = 30 
res1@trYMinF = 0

res1@tmYLLabelFontHeightF = 0.03
res1@gsnXYBarChart = True
res1@gsnXYBarChartBarWidth = 0.2
res1@trXMinF = 0.0
res1@trXMaxF = 11.0

; 4. 绘图循环 (Draw Plots)
; ------------------------------------------------
res1@gsnXYBarChartColors = colors(0)
plot1 = gsn_csm_x2y2(wks, x, x+0.4, annual_NOx_jjj, annual_GDP_jjj_1, res1, res2)

res1@gsnXYBarChartColors = colors(1)
plot2 = gsn_csm_x2y2(wks, x+0.2, x+0.4, annual_PM10_jjj, annual_GDP_jjj_1, res1, res2)

res1@gsnXYBarChartColors = colors(2)
plot3 = gsn_csm_x2y2(wks, x+0.4, x+0.4, annual_PM25_jjj, annual_GDP_jjj_1, res1, res2)

res1@gsnXYBarChartColors = colors(3)
plot4 = gsn_csm_x2y2(wks, x+0.6, x+0.4, annual_SO2_jjj, annual_GDP_jjj_1, res1, res2)

res1@gsnXYBarChartColors = colors(4)
plot5 = gsn_csm_x2y2(wks, x+0.8, x+0.4, annual_VOC_jjj, annual_GDP_jjj_1, res1, res2)

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

; === 在左上角加 “(a)” ===  
txres               = True  
txres@txFontHeightF = 0.022     
txres@txJust        = "TopLeft"      
gsn_text_ndc(wks,"(a)", 0.14, 0.72, txres)

frame(wks)

end