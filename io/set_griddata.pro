;===============================================================
; CREATION HISTORY:
;       Written by:     huixu, Nov.5 2016
; Purpose: project swath data to grid
; input:
;       inDataSet: swath data to be projected
;       latSet: latitude
;       lonSet: longitude
;       gridInfo: geo-information e.g.: ''-180,180,90,-90,0.15,0.15'
;
; output:
;       outputDataSet: output grid dataset
;===============================================================
pro set_griddata,$
  inDataSet,$
  latSet, $
  lonSet, $
  gridInfo,$
  outputDataSet, $
  samePosDataCount=samePosDataCount,$
  back_data=back_data

  d_xL = Float(gridInfo[0])    ;left (minimum lon)
  d_xR = Float(gridInfo[1])    ;right(maximum lon)
  d_yA = Float(gridInfo[2])    ;up (maximum lat)
  d_yB = Float(gridInfo[3])    ;bottom (minimum lat)
  x_resolution = Float(gridInfo[4]) ;res lon .25
  y_resolution = Float(gridInfo[5]) ;res lat .25

  ; get the revised lat and lon
  x_min = ceil(d_xL / x_resolution) * x_resolution ;minimum lon
  x_max = ceil(d_xR / x_resolution) * x_resolution ;maximum lon
  y_min = ceil(d_yB / y_resolution) * y_resolution ;minimum lat
  y_max = ceil(d_yA / y_resolution) * y_resolution ;maximum lat

  ;  if y_min eq -90. then y_min = y_min + y_resolution
  ;  if x_max eq 180. then x_max = x_max - x_resolution

  ; get the start position index
  d_xL_world = -180.0 & d_xR_world = 180.0
  d_yA_world = 90.0 & d_yB_world = -90.0

  x_pix_min = (x_min - d_xL_world) / x_resolution
  x_pix_max = (x_max - d_xL_world) / x_resolution
  y_pix_min = (d_yA_world - y_max) / y_resolution
  y_pix_max = (d_yA_world - y_min) / y_resolution

  ; create empty data
  x_pix_size= x_pix_max - x_pix_min
  y_pix_size= y_pix_max - y_pix_min
  if(n_elements(back_data) eq 0)then begin
    back_data = 0
  endif
  outputDataSet = replicate(back_data, x_pix_size, y_pix_size)

  ; get observations within the extend
  lonSet = ceil(lonSet / x_resolution) * x_resolution
  latSet = ceil(latSet / y_resolution) * y_resolution
  validLonLatSet = where((lonSet LT x_max) AND (lonSet GE x_min),countlonlat)
  if countlonlat gt 0  then begin
    validLonLatSet0 = WHERE((latSet[validLonLatSet]LE y_max) AND (latSet[validLonLatSet] GT y_min),countlonlat)
    if countlonlat gt 0 then begin
      validLonLatSet = validLonLatSet[validLonLatSet0]
    endif
  endif

  ; get the relative index for every pixels
  x_idx = (LonSet-d_xL)/x_resolution
  y_idx = (d_yA-LatSet)/y_resolution

  ; do projection
  samePosDataCount = intarr(x_pix_size, y_pix_size)
  for j = 0l,countlonlat -1 do begin
    id = validLonLatSet[j]
    xid = x_idx[id] & yid = y_idx[id]
    data = inDataSet[id]
    if finite(data) ne 0 then begin
      if outputDataSet[xid , yid] eq back_data then begin
        outputDataSet[xid , yid] = 0.0
      endif
      outputDataSet[xid , yid] += data
      samePosDataCount[xid, yid] += 1
    endif
  endfor

  ; get the averaged dataset
  valid = where(samePosDataCount ne 0,countValid)
  if countValid ne 0 then begin
    outputDataSet[valid] /= samePosDataCount[valid]
  endif
end