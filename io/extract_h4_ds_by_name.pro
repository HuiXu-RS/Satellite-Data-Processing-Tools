;===============================================================
; CREATION HISTORY:
;       Written by:     huixu, Nov.14 2016
; Purpose: extracts dataset from netCDF
; input:
;       h4_file: path of the h4 file
;       ds_name: dataset name need to be read
; output:
;       ds: dataset retrieved from a netcdf file
;===============================================================
pro extract_h4_ds_by_name, h4_file, ds_name, ds
  h4_id = hdf_sd_start(h4_file,/read)
  h4_idx = hdf_sd_nameToindex(h4_id, ds_name)
  ds_id = hdf_sd_select(h4_id, h4_idx)
  hdf_sd_getdata,ds_id, ds
  hdf_sd_end,h4_id
end