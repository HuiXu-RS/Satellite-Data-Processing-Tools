;===============================================================
; CREATION HISTORY:
;       Written by:     huixu, June.6 2016
; Purpose: extracts dataset from netCDF
; input:
;       sav_file: path of the sav file
;       ds_name: dataset name need to be read
; output:
;       ds: dataset retrieved from a sav file
;===============================================================
pro extract_sav_ds_by_name, sav_file, ds_name, ds
  restore, sav_file
  tokens = strsplit(ds_name,'/', /extract,/preserve_null, count=ntokens)
  ds =  scope_varfetch(tokens[0], LEVEL=0)
end