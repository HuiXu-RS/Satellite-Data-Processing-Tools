;===============================================================
; CREATION HISTORY:
;       Written by:     huixu, Jan.02 2018
; Purpose: create array with dimension and type
; input:
;      demension: vector
;      type: type
;      value: default value
;===============================================================
function create_array, demension, type, value=value
  switch STRUPCASE(type) of
    ; surface
    'BOOLEAN':begin
      array = make_array(demension, /BOOLEAN, value = value)
      break
    end
    'BYTE':begin
      array = make_array(demension, /BYTE, value = value)
      break
    end
    'COMPLEX':begin
      array = make_array(demension, /COMPLEX, value = value)
      break
    end
    'DCOMPLEX':begin
      array = make_array(demension, /DCOMPLEX, value = value)
      break
    end
    'DOUBLE':begin
      array = make_array(demension, /DOUBLE, value = value)
      break
    end
    'FLOAT':begin
      array = make_array(demension, /FLOAT, value = value)
      break
    end
    'INTEGER':begin
      array = make_array(demension, /INTEGER, value = value)
      break
    end
    'L64':begin
      array = make_array(demension, /L64, value = value)
      break
    end
    'LONG':begin
      array = make_array(demension, /LONG, value = value)
      break
    end
    'OBJ':begin
      array = make_array(demension, /OBJ, value = value)
      break
    end
    'PTR':begin
      array = make_array(demension, /PTR, value = value)
      break
    end
    'STRING':begin
      array = make_array(demension, /STRING, value = value)
      break
    end
    'UINT':begin
      array = make_array(demension, /UINT, value = value)
      break
    end
    'UL64':begin
      array = make_array(demension, /UL64, value = value)
      break
    end
    'ULONG':begin
      array = make_array(demension, /ULONG, value = value)
      break
    end
    else: begin
      print, 'You entered: ', type
      print, 'type is not found ...'
    end
  endswitch

  return, array
end