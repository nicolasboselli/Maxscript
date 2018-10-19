
fn clusterAttachExtract objArr =
(
	j = 1
	count = objArr.count

	undo off
	(
		while objArr.count > 1 do
		(
			if classof objArr[j].baseobject != editable_Mesh then converttoMesh objArr[j]
			
			-- ATTACH
			attach objArr[j] objArr[j+1]
			
			deleteItem objArr (j+1)

			j += 1

			if (j + 1) > objArr.count then j = 1
		)
	)
	objArr[1]
)

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
	
	-- outline
	polyop.setFaceSelection newNode #all
	newNode.outlineAmount = outVal
	newNode.EditablePoly.Outline ()

	-- add shell on object
	myShell = Shell innerAmount:shellVal outerAmount:shellVal
	addmodifier newNode myShell	
	
-- 	newNode.material = undefined 

)


fn outlineFace newNode outVal =
(
	polyop.setFaceSelection newNode #all
	newNode.outlineAmount = outVal
	newNode.EditablePoly.Outline ()
	newNode
)

fn addShell newNode shellVal =
(
	local myShell = Shell innerAmount:shellVal outerAmount:shellVal
	addmodifier newNode myShell	
	newNode
)

fn extractFaces sel =
(
	local count1 = objects.count
	polyop.detachFaces sel[1] #selection delete: false asNode: true

	local count2 = objects.count
	local extraction = for i = count1 + 1 to count2 collect objects[i]
	extraction
)

fn extractEditPolyFaces sel =
(
	local count1 = objects.count
	sel[1].edit_poly.SetOperation #DetachFace 

	local count2 = objects.count
	local extraction = for i = count1 + 1 to count2 collect objects[i]
	extraction
)


try(destroydialog extractFacesRLT)catch()
rollout extractFacesRLT "extract faces"
(
	-- 	vars
	local params = #("pos","size","outCB","outSp","shellCB", "shellSp", "selectResultCB", "combineObjsCB")
	local armadasScriptsIni = (GetDir #maxData) + "armadasScriptsIni.ini"
		
	group "extraction"
	(
		checkbox outCB "add outline"
		spinner outSp "outline size" type: #worldunits range: [-1000, 1000, 0]
		checkbox shellCB "add shell"
		spinner shellSp "shell size"  type: #worldunits range: [-1000, 1000, 0]
		checkbox combineObjsCB "combine result"
		checkbox selectResultCB "select result"
	)
	
	button extractBT "extract"
	
	-- function UI dependant
	fn finishObject newObj =
	(
		-- combine
		if combineObjsCB.state then
		(
			newObj = #(convertToPoly (clusterAttachExtract newObj))
		)
		
		-- outline
		if outCB.state then 
		(
			for n in newObj do outlineFace n outSp.value
		)		
		
		-- shell
		if shellCB.state then 
		(
			local myShell = Shell innerAmount:shellSp.value outerAmount:shellSp.value
			for n in newObj do 
			(
				addmodifier n myShell	
			)
		)
		
		-- selection
		if selectResultCB.state then select newObj
		
		newObj
	)
	
	
	on extractBT pressed do
	(
		local sel = selection as array
		local current = modpanel.getCurrentObject()
		
		if current == undefined then(format "undefined\n")
		else if classof current == edit_poly then
		(
-- 			format "edit_poly\n"
			local tmpObj = extractEditPolyFaces sel
			finishObject tmpObj
		)
		else if classof current == Editable_Poly  and sel.count == 1 then
		(
			format "editable_poly\n"
-- 			extractFacesFN outSp.value shellSp.value sel
			local tmpObj = extractFaces sel
			finishObject tmpObj
		)
		else(format "unknown\n")

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

