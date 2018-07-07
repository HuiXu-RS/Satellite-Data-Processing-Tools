;===============================================================
; CREATION HISTORY:
;       Written by:     huixu, Feb.10 2017
; Purpose: print the progress
; input:
;       start: start value
;       value: current value
;       totalValue: total value
;       interval: print one line per interval
; example:
;         start = -1 & for i = 0, 99 do begin
;           progress, start, i+1, 100, 10
;         endfor
;===============================================================
pro progress, start, value, totalValue, interval
  ; current progress
  progress_value = fix(value * 1.0 / totalValue * 100)
  x = progress_value / interval
  if x gt start then begin
    start = x
    print, interval*start, format='((x, I0),$)'
  endif
  if value eq totalValue then print,''
end