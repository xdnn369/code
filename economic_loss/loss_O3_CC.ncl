N = 91000000;

loss_health = (/63.29, 98.54, 126.34, 174.28, 213.73, 209.58/)/0.369*10^8/N
loss_agriculture = (/11455.71, 12559.82, 14120.12, 16122.73, 17492.38, 18385.77/)* 0.0015*10^8/N
loss_power = (/11455.71, 12559.82, 14120.12, 16122.73, 17492.38, 18385.77/)*0.004*10^8/N

x = fspan(0.1, 5.1, 6)
years = (/2015, 2016, 2017, 2018, 2019, 2020/)
labels = (/"Health", "Agriculture", "Fuel"/)
colors = (/"red", "blue", "green"/)

wks = gsn_open_wks("png", "bysj_loss_O3_cy")
res1 = True
res1 = True
res1@gsnFrame = False
res1@tmXTOn = False 
res1@tmYROn = False  
res1@vpWidthF = 1   ; 设置图形宽度
res1@vpHeightF = 0.618  ; 设置图形高度
res1@gsnMaximize = True
res1@tmXBMode = "Explicit"
res1@tmXBValues = ispan(1, 6, 1)-0.5
res1@tmXBLabels = (/"2015", "2016", "2017", "2018", "2019", "2020"/)
;res1@tmXBLabelAngleF = 40
res1@tmXBLabelFontHeightF = 0.03
res1@tmXBMajorLengthF = 0.018
res1@tmXBLabelDeltaF = 0.2
res1@tiMainString = " CC "
res1@tiMainOffsetYF = 0.005
res1@tiMainFontHeightF = 0.05
;res1@tiXAxisString = "Each year from 2015 to 2020"
res1@tiXAxisSide = "Bottom"
res1@tiXAxisFontHeightF = 0.018
res1@tiXAxisOffsetYF = -0.02
res1@tiYAxisString = "Economic losses (yuan/person)"
res1@tiYAxisSide = "Left"
res1@tiYAxisAngleF = 90
res1@tiYAxisFontHeightF = 0.03
res1@tiYAxisOffsetXF = -0.02
res1@trYMaxF = 800
res1@trYMinF = 0
res1@tmYLLabelFontHeightF = 0.03
res1@gsnXYBarChart = True
res1@gsnXYBarChartBarWidth = 0.2
res1@trXMinF = 0.0
res1@trXMaxF = 6.0
res1@gsnXYBarChartColors = colors(0)
;plot1 = gsn_csm_xy(wks, x, annual_NOx_cjzy, res1)
plot1 = gsn_csm_xy(wks, x+0.2, loss_health, res1)
res1@gsnXYBarChartColors = colors(1)
;plot2 = gsn_csm_xy(wks, x+0.2, annual_PM10_cjzy, res1)
plot2 = gsn_csm_xy(wks, x+0.4, loss_agriculture, res1)
res1@gsnXYBarChartColors = colors(2)
plot3 = gsn_csm_xy(wks, x+0.6, loss_power, res1)

lbres = True
lbres@vpWidthF = 0.2
lbres@vpHeightF = 0.15
lbres@lbBoxMajorExtentF = 0.15
lbres@lbMonoFillPattern = True
lbres@lbLabelFontHeightF = 0.03
lbres@lbLabelJust = "CenterLeft"
lbres@lbPerimOn = False

xpos = (/0.2, 0.45, 0.75/)
do i =0, 2
   lbres@lbFillColors = colors(i)
   gsn_labelbar_ndc(wks, 1, labels(i), xpos(i), 0.2, lbres)
end do

; === 在左上角加 “(e)” ===============================  
txres               = True  
txres@txFontHeightF = 0.025          ; 字号；可自行调节  
txres@txJust        = "TopLeft"      ; 以文字左上角为锚点  
gsn_text_ndc(wks,"(e)", 0.19, 0.74, txres)
; === end ============================================

;-------------------------------------------------  
; 1. 统一的文字资源（字号、对齐方式等）  
;-------------------------------------------------  
;txBar               = True  
;txBar@txFontHeightF = 0.015          ; 字号自己调  
;txBar@txJust        = "CenterCenter" ; 文字底边贴在 y 处  
;––– 1. 准备三份文字资源 –––  
;txHealth               = True  
;txHealth@txFontHeightF = 0.015    ; 最大字号  
;txHealth@txJust        = "CenterCenter"  

;txAgr                  = True  
;txAgr@txFontHeightF    = 0.009    ; 中字号  
;txAgr@txJust           = "CenterCenter"  

;txFuel                 = True  
;txFuel@txFontHeightF   = 0.012    ; 最小字号  
;txFuel@txJust          = "CenterCenter"  
;-------------------------------------------------  
; 2. 逐年给三组柱子贴数字  
;-------------------------------------------------  
;do i = 0 , dimsizes(years)-1  

  ;——Health（红色）：x+0.2 ————————————  
  ;str = sprintf("%0.1f", loss_health(i))        ; 转成无小数的字符串  
  ;gsn_text(wks, plot1, str, x(i)+0.2, \
           ;loss_health(i)+12.5, txHealth)           ; y 再往上抬 50  

  ;——Agriculture（蓝色）：x+0.4 ————————  
  ;str = sprintf("%0.1f", loss_agriculture(i))   ; 保留 1 位小数  
  ;gsn_text(wks, plot1, str, x(i)+0.4, \
           ;loss_agriculture(i)+12.5, txAgr)       ; 抬 2 个单位  

  ;——Fuel（绿色）：x+0.6 ——————————————  
  ;str = sprintf("%0.1f", loss_power(i))         ; 同上  
  ;gsn_text(wks, plot1, str, x(i)+0.6, \
           ;loss_power(i)+12.5, txFuel)  

;end do

frame(wks)