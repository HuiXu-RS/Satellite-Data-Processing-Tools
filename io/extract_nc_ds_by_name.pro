;===============================================================
; CREATION HISTORY:
;       Written by:     huixu, Nov.14 2016
; Purpose: extracts dataset from netCDF
; input:
;       nc_file: path of the netcdf file
;       ds_name: dataset name need to be read
; output:
;       ds: dataset retrieved from a netcdf file
;===============================================================
pro extract_nc_ds_by_name, nc_file, ds_name, ds
  ; open nc file
  nc_id = ncdf_open(nc_file,/nowrite)
  ; find ds id by name
  ds_id = ncdf_varid(nc_id,ds_name)
  ; extract ds data
  ncdf_varget,nc_id, ds_id, ds
  ; close
  ncdf_close,nc_id
end