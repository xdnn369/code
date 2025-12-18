;================================================;
;  FWP (Fenwei Plain) Emission Projection based on 2010-2012 Trend
;================================================;
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/contributed.ncl"

begin

; 1. 定义原始数据 (Original Data - FWP)
; ------------------------------------------------
annual_GDP_fw = (/10513.07, 12680.88, 14093.53, 15200.53, 16347.19, 16996.17, 18063.44, 20465.12, 22458.98, 24118.14, 24527.29/)
annual_NOx_fw = (/357.8935, 391.343, 389.7938, 368.9487, 338.1034, 309.2535, 288.6632, 271.1577, 266.3369, 257.7487, 241.388/)*864/10000
annual_PM10_fw = (/242.536, 246.5165, 244.021, 234.7632, 208.9689, 181.7004, 154.7969, 135.3659, 118.6768, 107.3665, 97.757/)*864/10000
annual_PM25_fw = (/169.9483, 173.2775, 171.6466, 163.4249, 148.1305, 131.1356, 114.7791, 100.8388, 89.2038, 81.10292, 73.98151/)*864/10000
annual_SO2_fw = (/441.8968, 454.5253, 417.0208, 381.059, 315.1355, 264.9136, 211.5143, 157.8265, 120.1367, 103.9895, 92.36337/)*864/10000
annual_VOC_fw = (/267.6003, 277.6305, 284.8626, 286.1539, 286.4388, 291.9033, 292.2526, 283.2387, 277.2345, 264.7794, 249.5817/)*864/10000
annual_GDP_fw_1 = (/10513.07, 12680.88, 14093.53, 15262.01, 16930.87, 18701.39, 20573.80, 22547.52, 24622.01, 26795.83, 29067.61/)

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

; 对汾渭平原数据应用推算
project_trend(annual_GDP_fw)
project_trend(annual_NOx_fw)
project_trend(annual_PM10_fw)
project_trend(annual_PM25_fw)
project_trend(annual_SO2_fw)
project_trend(annual_VOC_fw)


; 3. 绘图设置 (Plotting)
; ------------------------------------------------
x = fspan(0.1, 10.1, 11)
colors = (/"red", "green", "blue", "purple", "black"/)
labels = (/"NO~B~x~N~", "PM~B~10~N~", "PM~B~2.5~N~", "SO~B~2~N~", "VOC"/)

wks = gsn_open_wks("png", "bysj_zhuzhuang_zhexian_huizong_jiashe_fw") 

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

; [保持原状]
; 按照2010-2012趋势，2020年GDP约为 28400，30000的上限是合适的
res2@trYMaxF = 30000
res2@trYMinF = 9000

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
res1@tiMainString = "FWP" ; 标题改为 FWP
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
; 推测NOx在2020年约为45，上限50刚刚好
res1@trYMaxF = 50
res1@trYMinF = 0

res1@tmYLLabelFontHeightF = 0.03
res1@gsnXYBarChart = True
res1@gsnXYBarChartBarWidth = 0.2
res1@trXMinF = 0.0
res1@trXMaxF = 11.0

; 4. 绘图循环
; ------------------------------------------------
res1@gsnXYBarChartColors = colors(0)
plot1 = gsn_csm_x2y2(wks, x, x+0.4, annual_NOx_fw, annual_GDP_fw_1, res1, res2)

res1@gsnXYBarChartColors = colors(1)
plot2 = gsn_csm_x2y2(wks, x+0.2, x+0.4, annual_PM10_fw, annual_GDP_fw_1, res1, res2)

res1@gsnXYBarChartColors = colors(2)
plot3 = gsn_csm_x2y2(wks, x+0.4, x+0.4, annual_PM25_fw, annual_GDP_fw_1, res1, res2)

res1@gsnXYBarChartColors = colors(3)
plot4 = gsn_csm_x2y2(wks, x+0.6, x+0.4, annual_SO2_fw, annual_GDP_fw_1, res1, res2)

res1@gsnXYBarChartColors = colors(4)
plot5 = gsn_csm_x2y2(wks, x+0.8, x+0.4, annual_VOC_fw, annual_GDP_fw_1, res1, res2)


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

; === 在左上角加 “(d)” ===  
txres               = True  
txres@txFontHeightF = 0.022          
txres@txJust        = "TopLeft"      
gsn_text_ndc(wks,"(d)", 0.14, 0.72, txres)

frame(wks)

end