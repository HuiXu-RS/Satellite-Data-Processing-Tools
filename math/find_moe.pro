;===============================================================
; CREATION HISTORY:
;       Written by:     huixu, Oct.02 2017
; Purpose: find the most occurred element in a array
; input:
;      X: array
; return:
;      max_count: occurrance of the most occurred element
;      max_idx  : the index of the most occurred element
;===============================================================
function find_MOE, X

  uniq_elements = X[uniq(X, sort(X))]
  n_uniq = n_elements(uniq_elements) & uniq_elements_count = lonarr(n_uniq)
  for i = 0, n_uniq-1 do begin
    valid_idx = where(X eq uniq_elements[i], ct)
    uniq_elements_count[i] = ct
  endfor
  max_count = max(uniq_elements_count, max_idx)

  return, uniq_elements[max_idx]
end