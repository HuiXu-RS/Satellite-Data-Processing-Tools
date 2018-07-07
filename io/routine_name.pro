
;===============================================================
; CREATION HISTORY:
;       Written by:     huixu, Jan.05 2017
; Purpose: get the current routine name
;===============================================================
function routine_name

  fileInfo = scope_traceback(/structure)
  n = n_elements(fileInfo)
  ; call info
  fileName = fileInfo[n-2].FileName

  index = strpos(fileName, PATH_SEP(), /reverse_search)
  ; procedure name
  procedureName = strmid(fileName,index + 1,strlen(fileName)-index)

  return,procedureName
end