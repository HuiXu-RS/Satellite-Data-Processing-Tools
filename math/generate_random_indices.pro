;===============================================================
; CREATION HISTORY:
;       Written by:     huixu, Mar.30 2018
; Purpose: generate the random indices
; input:
;      upper_bound: the upper bound of the indices
;      NUM: number of indices
; return:
;      indice array
;===============================================================
function generate_random_indices, upper_bound, NUM
  swap = NUM gt upper_bound/2
  if swap then n = upper_bound-NUM else n = NUM
  inds = LonArr(n, /NOZERO)
  M = n
  while n gt 0 do begin
    inds[M-n] = Long( RandomU(seed, n)*upper_bound )
    inds = inds[Sort(inds)]
    u = Uniq(inds)
    n = M-n_elements(u)
    inds[0] = inds[u]
  endwhile

  if swap then inds = Where(Histogram(inds,MIN=0,MAX=upper_bound-1) EQ 0)
  return, inds
end