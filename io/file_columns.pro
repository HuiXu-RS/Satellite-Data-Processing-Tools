;===============================================================
; CREATION HISTORY:
;       Written by:     huixu, Apr.24 2016
; Purpose: extract the columns of the ascii data
; input:
;       filename: name of the file
; output:
;       columns: number of columns
;===============================================================
function file_Columns, filename
  openr, lun, filename, /get_lun
  line = ''
  readf, lun, line
  columns = n_elements(strsplit(line, /RegEx, /Extract))

  point_lun, lun, 0
  free_lun,lun

  return, columns
end