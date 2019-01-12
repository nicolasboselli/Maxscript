/*
maj:

	- sur le bouton create new faire qu'on crée une spline avec l'extrude et shell correctement configuré sur le bon layer
	
	x- utiliser parametres stockés à l'exterieur pour prametrer la creations des murs
	x-- memoriser les modifications des parametres pdt la session
		-- memoriser les parametres à la fermeture dans le fichier ini
	
	-- ajouter, supprimer, renommer des types de mur
		-- memoriser les modification
	-- enregistrer et administrer les config de cellules(faire du groupe "configuration" un rollout independant chargeable par les prepas "murs", "percement", "sol") 
	
	- ajouter les boutons pour monter ou descendre le mur
	- rendre le wirecolor editable
*/

global cellSetPath = getroot() +"cellsCreator/cellSettings/*"
-- getfiles cellSetPath

struct spMurSet (name, wirecolor, hauteur, epaisseur)

try(destroydialog prepaMursRLT)catch()
rollout prepaMursRLT "preparation murs v2" width:350
(
	local cellSetAr = #()
	local layerStructAr = #()
	
	local cellSetIni = getRoot() + "cellsCreator/cellSettings/cellSettings.ini"
	local mursPrefix = "_Splines Murs "
	
	local murSel = undefined 
	
	group "configuration:"
	(
		dropdownlist  configDDL "select:"
		button saveBT "save" across: 3
		button saveAsBT "saveAs"
		button loadBT "load"
	)
	
	group "types murs:"
	(
		multilistbox mursMLB "Murs:" height: 6
		button addtypeBT "add" across: 3
		button delTypeBT "delete"
		button renTypeBT "rename"
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
	
	fn refreshUI =
	(
		configDDL.items = for c in cellSetAr collect (getFilenameFile c)
		
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
	
	on prepaMursRLT open do
	(
		-- collecte des settings de cellules
		cellSetAr = getfiles cellSetPath
		
		-- collecte des types de mur
		mursSettingsAr = getINISetting cellSetIni "mursSettings2"
		for o in  mursSettingsAr do
		(
-- 			format "%\n" (getINISetting cellSetIni "mursSettings2" o) 
			append layerStructAr (execute(getINISetting cellSetIni "mursSettings2" o))
		)
		layerStructAr
		
		refreshUI()
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