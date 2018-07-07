;===============================================================
; CREATION HISTORY:
;       Written by:     huixu, Nov.6 2016
; Purpose: save the grid data as a geo-tiff file 'wgs84'
; input:
;       inDataSet: grid data to be saved
;       gridInfo: geo-information e.g.: ''-180,180,90,-90,0.15,0.15'
;       otPath: output path
;       Float=Float: save as a float datatype or integer datatype
;       Interp=Interp: interp the empty data using nearest method
;       back_data=back_data: data not recognized as a empty data
;       step=step: interp times
; output:
;       save the data as geo-tiff
;===============================================================
pro out_grided_geotiff, inDataSet, gridInfo, otPath, Float=Float, Interp=Interp, back_data=back_data, step=step

  ; check whether need to do the interplation
  if(keyword_set(Interp) ne 0)then begin
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
  endif

  ;gridInfo = strsplit(gridInfo,',',/extract)
  factor1 = 1e6 & factor2=1e-6
  lon_min = ROUND(DOUBLE(gridInfo[0])*factor1 + factor2) * factor2 & lon_min = DOUBLE(gridInfo[0])
  lat_max = ROUND(DOUBLE(gridInfo[2])*factor1 + factor2) * factor2 & lat_max = DOUBLE(gridInfo[2])
  x_resolution = ROUND(DOUBLE(gridInfo[4])*factor1 + factor2) * factor2
  y_resolution = ROUND(DOUBLE(gridInfo[5])*factor1 + factor2) * factor2

  ; save as geo-tiff
  BB=dblarr(1,2)
  BB[0,0]= lon_min & BB[0,1]= lat_max
  ; geo tag
  s_geotag = {$
    MODELPIXELSCALETAG: [x_resolution, y_resolution, 0], $  ;resolution
    MODELTIEPOINTTAG: [ 0, 0, 0, BB[0,0], BB[0,1], 0], $    ;coordinates left above
    GTMODELTYPEGEOKEY: 2, $                                 ;Geographic latitude-longitude System
    GTRASTERTYPEGEOKEY: 1, $                                ;raster type
    GEOGRAPHICTYPEGEOKEY: 4326, $                           ;geodetic datum WGS84
    ;GeogPrimeMeridianGeoKey: BB[0,0], $                     ;prime meridian
    GEOGANGULARUNITSGEOKEY: 9102}                           ;angular unit decimal degree
  ; save
  if(n_elements(Float) eq 0)then begin
    write_tiff, otPath, inDataSet, compression=1, geotiff=s_geotag
  endif else begin
    write_tiff, otPath, inDataSet, compression=1, geotiff=s_geotag, /float
  endelse

end