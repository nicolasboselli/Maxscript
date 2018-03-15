-- box spline
-- dupliquer la spline
-- collecter les boxes
-- créer un hlp par box 
	-- parenter chaque box a son helper
	-- contraindre chaque helper au path
	-- créer un helper comme upnode
	-- ajouter look at  
	
-- contraindre les helpers au path
sel = selection as array
l = sel[sel.count]

part = 100.0/(sel.count-1)
for i = 1 to (sel.count - 1) do
(
	sel[i].controller 
)

pl =  position_list ()
pl[1].controller = path_constraint ()

pl[1].controller.path = $tentacle_spline


$.position.controller = position_xyz ()
$.position.controller  = pl

$.position.controller[2].controller.value = [0,0,0]

-- contraindre les upnode à la spline copy
-- ajouter un look at aux boxes

--
