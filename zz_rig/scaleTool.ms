$.scale
$.scale.controller.value
$.objectoffsetscale

fn printscaleInfo s =
(
	format "name:%, scale: %, value: %, offset: % \n" s.name s.scale s.scale.controller.value s.objectoffsetscale
)
printscaleInfo $


$.scale = [1,1,1]
$.objectoffsetscale = [1,1,1]
$.scale.controller.value = [1,1,1]

ResetScale $
$.objectoffsetscale = [1,1,1]
$.objectoffsetrot = (quat -1 0 0 0)

$.objectoffsetscale = $.scale


addmodifier $ (xform ())

$.modifiers[#xform].gizmo.controller.rotation = $.objectoffsetrot
$.objectoffsetrot = (quat 0 0 0 1)

$.modifiers[#xform].gizmo.controller.position = $.objectoffsetpos 
$.objectoffsetpos = [0,0,0]
	
	
$.scale.controller.value