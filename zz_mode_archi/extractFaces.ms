


fn extractFacesFN outVal shellVal objSel =
(
	/*
	param: 
		float outval: outine value, 
		float shellval: shell value, 
		array objSel: object selected , 
	*/
	
	newName = uniqueName( objSel[1].name + "_part")
	-- detach faces
	polyop.detachFaces objSel[1] #selection delete: false asNode: true name: newName
-- 	polyop.setVertSelection objSel[1] #none
	subobjectLevel = 0

	-- outline faces of new object
	newNode = getnodebyname newName
	select newNode
	
	polyop.setFaceSelection newNode #all
	newNode.outlineAmount = outVal
	newNode.EditablePoly.Outline ()

	-- add shell on object
	myShell = Shell innerAmount:shellVal outerAmount:shellVal
	addmodifier newNode myShell	
	
	newNode.material = undefined 

-- 	local appuiMat
-- 	-- material
-- 	if sceneMaterials["appui"] == undefined then
-- 	(
-- 		appuiMat = Standard name: "appui"
-- 	)
-- 	else
-- 	(
-- 		appuiMat = sceneMaterials["appui"]
-- 	)
-- 	newNode.material = appuiMat
)




rollout extractFacesRLT "extract faces"
(
	-- 	vars
	local params = #("outSp", "shellSp")
	local armadasScriptsIni = (GetDir #maxData) + "armadasScriptsIni.ini"
		
	group "extraction"
	(
		spinner outSp "outline size" type: #worldunits range: [-1000, 1000, 0]
		spinner shellSp "shell size"  type: #worldunits range: [-1000, 1000, 0]
	)
	
	button extractBT "extract"
	
	on extractBT pressed do
	(
		sel = selection as array
		if sel.count == 1 do
		(
			extractFacesFN outSp.value shellSp.value sel 
		)
	)
	
	on extractFacesRLT open do
	(
		loadRolloutParams extractFacesRLT Params
	)
	
	on extractFacesRLT close do
	(
		writeRolloutParams extractFacesRLT Params
	)
)


createDialog extractFacesRLT

