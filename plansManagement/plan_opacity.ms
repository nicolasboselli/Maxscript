-- maj:
-- add uvwMapAutoFit on panel
-- create plane



-- $.material.opacity.controller = bezier_float ()


try(destroyDialog opaRLT)catch()
rollout opaRLT "plan manipulator"
(
	struct planClass 
	(
		obj,
		
		fn getName = obj.material.diffusemap.filename,
		fn getMtlOp = obj.material.opacity,
			
		bmpName = getName(),
		mtlOpa = getMtlOp(),
		
		fn setMtlOp val = 
		(
			obj.material.opacity = val
		)
	)
	

-- vars
	local opaVal = 60
	local sel = selection as array
	local bitmapVar
	local stPlan
	
	local maxIni = getMAXIniFile()
	local armadasScriptsIni = (getFilenamePath maxIni) + "armadasScriptsIni.ini"
-- fn
-- UI
	group "map info:" 
	(
		button refreshMap_bt "ref>>" 
		editText objName_et "obj name:" readOnly: true fieldWidth: 200 text: "[NONE]"
		editText mapName_et "map name:" readOnly: true fieldWidth: 200 text: "[NONE]"
		
		button openFolder_bt "open folder" enabled: false
	)
	
	group "opacity:"
	(
		spinner opaVarSP "opacity: "  range: [0,100,opaVal]  enabled: false
-- 		spinner opaVarSP2 "opacity: "  range: [0,100,opaVal]  controller: $.material.opacity.controller
		button opa40BT "40"   enabled: false across:  3
		button opa60BT "60"   enabled: false
		button opa100BT "100"  enabled: false
	)
	
	group "rotate:"
	(
		-- import rotater
	)
	
	fn refreshUI PlanInst = 
	(
		if PlanInst != undefined then
		(
			objName_et.text = PlanInst.obj.name
			mapName_et.text = PlanInst.getName()
			openFolder_bt.enabled = true
			opaVarSP.enabled = true
			opa40BT.enabled = true
			opa60BT.enabled = true
			opa100BT.enabled = true
			opaVarSP.value = PlanInst.getMtlOp()

		)
		else
		(
			objName_et.text = "[NONE]"
			mapName_et.text = "[NONE]"
			openFolder_bt.enabled = false
			opaVarSP.enabled = false
			opa40BT.enabled = false
			opa60BT.enabled = false
			opa100BT.enabled = false
			
		)
	)
	
	fn writePosition cat rlt =
	(
		posBak = GetDialogPos rlt
		res = setINISetting armadasScriptsIni cat "pos" (posBak as string)
		res
		format  "position saved: %, %\n" posBak res
	)
	
	fn loadPosition cat rlt =
	(
		posLoad = false
		posBak = [800,250]
		if (hasINISetting armadasScriptsIni cat "pos") then
		(
			posBakStr = getINISetting armadasScriptsIni  cat "pos"
			posBak = execute posBakStr
			posLoad = true
			
		)
		
		format  "position load: %, %\n" posBak posLoad
		SetDialogPos rlt posBak
	)
	
	
-- actions
	on opaRLT open do
	(
		loadPosition opaRLT.name  opaRLT
	)
	
	on opaRLT close do
	(
		writePosition opaRLT.name  opaRLT
	)
	
	on refreshMap_bt pressed do
	(
		sel = selection as array
		if sel.count == 1 then
		(
			print "start init"
			
			try
			(
				stPlan = planClass sel[1]
				print "done"
			)
			catch
			(
				stPlan = undefined
				print "fail"
			)
			
			format "stPlan:  %\n" stPlan
			
			refreshUI stPlan
		)
		else
		(
			print"bad selection"
		)
	)
	
	on openFolder_bt pressed do
	(
		bitmapVar = stPlan.getName()
		if bitmapVar != undefined do
		(
			
			foldToOpen = getFileNamePath bitmapVar
			print foldToOpen
			doscommand ("explorer " + foldToOpen)
		)

	)
		
	on opaVarSP changed val do stPlan.setMtlOp val
		
	 on opa40BT pressed do 
	 (
		 stPlan.setMtlOp 40
		 opaVarSP.value = 40
	 )
	 
	on opa60BT pressed do
	(
		stPlan.setMtlOp 60
		opaVarSP.value = 60
	)

	on opa100BT pressed do 
	(
		stPlan.setMtlOp 100
		opaVarSP.value = 100
	)
	
	on opaRLT resized size do
	(
		print "resized"
		width =  size[1]
		print width
		mapName_et.width = width - 100
	)
)



createdialog opaRLT  width: 300 style: #(#style_resizing,#style_titlebar, #style_border, #style_sysmenu,#style_minimizebox, #style_maximizebox )

