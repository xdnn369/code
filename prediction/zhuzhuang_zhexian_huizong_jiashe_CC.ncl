;================================================;
;  CC (Chengdu-Chongqing) Emission Projection based on 2010-2012 Trend
;================================================;
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/contributed.ncl"

begin

; 1. 定义原始数据 (Original Data - CC/CY)
; ------------------------------------------------
annual_GDP_cy = (/6198.21, 7759.45, 8827.20, 9729.38, 10700.52, 11455.71, 12559.82, 14120.12, 16122.73, 17492.38, 18385.77/)
annual_NOx_cy = (/211.7535, 219.8885, 231.2751, 227.3143, 214.7103, 204.0944, 196.3559, 191.6953, 187.6683, 183.0575, 173.3192/)*448/10000
annual_PM10_cy = (/186.5676, 176.6986, 176.3333, 167.4231, 153.1331, 138.094, 122.9401, 114.4706, 104.5831, 99.75909, 92.38957/)*448/10000
annual_PM25_cy = (/137.9454, 130.5915, 129.0357, 120.8866, 112.3823, 103.0199, 94.47189, 88.38704, 81.28024, 77.9324, 72.69312/)*448/10000
annual_SO2_cy = (/423.9638, 433.232, 447.4058, 407.6285, 306.989, 237.0381, 187.0147, 148.1375, 106.9549, 91.94138, 83.13609/)*448/10000
annual_VOC_cy = (/286.9745, 296.0299, 299.3253, 300.2199, 303.8161, 317.2034, 328.2599, 325.2101, 321.8946, 310.0437, 292.5713/)*448/10000
annual_GDP_cy_1 = (/6198.21, 7759.45, 8827.20, 10195.14, 11553.07, 12862.26, 14089.36, 15205.99, 16189.87, 17025.55, 17704.36/)

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

; 对成渝数据应用推算
project_trend(annual_GDP_cy)
project_trend(annual_NOx_cy)
project_trend(annual_PM10_cy)
project_trend(annual_PM25_cy)
project_trend(annual_SO2_cy)
project_trend(annual_VOC_cy)


; 3. 绘图设置 (Plotting)
; ------------------------------------------------
x = fspan(0.1, 10.1, 11)
colors = (/"red", "green", "blue", "purple", "black"/)
labels = (/"NO~B~x~N~", "PM~B~10~N~", "PM~B~2.5~N~", "SO~B~2~N~", "VOC"/)

wks = gsn_open_wks("png", "bysj_zhuzhuang_zhexian_huizong_jiashe_cy") 

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
; 推算2020年GDP约为19000，上限21000足够
res2@trYMaxF = 21000
res2@trYMinF = 6000

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
res1@tiMainString = "CC" ; 标题改为 CC
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
; NOx推算在2020年约为31 (原上限24不够)，SO2约为24。
; 将上限调至35以防止爆表。
res1@trYMaxF = 35
res1@trYMinF = 0

res1@tmYLLabelFontHeightF = 0.03
res1@gsnXYBarChart = True
res1@gsnXYBarChartBarWidth = 0.2
res1@trXMinF = 0.0
res1@trXMaxF = 11.0

; 4. 绘图循环
; ------------------------------------------------
res1@gsnXYBarChartColors = colors(0)
plot1 = gsn_csm_x2y2(wks, x, x+0.4, annual_NOx_cy, annual_GDP_cy_1, res1, res2)

res1@gsnXYBarChartColors = colors(1)
plot2 = gsn_csm_x2y2(wks, x+0.2, x+0.4, annual_PM10_cy, annual_GDP_cy_1, res1, res2)

res1@gsnXYBarChartColors = colors(2)
plot3 = gsn_csm_x2y2(wks, x+0.4, x+0.4, annual_PM25_cy, annual_GDP_cy_1, res1, res2)

res1@gsnXYBarChartColors = colors(3)
plot4 = gsn_csm_x2y2(wks, x+0.6, x+0.4, annual_SO2_cy, annual_GDP_cy_1, res1, res2)

res1@gsnXYBarChartColors = colors(4)
plot5 = gsn_csm_x2y2(wks, x+0.8, x+0.4, annual_VOC_cy, annual_GDP_cy_1, res1, res2)


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

; === 在左上角加 “(e)” ===  
txres               = True  
txres@txFontHeightF = 0.022          
txres@txJust        = "TopLeft"      
gsn_text_ndc(wks,"(e)", 0.14, 0.72, txres)

frame(wks)

end