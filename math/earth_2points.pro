;===============================================================
; CREATION HISTORY:
;       Written by:     huixu, Nov.14 2016
; Purpose: compute the distance between two points on map
;===============================================================
function earth_2points,lon0, lat0, lon1, lat1
  constant_fetch,'!PHYSICAL'
  radius = !PHYSICAL.R0 * 0.001  ; earth radius (km)
  return,radius * acos(sin(lat0*!DTOR)*sin(lat1*!DTOR)+cos(lat0*!DTOR)*cos(lat1*!DTOR)*cos(lon0*!DTOR-lon1*!DTOR))
end