-- distance selection[1] selection[2]

-- update size value
pt1 = $.scale.controller.getnode "pt1"
pt2 = $.scale.controller.getnode "pt2"

size = distance pt1 pt2

$.scale.controller.SetConstant  "size" size

redrawViews()
animationRange = interval 10 50 
for s in selection do s.rotation.controller.LookAt_Constraint.controller.viewline_length_abs = off