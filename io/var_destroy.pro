;===============================================================
; CREATION HISTORY:
;       Written by:     huixu, Jan.05 2017
; Purpose: release variables
; input:
;      varname: variable need to be destroyed.
;===============================================================
pro var_destroy, varname
  tempvar = SIZE(TEMPORARY(varname))
end