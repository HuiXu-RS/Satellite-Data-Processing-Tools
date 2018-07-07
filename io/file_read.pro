;===============================================================
; CREATION HISTORY:
;       Written by:     huixu, Apr.07 2016
; Purpose: read data from file
; input:
;       filename: name of the output file
;       otdata: output data
; output:
;
;===============================================================
pro file_read, filename, otdata, columns=columns, rows=rows
  ; row
  rows = file_lines(filename)
  ; col
  openr, lun, filename, /get_lun
  line = ''
  readf, lun, line
  columns = n_elements(strsplit(line, /RegEx, /Extract))

  ; create data
  otdata = strarr(columns, rows)

  ; rewind lun
  point_Lun, lun, 0

  ; read data
  line = '' & readf, lun, line
  l=0l
  while ~ eof(lun) do begin
    info = ''
    info = strsplit(line, /RegEx, /Extract)
    otdata[*,l] = info
    readf, lun, line
    l++
  endwhile
  info = ''
  info = strsplit(line, /RegEx, /Extract)
  otdata[*,l] = info

  ; free lun
  free_lun, lun
end