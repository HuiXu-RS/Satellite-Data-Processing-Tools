pro extract_nc_at_by_name, nc_file, ds_name, att_name, att
  ; open nc file
  nc_id = ncdf_open(nc_file,/nowrite)
  ; find ds id by name
  ds_id = ncdf_varid(nc_id,ds_name)
  ; extract ds data
  ncdf_attget, nc_id, ds_id, att_name, att
  ; close
  ncdf_close,nc_id
end
