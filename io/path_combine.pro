
;===============================================================
; CREATION HISTORY:
;       Written by:     huixu, Jan.05 2017
; Purpose: combine path
;===============================================================
function path_combine, first, second
  tempfirst=first
  tempsecond=second
  last_sep = strpos(tempfirst, path_sep(), /reverse_search)
  if last_sep eq strlen(tempfirst)-1 then tempfirst=strmid(tempfirst, 0, strlen(tempfirst)-1)
  first_sep= strpos(tempsecond, path_sep())
  if first_sep eq 0 then tempsecond=strmid(tempsecond, 1, strlen(tempsecond)-1)
  path = tempfirst + path_sep() + tempsecond
  return, path
end