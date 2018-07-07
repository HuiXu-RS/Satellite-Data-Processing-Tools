;===============================================================
; CREATION HISTORY:
;       Written by:     huixu, Feb.05 2017
; Purpose: find the closest value of A in array B
; input:
;      A: array A
;      B: array B
; output:
;      idx: the index of closest value in array B
;===============================================================
function find_closest, A, B
  n   = n_elements(A)
  idx = lonarr(n)

  for i = 0, n-1 do begin
    temp = abs(B - A[i])
    min_diff = min(temp, min_idx)
    idx[i] = min_idx
  endfor

  return, idx
end