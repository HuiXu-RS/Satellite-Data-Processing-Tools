;===============================================================
; CREATION HISTORY:
;       Written by:     huixu, Mar.07 2017
; Purpose: check whether the input number is odd or not
;===============================================================
function is_odd, x
  x=round(x)
  if (2*(x/2) eq x) then begin
    return,0
  end else begin
    return,1
  end
end