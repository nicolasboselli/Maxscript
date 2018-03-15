-- BONES TUNES

fn bonesTuning os =
(
	undo on
	(
		local maxIni = getMAXIniFile()
		local armadasScriptsIni = (getFilenamePath maxIni) + "armadasScriptsIni.ini"

		local tmpRoot = getINISetting armadasScriptsIni "armadasScripts" "armadasScriptsRoot"
		local root = substituteString tmpRoot "\\" "/"


		local bn_tune_hlps = for i = 1 to os.count collect 
		(
			point name: (uniquename "bn_tune_hlp") rotation: os[i].rotation \
			pos: os[i].pos size:  (units.decodeValue "2cm")  box: false cross: true axistripod: false wirecolor: green
		)

		-- contrainte des bones aux helpers
		-- positions constraints
		for i= 1 to os.count do
		(
			os[i].pos.controller = Position_XYZ ()
			os[i].pos.controller = position_list ()
			os[i].pos.controller.available.controller = Position_Constraint ()
			os[i].controller.pos.controller.Position_Constraint.constraints.appendTarget bn_tune_hlps[i] 100
	-- 		os[i].pos.controller.constraints.appendTarget bn_tune_hlps[i] 100
		)
		
		-- look at constraints
		for i= 1 to os.count-1 do
		(
			os[i].rotation.controller = Euler_XYZ ()
			os[i].rotation.controller = rotation_list ()
			
			os[i].rotation.controller.available.controller = LookAt_Constraint ()
			os[i].rotation.controller.LookAt_Constraint.controller.constraints.appendTarget bn_tune_hlps[i+1] 100
			os[i].rotation.controller.LookAt_Constraint.controller.upnode_world = off
			os[i].rotation.controller.LookAt_Constraint.controller.pickUpNode = bn_tune_hlps[i]
			os[i].rotation.controller.LookAt_Constraint.controller.upnode_ctrl = 1
			os[i].rotation.controller.LookAt_Constraint.controller.viewline_length_abs = off
		)
		
		-- scale constraints
		bn_tune_hlps
	)
)



