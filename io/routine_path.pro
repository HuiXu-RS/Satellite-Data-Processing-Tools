;===============================================================
; CREATION HISTORY:
;       Written by:     huixu, Jan.05 2017
; Purpose: get the current routine path
; input:
;       level: level of the parent directory (0 is current)
; output:
;       return the routine directory
;===============================================================
function routine_path, level=level
  fileInfo = scope_traceback(/structure)
  n = n_elements(fileInfo)
  curDir = file_dirname(fileInfo[n-2].FileName)
  if n_elements(level) gt 0 then begin
    for i = 0, level-1 do begin
      curDir = file_dirname(curDir)
    endfor
  endif

  return, curDir
end