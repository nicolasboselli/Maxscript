-- maj:
-- add uvwMapAutoFit on panel
-- create plane

-- $.material.opacity.controller = bezier_float ()


try(destroyDialog opaRLT)catch()
rollout opaRLT "plan manipulator"
(
-- vars
	local params = #("pos")
	local opaVal = 60
	
	local maxIni = getMAXIniFile()
	local armadasScriptsIni = (getFilenamePath maxIni) + "armadasScriptsIni.ini"
-- fn
-- UI
	group "opacity:"
	(
		spinner opaVarSP "opacity: "  range: [0,100,opaVal]  --enabled: false
-- 		spinner opaVarSP2 "opacity: "  range: [0,100,opaVal]  controller: $.material.opacity.controller
		button opa40BT "40"   enabled: true across:  3
		button opa60BT "60"  -- enabled: false
		button opa100BT "100"  --enabled: false
	)
	
	group "hd material:"
	(
		button trueBT "true" across: 2
		button falseBT "false"
	)
	
-- actions
	on opaRLT open do
	(
		loadRolloutParams opaRLT params
	)
	
	on opaRLT close do
	(
		writeRolloutParams opaRLT params
	)
	

	on opaVarSP changed val do 
	(
		local sel = selection as array
		for s in sel do 
		(
			try
			(
				s.material.opacity = val
				format "opacity %: %\n" val s.name
			)
			catch()
		)
	)
		
	 on opa40BT pressed do 
	 (	
		local sel = selection as array
		for s in sel do 
		(
			try
			(
				s.material.opacity = 40
				format "opacity 40: %\n" s.name
			)
			catch()
		)
	 )
	 
	on opa60BT pressed do
	(
		local sel = selection as array
		for s in sel do 
		(
			try
			(
				s.material.opacity = 60
				format "opacity 60: %\n" s.name
			)
			catch()
		)
	)

	on opa100BT pressed do 
	(
		local sel = selection as array
		for s in sel do 
		(
			try
			(
				s.material.opacity = 100
				format "opacity 100: %\n" s.name
			)
			catch()
		)
	)
	
	on trueBT pressed do
	(
		local sel = selection as array
		for s in sel do
		(
			enableHardwareMaterial s.material  true
			showHWTextureMap s.material  true
		)
	)
	
	on falseBT pressed do
	(
		local sel = selection as array
		for s in sel do
		(
			enableHardwareMaterial s.material  false
			showHWTextureMap s.material  false
		)
	)		
	
)

createdialog opaRLT  width: 200 style: #(#style_titlebar, #style_border, #style_sysmenu,#style_minimizebox, #style_maximizebox )

