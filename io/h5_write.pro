;===============================================================
; write hdf5 by name
;   filename = '/data/hxu/gap.h5'
;   name: 'ALL_Data/CrIS-FS-SDR_All/ES_GapLW' | 'ALL_Data/CrIS-FS-SDR_All/ES_GapLW.attrvalue'
;   data:
pro h5_write, h5_file, ds_name, ds
  ; create or open hdf5 file
  if file_test(h5_file) then begin
    file_id = h5f_open(h5_file, /write)
  endif else begin
    file_id = h5f_create(h5_file)
  endelse

  ; go to the group space
  group_names = strsplit(ds_name, '/', /extract, /preserve_null, count=n_groups)
  the_hook = file_id & group_ids = lonarr(n_groups)
  for i = 0l, n_groups-2 do begin
    n_items = h5g_get_num_objs(the_hook)
    ; # open the group
    has_group_flag = 0
    for j = 0l, n_items - 1 do begin
      if group_names[i] eq h5g_get_obj_name_by_idx(the_hook, j) then begin ; # has already existed
        ; the group
        the_hook = h5g_open(the_hook, group_names[i])
        has_group_flag = 1
        break
      endif
    endfor
    ; # create new group
    if has_group_flag eq 0 then begin
      the_hook = h5g_create(the_hook, group_names[i])
    endif
    ; # store the group
    group_ids[i] = the_hook
  endfor

  parent_id  = the_hook
  child_name = group_names[n_groups-1]

  child_type_id = h5t_idl_create(ds)
  child_ndim = size(ds, /n_dimensions)
  child_dims = size(ds, /dimensions)
  child_exist_flag = 0

  spliter_pos = strpos(child_name, '.', /reverse_search)
  ; find the spliter
  if (spliter_pos lt 0) then begin ; # write dataset
    if (child_ndim gt 0) then begin
      child_dim_id = h5s_create_simple(child_dims)
    endif else begin
      child_dim_id = h5s_create_scalar()
    endelse
    ;------ check whether the ds has already created -----
    n_items = h5g_get_num_objs(parent_id)
    for j = 0l, n_items - 1 do begin
      if child_name eq h5g_get_obj_name_by_idx(parent_id, j) then child_exist_flag = 1 ; # has already existed
    endfor
    ;------ create the dataset ---------------------------
    if child_exist_flag eq 1 then begin
      child_id = h5d_open(parent_id, child_name)
    endif else begin
      child_id = h5d_create(parent_id, child_name, child_type_id, child_dim_id)
    endelse
    ; close the dataset
    h5d_write, child_id, ds
    ; close ds
    h5d_close, child_id
    h5t_close, child_type_id
    h5s_close, child_dim_id
  endif else begin ; # write attribute
    att_name = strmid(child_name, spliter_pos + 1)
    child_name = strmid(child_name, 0, spliter_pos)
    child_Info = h5g_get_objinfo(parent_id, child_name)
    case child_Info.type of
      'GROUP': begin
        child_id = h5g_open(parent_id, child_name)
        if (child_ndim gt 0) then begin
          child_dim_id = h5s_create_simple(child_dims)
        endif else begin
          child_dim_id = h5s_create_scalar()
        endelse
        att_id = h5a_create(child_id, att_name, child_type_id, child_dim_id)
        h5a_write, att_id, ds
        h5a_close, att_id
        h5g_close, child_id
        h5t_close, child_type_id
        h5s_close, child_dim_id
      end
      'DATASET': begin
        child_id = h5d_open(parent_id, child_name)
        if (child_ndim gt 0) then begin
          child_dim_id = h5s_create_simple(child_dims)
        endif else begin
          child_dim_id = h5s_create_scalar()
        endelse
        att_id = h5a_create(child_id, att_name, child_type_id, child_dim_id)
        h5a_write, att_id, ds
        h5a_close, att_id
        h5d_close, child_id
        h5t_close, child_type_id
        h5s_close, child_dim_id
      end
      'TYPE': begin
        child_id = h5t_open(parent_id, child_name)
        if (child_ndim gt 0) then begin
          child_dim_id = h5s_create_simple(child_dims)
        endif else begin
          child_dim_id = h5s_create_scalar()
        endelse
        att_id = h5a_create(child_id, att_name, child_type_id, child_dim_id)
        h5a_write, att_id, ds
        h5a_close, att_id
        h5t_close, child_id
        h5t_close, child_type_id
        h5s_close, child_dim_id
      end
    endcase
  endelse

  ; close file
  for i = n_groups - 2, 0, -1 do h5g_close, group_ids[i]
  h5f_close, file_id
end
