;===============================================================
; CREATION HISTORY:
;       Written by:     huixu, Apr.07 2016
; Purpose: write data to file
; input:
;       filename: name of the output file
;       indata: input data
; output:
;
;===============================================================
pro file_write, filename, indata, width_space = width_space
  if n_elements(width_space) eq 0 then width_space = 10
  ; reform input data to two dimension data array
  dims = size(indata,/dimensions)
  n_dimension = n_elements(dims)
  reform_flag = 0
  if n_dimension gt 2 then begin
    k=1l
    for i = 0, n_dimension-2 do begin
      k*=dims[i]
    endfor
    indata = reform(indata, k, dims[n_dimension-1])
    reform_flag = 1
  endif
  sif = size(indata)
  cols = sif[1] & rows = sif[2]
  ; write
  openw,   lun, filename, width=cols*15, /get_lun
  printf,  lun, strtrim(string(indata),2)
  free_lun,lun
  ; back reform
  if reform_flag eq 1 then begin
    indata = reform(indata, dims)
  endif
end