;===============================================================
; CREATION HISTORY:
;       Written by:     huixu, Jan.05 2017
; Purpose: get the sub-directories
; input:
;      inPath: in directory
; output:
;      subDirs: sub-directories found in the root directory
;      nDirs: number of directory
;===============================================================
pro dir_seek, inPath, subDirs, nDirs
  if n_elements(inPath) ne 0 then begin
    sep = PATH_SEP()
    files = file_search(inPath,'*',count = nums, /test_directory)
    if files[0] ne '' then begin
      N = n_elements(STRSPLIT(inPath, sep))

      result = ''
      for i=0,N_ELEMENTS(files)-1 do begin
        N_tmp = n_elements(STRSPLIT(files[i], sep))
        if N_tmp eq N+1 then result = [result, files[i]]
      endfor

      subDirs = result[1:N_ELEMENTS(result)-1]
      nDirs = N_ELEMENTS(result)-1
    endif
  endif
end