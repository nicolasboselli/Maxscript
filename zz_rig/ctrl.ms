-- source = $R_eyeBrow_ctrl001

sel = selection as array
for s in sel do
(
-- 	ctrl = copy source
-- 	ctrl.transform = s.transform
	ctrl = circle transform: s.transform radius: 1
	s.parent = ctrl
)

-- circle transform: $.transform

$.objectOffsetScale = [2,2,2]
$.objectOffsetRot = (eulerangles 0 90 0) as quat 
-- (eulerangles 0 90 0) as quat 

sel = selection as array
for s in sel do s.wirecolor = yellow 

sel = selection as array
for s in sel do s.wirecolor = green

sel = selection as array
for s in sel do s.wirecolor = blue
 	