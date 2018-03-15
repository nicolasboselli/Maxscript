-- BONES TUNES
undo on
(
	local os = selection as array

	local maxIni = getMAXIniFile()
	local armadasScriptsIni = (getFilenamePath maxIni) + "armadasScriptsIni.ini"

	local tmpRoot = getINISetting armadasScriptsIni "armadasScripts" "armadasScriptsRoot"
	local root = substituteString tmpRoot "\\" "/"


-- 	filein "G:\Program Files\Autodesk\3ds Max 2012\Scripts\zz_rig\bakBones.ms"
-- 	BakBonesFN os

	-- creation des spy rot
	-- wire_temp = color (random 0 255) (random 0 255) (random 0 255)
	/*
	bn_spy_rot = for i = 1 to os.count collect
	(
		point name: (uniquename "bn_spy_rot") rotation:os[i].rotation \
		pos:os[i].position  size:  (units.decodeValue "1cm")  box: false cross: false  axistripod: true wirecolor: orange
	)
	for i = 1 to bn_spy_rot.count do bn_spy_rot[i].parent = os[i]
	*/
	-- creation des hlpers de bones 

	bn_tune_hlps = for i = 1 to os.count collect 
	(
		point name: (uniquename "bn_tune_hlp") rotation: os[i].rotation \
		pos: os[i].pos size:  (units.decodeValue "2cm")  box: false cross: true axistripod: false wirecolor: green
	)

	-- contrainte des bones aux helpers
	-- positions constraints
	for i= 1 to os.count do
	(
		os[i].pos.controller = position_list ()
		os[i].pos.controller.available.controller = Position_Constraint ()
		os[i].controller.pos.controller.Position_Constraint.constraints.appendTarget bn_tune_hlps[i] 100
-- 		os[i].pos.controller.constraints.appendTarget bn_tune_hlps[i] 100
	)
	
	-- look at constraints
	for i= 1 to os.count-1 do
	(
		os[i].rotation.controller = rotation_list ()
		os[i].rotation.controller.available.controller = LookAt_Constraint ()
		os[i].rotation.controller.LookAt_Constraint.controller.constraints.appendTarget bn_tune_hlps[i+1] 100
		os[i].rotation.controller.LookAt_Constraint.controller.upnode_world = off
		os[i].rotation.controller.LookAt_Constraint.controller.pickUpNode = bn_tune_hlps[i]
		os[i].rotation.controller.LookAt_Constraint.controller.upnode_ctrl = 1
		os[i].rotation.controller.LookAt_Constraint.controller.viewline_length_abs = off
	)
	
	-- scale constraints
)

-- $.controller.pos.controller = position_list ()
-- $.controller.pos.controller.available.controller = Position_Constraint ()
-- show $.controller.pos.controller.Position_Constraint.constraints
-- ctrl = $.controller.pos.controller

-- ctrl.available =  Position_Constraint ()

