;===============================================================
; CREATION HISTORY:
;      Written by:   huixu, Jan.05 2017
; Purpose: get the sub-files
; input:
;      inPath : in directory
;      fileExt: file extension
; output:
;      subFiles: sub-files found in the root directory
;      nFiles: number of files
;===============================================================
pro file_seek, inPath, fileExt, subFiles, nFiles

  if N_ELEMENTS(InPath) ne 0 then begin
    sep = PATH_SEP()
    files = FILE_SEARCH(InPath, fileExt)
    if files[0] ne '' then begin
      N = n_elements(STRSPLIT(InPath, sep))
      result = ''
      for i=0,N_ELEMENTS(files)-1 do begin
        N_tmp = n_elements(STRSPLIT(files[i], sep))
        if N_tmp eq N+1 then result = [result, files[i]]
      endfor
      ;
      subFiles = result[1:N_ELEMENTS(result)-1]
      nFiles =  N_ELEMENTS(result)-1
    endif
  endif
end