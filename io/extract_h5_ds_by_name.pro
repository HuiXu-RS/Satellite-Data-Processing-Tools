;===============================================================
; CREATION HISTORY:
;       Written by:     huixu, Nov.16 2016
; Purpose: extracts dataset from HDF5
; input:
;       h5_file: path of the hdf5 file
;       ds_name: dataset name need to be read
; output:
;       ds: dataset retrieved from a hdf5 file
;===============================================================
pro extract_h5_ds_by_name, h5_file, ds_name, ds
  h5_id = h5f_open(h5_file)
  tokens = strsplit(ds_name,'/', /extract,/preserve_null, count=ntokens)
  loc = h5_id & groups = lonarr(ntokens)
  for i = 0L, ntokens-2 do begin
    loc = h5g_open(loc,tokens[i])
    groups[i] = loc
  endfor

  ds_id = h5d_open(loc,tokens[ntokens-1])
  ds = h5d_read(ds_id)
  h5d_close,ds_id

  for i = ntokens-2, 0, -1 do begin
    loc = groups[i]
    h5g_close,loc
  endfor

  h5f_close,h5_id
end