viewport.setType #view_iso_user
bak = viewport.getTM()
viewport.setType #view_persp_user
fov = viewport.GetFOV() 
viewport.setType #view_iso_user

viewport.setTM bak
viewport.setType #view_persp_user
viewport.setFOV fov
viewport.setType #view_iso_user

viewport.getFocalDistance()
viewport.pan()

viewport.ZoomToBounds false [0,500,0] [500,-500,0]
viewport.ZoomToBounds false [0,10,0] [5000,5000,0]

viewport.isCanvasNavigationMode()
viewport.setTM bak
viewport.setFOV fov

getViewSize() 

pos1 = gw.getPointOnCP [0,0]
pos2 = gw.getPointOnCP (getViewSize())

worldPos1 = gw.mapCPToWorld pos1
worldPos2 = gw.mapCPToWorld pos2
	
-- p1 = point pos: worldPos1 size:400
-- p2 = point pos: worldPos2 size:400	
-- select #(p1,p2)

viewport.ZoomToBounds true worldPos1 worldPos2

mapScreenToWorldRay [0,0]
	
viewport.getType()
viewport.setType #view_iso_user
viewport.setType #view_persp_user

#view_persp_user	
getScreenScaleFactor ()
viewport.GetScreenScaleFactor() 