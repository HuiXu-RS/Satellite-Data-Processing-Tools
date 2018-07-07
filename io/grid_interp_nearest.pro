;===============================================================
; CREATION HISTORY:
;       Written by:     huixu, Nov.6 2016
; Purpose: interp the grided data
; input:
;       inDataSet: grid data
;       back_data=back_data: data not recognized as a empty data
;       step=step: interp times
; output:
;
;===============================================================
pro grid_interp_nearest, inDataSet, back_data=back_data, step=step
  ; set the back data
  if(n_elements(back_data) eq 0)then begin
    back_data = 0
  endif
  ; set the step
  if(n_elements(step) eq 0)then begin
    step = 1
  endif else begin
    step = round(step)
  endelse

  ; check the NAN value
  nanFlag = finite(inDataSet,/NaN)
  nanIdx = where(nanFlag eq 1 ,nanCount)
  ; set the NAN value as zero
  if nanCount gt 0 then begin
    inDataSet[nanIdx] = back_data
  endif

  ; get the image size
  T = size(inDataSet)
  Height = T[2]
  Width  = T[1]

  ; loop times to fill the gap
  for nstep = 0,step-1 do begin
    ; find the nan from inDataSet[1:Width-2,1:Height-2]
    zeroIdx=where(inDataSet[1:Width-2,1:Height-2] EQ back_data, ZeroCount)
    if ZeroCount gt 0 then begin
      ; get the row and col index of the gap data
      rowIdx = zeroIdx / (Width-2)
      colIdx = zeroIdx mod (Width-2)
      zeroIdx =(rowIdx + 1) * Width + colIdx + 1

      ; get the total value from surrounding 3*3 pixels
      S = inDataSet
      S_zeroIdx = where(S EQ back_data, S_ZeroCount)
      S[S_zeroIdx] = 0.0
      S[zeroIdx] = S[zeroIdx-1]+S[zeroIdx+1]+ $ ; left and right 2 pixels
        S[zeroIdx-Width-1]+S[zeroIdx-Width+1]+S[zeroIdx-Width]+ $; up 3 pixels
        S[zeroIdx+Width-1]+S[zeroIdx+Width+1]+S[zeroIdx+Width]; bottom 3 pixels

      ; calculate how many pixels contributed to above total values
      ; A = where(OutputData[zeroIdx-1] NE back_data,count)
      ; A reprensents index value in the zeroIdx instead index value in the image
      avgCount=intarr(Width,Height)
      ; left and right 2 pixels
      A= where(inDataSet[zeroIdx-1] ne back_data,count)
      if count gt 0 then avgCount[zeroIdx[A]]+=1
      A= where(inDataSet[zeroIdx+1] ne back_data,count)
      if count gt 0 then avgCount[zeroIdx[A]]+=1
      ; up 3 pixels
      A= where(inDataSet[zeroIdx-Width-1] ne back_data,count)
      if count gt 0 then avgCount[zeroIdx[A]]+=1
      A= where(inDataSet[zeroIdx-Width+1] ne back_data,count)
      if count gt 0 then avgCount[zeroIdx[A]]+=1
      A= where(inDataSet[zeroIdx-Width] ne back_data,count)
      if count gt 0 then avgCount[zeroIdx[A]]+=1
      ; bottom 3 pixels
      A= where(inDataSet[zeroIdx+Width-1] ne back_data,count)
      if count gt 0 then avgCount[zeroIdx[A]]+=1
      A= where(inDataSet[zeroIdx+Width+1] ne back_data,count)
      if count gt 0 then avgCount[zeroIdx[A]]+=1
      A= where(inDataSet[zeroIdx+Width] ne back_data,count)
      if count gt 0 then avgCount[zeroIdx[A]]+=1

      ; calculate the average value from surrounding 3*3 pixels
      avgIndex = where(avgCount gt 0,count)
      if count gt 0 then inDataSet[avgIndex] = S[avgIndex] / avgCount[avgIndex]
      ;inDataSet = S
    endif
  endfor
end