getThisScriptFilename() 
-- Script d'initialisation des controle panel
-- maj: prévoir de créer de nouveau control panel à partir de l ui
-- prévoir d'indiquer quelques paramètres à la création d'un helper comme le nom du helper, l'image de référence, le nom du fichier script final
-- debug: charger les parametres du helper et pas depuis les champs de texte

-- bug; pas d'extension a la création du fichier .ms
-- erreur si le launcher est lancé sans selectionner un helper (nécessite de charger les chemins d'accés dans les champs)


fn FindCtrStackFN  = 
(
	local ctrList = #()
	for o in ($* as array) do 
	(
			if (classof o == point) AND ((findString o.name "PanelCreatorHlp_") != undefined)  then
			(
				
				 append ctrList o
			)
	)
	if ctrList.count>0 then return ctrList else return #()
)


fn createHelperFN =
(
	ctrStack = point name: (uniquename "PanelCreatorHlp_")

	-- definition des attributs
	def2 = attributes controlPanel
	(
		
		parameters main 
		(
			panLab type: #string text:"z"
			imagePath type: #string text:"y"
			finalPath type: #string text: "x"
			
			butCount type: #integer
			
			butIDAr type: #stringtab tabSizeVariable:true 
			butLabAr type: #stringtab tabSizeVariable:true 
			
			XcoordAr type: #intTab tabSizeVariable:true 
			YcoordAr type: #intTab tabSizeVariable:true 

			objAr type: #nodetab tabSizeVariable:true  
		)
	)

	-- ajout des attributs

	custAttributes.add ctrStack def2

	-- appel des attributs
	ctrStack.butCount
	ctrStack.butLabAr
	
	return ctrStack
)
   

rollout controlPanelGestionUI "panel gestionnaire"
(
	local curHlp
	local controlAr = #()
	
	listbox ctrPanListLB "Control Panel list:"
	button launchSelBT "Launch" across: 3 enabled: false 
	button delSelBT "Del"
	button majBT "reset"
	
	group "Edit"
	(
		editText panLabET "pan Label :" 
		editText imagePathET " img Path :" readonly: true
		button imagePathBT "..."
		editText finalPathET " final path :"  readonly: true
		button finalPathBT "..."
	)
	
	group "New"
	(
		editText NpanLabET "pan Label :" 
		editText NimagePathET " img Path :" readonly: true
		button NimagePathBT "..."
		editText NfinalPathET " final path :"  readonly: true
		button NfinalPathBT "..."
		button newHlpBT "new"
	)
	
	on controlPanelGestionUI open do
	(
		if FindCtrStackFN () == undefined then 
		(
			print "pas de helper dans la scene"
-- 			createHelperFN()
		)
		else 
		(
			controlAr = FindCtrStackFN()
			ctrPanListLB.items = for o in controlAr collect o.name
			
		)
	)
	
	on ctrPanListLB selected elt do
	(
		print elt
		try
		(
			if controlAr[elt].panLab != undefined then panLabET.text = controlAr[elt].panLab else panLabET.text = " "
			if controlAr[elt].imagePath != undefined then imagePathET.text = controlAr[elt].imagePath else imagePathET.text = " "
			if controlAr[elt].finalPath != undefined then finalPathET.text = controlAr[elt].finalPath else finalPathET.text = " "
			launchSelBT.enabled = true
		)catch()
	)
	
	on panLabET entered newPanLab do
	(
		controlAr[ctrPanListLB.selection].panLab = newPanLab
		panLabET.text = newPanLab
	)
	
	on imagePathBT pressed do
	(
		try
		(
		bmpSel = selectBitMap  caption: ""
		controlAr[ctrPanListLB.selection].imagePath = bmpSel.filename
		imagePathET.text = controlAr[ctrPanListLB.selection].imagePath
		)catch()
	)
	
	on finalPathBT pressed do
	(
		try (
			panSave = getSaveFileName   caption: "" filename: maxFilePath types:"Mxs(*.ms)"
			controlAr[ctrPanListLB.selection].finalPath = panSave
			finalPathET.text = controlAr[ctrPanListLB.selection].finalPath
			createFile finalPathET.text 
			) catch ()
	)
	
	on launchSelBT pressed do
	(
		
		global TempCtr = controlAr[ctrPanListLB.selection]
		global tempEndFile = finalPathET.text
		global tempImgFile = imagePathET.text
-- 		print TempCtr
-- 		execute (openFile "G:\Program Files\Autodesk\3ds Max 2012\Scripts\zz_rig\control_panel\button_placer_UI.ms")
		execute(openFile ((getDir #scripts) + "\zz_rig\control_panel\controlPanel.ms"))

		TempCtr = undefined
		tempEndFile = undefined
		tempImgFile = undefined
	)
	
	on NimagePathBT pressed do
	(
		try
		(
		bmpSel = selectBitMap  caption: ""
		strtemp = bmpSel.filename
		NimagePathET.text = strtemp
		)catch()
	)
	
	on NfinalPathBT pressed do
	(
		try
		(
		NfinalPathET.text = getSaveFileName   caption: "" filename: maxFilePath types:"Mxs(*.ms)"
		)
		catch()
	)
	
	
	on newHlpBT pressed do
	(
		if (controlPanelGestionUI.NpanLabET.text != "") AND (controlPanelGestionUI.NimagePathET.text != "") AND (controlPanelGestionUI.NfinalPathET.text != "") then
		(
			try (
			newHlp = createHelperFN()
			newHlp.panLab = NpanLabET.text 
			newHlp.imagePath = NimagePathET.text
			newHlp.finalPath =  NfinalPathET.text
				
			controlAr = FindCtrStackFN()
			ctrPanListLB.items = for o in controlAr collect o.name
				
			NpanLabET.text = ""
			NimagePathET.text = ""
			NfinalPathET.text = ""
			)
			catch (print "saisie non conforme")
		)
		else
		(
			print "saisie non conforme"
		)
	)
	
	on delSelBT pressed do
	(
		delete controlAr[ctrPanListLB.selection]
		controlAr = FindCtrStackFN()
		ctrPanListLB.items = for o in controlAr collect o.name
	)
	
	on majBT pressed do
	(
		controlAr[ctrPanListLB.selection].butCount = 0
			
		controlAr[ctrPanListLB.selection].butIDAr =#() 
		controlAr[ctrPanListLB.selection].butLabAr =#() 
		controlAr[ctrPanListLB.selection].XcoordAr =#() 
		controlAr[ctrPanListLB.selection].YcoordAr =#() 
		controlAr[ctrPanListLB.selection].objAr =#()  
		
	)
)

createdialog controlPanelGestionUI width: 600