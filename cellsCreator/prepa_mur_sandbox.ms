/*
maj:
	x- utiliser parametres stockés à l'exterieur pour prametrer la creations des murs
	x-- memoriser les modifications des parametres pdt la session
		x- memoriser les parametres à la fermeture dans le fichier ini
	
	x- ajouter, supprimer, renommer des types de mur
		x- memoriser les modification
	-- enregistrer et administrer les config de cellules(faire du groupe "configuration" un rollout independant chargeable par les prepas "murs", "percement", "sol") 
	
	- créer un auto snp des spline aux murs
	- sur le bouton create new faire qu'on crée une spline avec l'extrude et shell correctement configuré sur le bon layer
	- ajouter les boutons pour monter ou descendre le mur
	- rendre le wirecolor editable
*/

global cellSetPath = getroot() +"cellsCreator/cellSettings/*"
-- getfiles cellSetPath

struct spMurSet (name, wirecolor, hauteur, epaisseur)

try(destroydialog MursStyleNameRLT)catch()
rollout MursStyleNameRLT "rename style de mur"
(
	edittext nameET "name:"
	button renameBT "ok"
	
	on MursStyleNameRLT open do
	(
		if selectedMurTypeName != undefined then nameET.text = selectedMurTypeName
		else(nameET.text = "ERROR!")
	)
	
	on renameBT pressed do
	(
		selectedMurTypeName = nameET.text
		destroydialog MursStyleNameRLT
	)
	
	on nameET entered newName do
	(
-- 		format "newName: % \n" newName
		renameBT.pressed()
	)
)

try(destroydialog prepaMursRLT)catch()
rollout prepaMursRLT "preparation murs v2" width:350
(
	global selectedMurTypeName
	local cellSetAr = #()
	local layerStructAr = #()
	
	local cellSetIni -- = getRoot() + "cellsCreator/cellSettings/cellSettings.ini"
	local mursPrefix = "_Splines Murs "
	
	local murSel = undefined 
	
	group "configuration:"
	(
		dropdownlist  configDDL "select:"
		button saveBT "save" across: 3  -- enabled: false
		button saveAsBT "saveAs" enabled: false
		button loadBT "load"
	)
	
	group "types murs:"
	(
		multilistbox mursMLB "Murs:" height: 6
		button addtypeBT "add" across: 3
		button delTypeBT "delete"
		button renTypeBT "rename"  --enabled: false
	)
	
	group "paramètres:"
	(
		spinner hauteurSP "hauteur:"  type: #worldunits range: [0,1000, 215] across: 2
		spinner epaisseurSP "epaisseur:" type: #worldunits range: [0,1000, 20]
	)
	
	group "actions:"
	(
		button addToLayerBT "add to layer" across: 3
		button createNewBT "create new" enabled: false
		button createSelWallBT "creation des murs"
-- 		button adjustBT "adjust gabarits"
	)
	
	group "tools:"
	(
		button extwallInverser "Inverser sens spline"  across: 2 -- enabled: false 
		button delAllModBT "Supprimer Modifiers"
		button createSelectionBT "Créer murs sur Selection"  enabled: false
	)
	
	button createWallBT "creation de tous les murs" enabled: false
	
	-- fonction ui dependant
	fn refreshUI =
	(
		configDDL.items = for c in cellSetAr collect (getFilenameFile c)
		
-- 		mursMLB.items = for i = layerStructAr.count to 1 by -1 collect layerStructAr[i].name
		mursMLB.items = for p in layerStructAr collect p.name
		
		if murSel == undefined then
		(
			hauteurSP.value = 666
			epaisseurSP.value = 666
			addToLayerBT.enabled = false
			createSelWallBT.enabled = false
		)
		else
		(
			hauteurSP.value = murSel.hauteur
			epaisseurSP.value = murSel.epaisseur
			addToLayerBT.enabled = true
			createSelWallBT.enabled = true
		)
	)
	
	
	fn loadSettings f =
	(
		layerStructAr = #()
		mursSettingsAr = getINISetting f "mursSettings2"
		for o in  mursSettingsAr do
		(
-- 			format "%\n" (getINISetting cellSetIni "mursSettings2" o) 
			append layerStructAr (execute(getINISetting f "mursSettings2" o))
		)
	)
	
	fn saveSettings f =
	(
		format "start save\n"
		delIniSetting f "mursSettings2"
		
		for l in layerStructAr do
		(
			format "% = %\n" l.name (l as string)
			setINISetting f "mursSettings2" l.name  (l as string)
		)
		refreshUI()
	)
	
	on prepaMursRLT open do
	(
		-- collecte des settings de cellules
		cellSetAr = getfiles cellSetPath
		
		-- collecte des types de mur
		if cellSetAr.count == 0 then()
		else loadSettings cellSetAr[1]
		
		refreshUI()
	)
		
	on loadBT pressed do
	(		
		local config = cellSetAr[configDDL.selection]
-- 		format "configSel: %\n"  config

		if not doesfileexist config then()
		else 	loadSettings config
		
		refreshUI()
	)
	
	on saveBT pressed do
	(
		local config = cellSetAr[configDDL.selection]
-- 		format "configSel: %\n"  config

		if not doesfileexist config then()
		else 	saveSettings config
		
		refreshUI()
	)
	
	on configDDL selected val do
	(
		loadBT.pressed()
	)
	
	on mursMLB selectionend do
	(
		selIds =  (mursMLB.selection as array)
		if selIds.count == 1 then
		(
			murSel = layerStructAr[selIds[1]]
		)
		else
		(
			murSel = undefined
		)

		refreshUI()
	)	

	on addtypeBT pressed do
	(
		newType = spMurSet name:"New" wirecolor:orange hauteur:230 epaisseur:35
		append layerStructAr newType
		refreshUI()
		mursMLB.selection = #(mursMLB.items.count)
		renTypeBT.pressed()
		mursMLB.selectionend()
	)
	
	on delTypeBT pressed do
	(
		selIds =  (mursMLB.selection as array)
		format "selIds: %\n" selIds
		
		
		for i = selIds.count to i = 1 by - 1 do
		(
			format "layer: %\n" layerStructAr[selIds[i]]
			deleteitem layerStructAr selIds[i]
		)
		refreshUI()
	)
	
	on renTypeBT pressed do
	(
		selIds =  (mursMLB.selection as array)
		
		if selIds.count == 1 then
		(
			tmpName = layerStructAr[selIds[1]]
-- 			format "tmpName: %\n" tmpName.name
			selectedMurTypeName = tmpName.name
			createdialog MursStyleNameRLT modal: true
-- 			format "selectedMurTypeName: %\n" selectedMurTypeName
			if selectedMurTypeName != undefined then tmpName.name = selectedMurTypeName
		)
		
		refreshUI()
	)
	
	on hauteurSP changed val do
	(
		if murSel == undefined then()
		else mursel.hauteur = val
	)
	
	on epaisseurSP changed val do
	(
		if murSel == undefined then()
		else mursel.epaisseur = val
	)
	
	on addToLayerBT pressed do
	(
		local objs = selection as array
		
		if objs.count == 0 or murSel == undefined then()
		else if objs.count > 0 and murSel != undefined then
		(
			-- creation du calque
			local layername = mursPrefix + murSel.name
			l = LayerManager.getLayerFromName layername
			if l == undefined then l = LayerManager.newLayerFromName layername
				
			--  ajouter la selection d'objets au calque selectionné
			for o in objs do
			(
				l.addnode o
				o.wirecolor = murSel.wirecolor
				-- appliquer le traitement
			)
			
			createWall objs murSel.hauteur murSel.epaisseur
		)
		else()
	)
	
	on createSelWallBT pressed  do
	(
		local murLayer = undefined
		
		-- check le type de mur
		if murSel == undefined then()
		else
		(
			local layername = mursPrefix + murSel.name
			murLayer = LayerManager.getLayerFromName layername
		)
		
		-- creation des murs
		if murLayer == undefined then
		(
			messageBox "Pour créer les murs  vous devez créer le calque des murs'"
		)
		else
		(
			murLayer.nodes &theNodes
			createWall theNodes  murSel.hauteur  murSel.epaisseur
		)
	)
	
	on delAllModBT pressed do
	(
		sel = selection as array
		for s in sel do
		(
			local modcount = s.modifiers.count
			for i = 1 to modCount do deletemodifier s 1
		)
	)
	
	on extwallInverser pressed  do
	(	
		sel = selection as array
		for s in sel do inverseKnotOrder s
			
		select sel
	)
)
createdialog prepaMursRLT



