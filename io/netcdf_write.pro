;===============================================================
; CREATION HISTORY:
;       Written by:     huixu, June.1 2016
; Purpose: write netcdf
; input:
;       filename: name of the file
;       indata: input dataset
;       name: dataset name
;       type: data type
;       dimname: dimension name in netcdf file
;       att: attributes of the dataset
; output:
;       netcdf file
;===============================================================
function netcdf_write, filename, indata, name, _extra=type, dimname=dimname, att=att
  ; default dimension name
  default_dimname = ['x','y','z','t','m','n','o','p']
  max_dim = n_elements(default_dimname)

  ; get data dimension
  dataDim = size(indata, /dimensions)
  ndim = n_elements(dataDim)

  if ndim gt max_dim then begin
    print,'The number of input data dimension is higher than 8, stop...'
    return, -1
  endif

  ; create a netcdf
  if not file_test(filename) then begin
    file_id = ncdf_create(filename)
    ncdf_close, file_id
  endif

  ; open netcdf and start write
  file_id = ncdf_open(filename, /write)
  ncdf_control, file_id, /REDEF

  ; get the dimension id
  if n_elements(dimName) gt 0 then begin
    ndiminfo = n_elements(dimName)
    if ndiminfo lt ndim then begin
      i1 = ndiminfo
      i2 = ndim
      dimName = [dimname, default_dimname[i1:i2-1]]
    endif else begin
      dimName = dimName[0:ndim-1]
    endelse
  endif else dimName = default_dimname[0:ndim-1]

  dimArray=[]
  for i = 0, ndim -1 do begin
    dimid = ncdf_dimid(file_id, dimName[i])
    if dimid eq -1 then begin
      dimid = ncdf_dimdef(file_id, dimName[i], dataDim[i])
    endif
    dimArray = [dimArray, dimid]
  endfor

  ; create dataset
  dsid = ncdf_vardef(file_id, name, dimArray, _strict_extra=ex)
  if dsid ne -1 then begin
    ;write attibute
    if n_elements(att) then begin
      n_att = n_elements(att)
      for i = 0l, n_att-1 do begin
        theAtt = strsplit(att[i],/EXTRACT,':')
        if n_elements(theAtt) ne 2 then continue
        key = theAtt[0]
        val = theAtt[1]
        ncdf_attput, file_id, dsid, key, val
      endfor
    endif
    ; write data
    ncdf_control, file_id, /endef
    ncdf_varput, file_id, dsid, indata
    ; close the file
    ncdf_close, file_id
  endif else begin
    print, 'dataset creation failed...'
    ; close the file
    ncdf_close, file_id
    return, -1
  endelse

  return, 0
end
