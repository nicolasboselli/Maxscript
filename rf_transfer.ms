-- trouver les objects avec rayfire slice
sel = objects as array

rfObj = #()
for o in sel where o.modifiers.count > 0 do
(
	for i = 1 to o.modifiers.count do
	if classof o.modifiers[i] == RayFire_Slice then
	(
		append rfObj o
	)
)
select rfObj

select rfObj[1]
-- bak = $.modifiers[1].slice_plane.transform
-- appliquer slice

s = rfObj[1]
t = rfObj[1]

sm = undefined
t = $
s = $
for i = 1 to s.modifiers.count where classof s.modifiers[i] == RayFire_Slice do
(
	sm = s.modifiers[i]
)
sm

ns = SliceModifier Slice_Type: 2

posKey = numkeys sm.slice_plane.position.controller
for i = 1 to posKey do
(
	appendkey ns.slice_plane.pos.x_position.controller.keys sm.slice_plane.pos.x_position.controller.keys[i]
	appendkey ns.slice_plane.pos.y_position.controller.keys sm.slice_plane.pos.y_position.controller.keys[i]
	appendkey ns.slice_plane.pos.z_position.controller.keys sm.slice_plane.pos.z_position.controller.keys[i]
)

rotKey = numkeys sm.slice_plane.rotation.controller
for i = 1 to rotKey do
(
	appendkey ns.slice_plane.rotation.x_rotation.controller.keys sm.slice_plane.rotation.x_rotation.controller.keys[i]
	appendkey ns.slice_plane.rotation.y_rotation.controller.keys sm.slice_plane.rotation.y_rotation.controller.keys[i]
	appendkey ns.slice_plane.rotation.z_rotation.controller.keys sm.slice_plane.rotation.z_rotation.controller.keys[i]
)
addmodifier t ns

$box004.controller = 
$.modifiers[#slice].slice_plane.controller = $.modifiers[#rayfire_slice].slice_plane.controller
$.modifiers[#rayfire_slice].slice_plane.controller.position

$.modifiers[#slice].slice_plane.controller.position = [0,0,2]


-- desactiver rayfire slice
-- copier clefs d'animation de rayfire 

showproperties $.modifiers[1].slice_plane

$.modifiers[1].slice_plane.transform

-- coller clefs animation sur slice
s = $box003
t = $sphere001
-- trouver le nombre de key sur la source


	-- pour chaque index 
posKey = numkeys s.position.controller
for i = 1 to posKey do
(
	appendkey t.pos.x_position.controller.keys s.pos.x_position.controller.keys[i]
	appendkey t.pos.y_position.controller.keys s.pos.y_position.controller.keys[i]
	appendkey t.pos.z_position.controller.keys s.pos.z_position.controller.keys[i]
)

rotKey = numkeys s.rotation.controller
for i = 1 to rotKey do
(
	appendkey t.rotation.x_rotation.controller.keys s.rotation.x_rotation.controller.keys[i]
	appendkey t.rotation.y_rotation.controller.keys s.rotation.y_rotation.controller.keys[i]
	appendkey t.rotation.z_rotation.controller.keys s.rotation.z_rotation.controller.keys[i]
)



deleteKeys t.transform.controller

		-- retourner le temps
		-- retourner la valeur
		
-- sur la cible
	-- créer la clé au temp donné
	-- assigner la valeur



