/*
$.objectoffsetrot 
$.objectoffsetpos 
$.objectoffsetscale 

addmodifier $ (xform ())
	
$.modifiers[#xform].gizmo.rotation = inverse $.objectoffsetrot
$.objectoffsetrot = (quat 0 0 0 1)

$.modifiers[#xform].gizmo.position = $.objectoffsetpos
$.objectoffsetpos = [0,0,0]

resetscale $
$.modifiers[#xform].gizmo.scale = $.objectoffsetscale
$.objectoffsetscale = [1,1,1]

$.objectoffsetrot 
$.objectoffsetpos 
$.objectoffsetscale 

*/
fn resetXformInPlace3 s =
(
	addmodifier s (xform ())
		
	s.modifiers[#xform].gizmo.rotation = inverse s.objectoffsetrot
	s.objectoffsetrot = (quat 0 0 0 1)

	s.modifiers[#xform].gizmo.position = s.objectoffsetpos
	s.objectoffsetpos = [0,0,0]

	resetscale s
	s.modifiers[#xform].gizmo.scale = s.objectoffsetscale
	s.objectoffsetscale = [1,1,1]
)
for s in selection do resetXformInPlace3 s
-- $.scale
-- $.rotation