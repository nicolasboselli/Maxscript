------------ DECLARATION DES VARIABLES ----------------------

global countPlan = 0
global planFile = undefined

global importfolderFEN = "M:\\Interieur\\Cellules\\Modelisation\\Fenetres\\"
global importfolderPOR = "M:\\Interieur\\Cellules\\Modelisation\\Portes\\"
-- global importfolderCAM = "M:\\Interieur\\Cellules\\Modelisation\\CamLights\\"
global importfolderCAM = @"M:\Light\"
global importfolderPST = "M:\\Interieur\\Cellules\\Modelisation\\Presets\\"
global importfolderVray = "M:\\Interieur\\Cellules\\Modelisation\\Vray\\"
global importfolderLIB = "M:\\Interieur\\Cellules\\Modelisation\\Library\\"
global importfolderAMB = "M:\\Interieur\\Cellules\\Modelisation\\Ambiances\\"

global filesFEN
global filesPOR

try(closerolloutfloater dRolFloater) catch()

-- Preparation des calques de travail
function createWorkLayer = (	
	target = LayerManager.getLayerFromName "- Splines Murs Ext"
	if target == undefined then (
		LayerManager.newLayerFromName "- Splines Murs Ext";
	) 
	
	target = LayerManager.getLayerFromName "- Splines Murs Balcon"
	if target == undefined then (
		LayerManager.newLayerFromName "- Splines Murs Balcon";
	) 

	target = LayerManager.getLayerFromName "- Splines Murs Fond"
	if target == undefined then (
		LayerManager.newLayerFromName "- Splines Murs Fond";
	) 

	target = LayerManager.getLayerFromName "- Splines Murs Int"
	if target == undefined then (
		LayerManager.newLayerFromName "- Splines Murs Int";
	) 

	target = LayerManager.getLayerFromName "- Splines Fenetres"
	if target == undefined then (
		LayerManager.newLayerFromName "- Splines Fenetres";
	) 
	target = LayerManager.getLayerFromName "- Splines PFenetres"
	if target == undefined then (
		LayerManager.newLayerFromName "- Splines PFenetres";
	) 
	target = LayerManager.getLayerFromName "- Splines Portes"
	if target == undefined then (
		LayerManager.newLayerFromName "- Splines Portes";
	) 
)
createWorkLayer()

fn inverseKnotOrder l =
(
	if superclassof l.baseobject == Shape then
	(
		max modify mode
		modPanel.setCurrentObject l.baseobject

		spCount = numSplines   l
		for i = 1 to spCount do reverse  l i 

		if l.modifiers.count > 0 then modPanel.setCurrentObject l.modifiers[1]
	)else()
)


rollout prepareScene "Preparer le cellule" width:350 height:230
(		
	button 'loadCamLight' "Ajouter CAM & Light" pos:[10,10] width:120 height:20 align:#left
	button 'loadRenderPset' "Preset Rendu" pos:[200,10] width:120 height:20 align:#left
	
	on loadCamLight pressed  do
	(			
		
		filesCam = getFiles (importfolderCAM + "light_cellules.max")	
		
		for f in filesCam collect ( 
			format "Merge file : %\n" f
			mergemaxfile (f) #select #autoRenameDups #useSceneMtlDups
		)
		
	)
	
	on loadRenderPset pressed  do
	(			
		
		presetFile = importfolderCAM + "preset_cellule.rps"
		if doesfileexist presetFile then
		(
			format "Import Preset file : %\n" presetFile			
			renderPresets.LoadAll 0 presetFile
		)

		filesVray = getFiles (importfolderVray + "\\Correction_Couleur.vccglb")	
		
		for f in filesVray collect ( 
			format "Import Vray Preset file : %\n" f			
			vfbControl #loadglobalccpreset f
		)
		
	)
			
)



rollout addPlan "Ajouter un plan" width:350 height:230
(	
	radiobuttons 'planSize' "Taille du plan : " labels:#("A4","A3","A2","A1","A0") pos:[10,10] default:1
	edittext 'planEchelle' "Echelle du plan : " pos:[10,60] text:"200"	
	button 'planParcourir' "Choisir un plan" pos:[10,90] width:100 height:20 align:#left	
	bitmap 'planBitmap' bitmap:(bitmap 100 100 color:white) pos:[190,90]
	button 'planBt' "Ajouter un plan" pos:[10,177] width:100 height:20 align:#left	
	
	on planParcourir pressed  do
	(				
		planFile = getOpenFileName caption:"Choisir un plan :" \
		types:"Images|*.jpg;*.png;*.tga;*.bmp)"
		if planFile == undefined then (
		) else (
			planBitmap.fileName = planFile
		)
		
	)
	
	on planBt pressed  do
	(	
		
		if planFile == undefined then (
			messageBox "Vous devez choisir un plan avec de le créer !"
		) else (
			
			echelle=planEchelle.text as integer
			size=[1,1]
			case of (
				(planSize.state==1):size=[21,29.7]
				(planSize.state==2):size=[29.7,42]
				(planSize.state==3):size=[42,59.4]
				(planSize.state==4):size=[59.5,84.1]
				(planSize.state==5):size=[84.1,118.9]
			)
			a4=[21,29.7]
			Plane length:size.x width:size.y pos:[0,0,0] isSelected:on
			$.lengthsegs = 1
			$.widthsegs = 1
			$.name = "Plan " + countPlan as string
			newmat = StandardMaterial()
			newmat.name = "MAT_"+$.name
			newbitmap = BitmapTexture()
			newbitmap.filename = planFile
			newmat.diffusemap = newbitmap
			newmat.showInViewport = true
			$.material = newmat
			countPlan += 1
			
			scale $ [echelle,echelle,echelle]
			
			target = LayerManager.getLayerFromName "Plans"
			
			if target == undefined then (
				LayerManager.newLayerFromName "Plans";
				target = LayerManager.getLayerFromName "Plans"
			) 
			
			target.addNode $
			clearSelection()
			
		)
		
	)
)

	
fn createWall oneArray hauteur epaisseur =
(
	extMod = Extrude amount: hauteur capStart: off capEnd: off
	shellMod = Shell outerAmount: 0.0 innerAmount: epaisseur	overrideInnerMatID: on	 matInnerID: 2 overrideOuterMatID: on matOuterID: 1 \
	overrideMatID: on matID: 3 autoSmoothAngle: 0 straightenCorners: on
	uvwMapMod = Uvwmap maptype: 4 length: 150 width: 150 height: 150
		
		
	for obj in oneArray  do 
	( 
		local modcount = obj.modifiers.count
		for i = 1 to modCount do deletemodifier obj 1
			
		addmodifier obj extMod
		addmodifier obj shellMod
		addmodifier obj uvwMapMod
		
-- 			format "mur balcon: %\n" obj.name
	)
)

rollout addExtWall "Ajouter les murs Exterieurs" width:350 height:230
(	
	group "Murs Exterieurs:"
	(
		spinner extwallHauteurSP "Hauteur :" type: #worldunits range: [0,500, 135] across: 2
		spinner extwallEpaisseurSP "Epaisseur :" type: #worldunits range: [0,500, 34]
		button extWallLayerBT "add to layer"
	)
	
	group "Murs Terrasses:"
	(
		spinner terrassewallHauteurSP "Hauteur :"type: #worldunits range: [0,500, 80]	across: 2
		spinner terrassewallEpaisseurSP "Epaisseur :"  type: #worldunits range: [0,500, 20]
		button terWallLayerBT "add to layer"
	)
	
	group "Tools:"
	(
		button extwallInverser "Inverser sens spline"  across: 2
		button delAllModBT "Supprimer Modifiers"
	)
	
	button extwallCreate "Créer les murs"   
	
	
	on extWallLayerBT pressed do
	(		
		l = LayerManager.getLayerFromName "- Splines Murs Ext"
		sel = selection as array
		for s in sel do l.addnode s
	)
	
	on terWallLayerBT pressed do
	(
		l = LayerManager.getLayerFromName "- Splines Murs Balcon"
		sel = selection as array
		for s in sel do l.addnode s
	)
	
	
	on extwallInverser pressed  do
	(	
		sel = selection as array
		for s in sel do inverseKnotOrder s
			
		select sel
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
	
	on extwallCreate pressed  do
	(	
		
		-- CREATION des murs exterieurs
		target = LayerManager.getLayerFromName "- Splines Murs Ext"
		if target == undefined then 
		(
			messageBox "Pour créer les mur Exterieur vous devez 'Préparer murExt'"
		) 
		else 
		(
			target.nodes &theNodes
			
			createWall theNodes  extwallHauteurSP.value extwallEpaisseurSP.value
		)
		
		-- creation des murs du fond
		target = LayerManager.getLayerFromName "- Splines Murs Balcon"
		if target == undefined then
		(
			messageBox "Pour créer les murs terrasse vous devez 'Préparer murBalcon'"
		)
		else
		(
			target.nodes &theNodes
			
			createWall theNodes  terrassewallHauteurSP.value  terrassewallEpaisseurSP.value
		)

	)
)

rollout addBackWall "Ajouter les murs du Fonds" width:350 height:230
(	

	group "Murs du Fond:"
	(
		spinner backwallHauteurSP "Hauteur :" type: #worldunits range: [0,500, 210] across: 2
		spinner backwallEpaisseurSP "Epaisseur :" type: #worldunits range: [0,500, 20] 
		button backWallLayerBT "add to layer"
		
	)
		
	button 'backwallCreate' "Créer les murFond" 
	

	
	on backWallLayerBT pressed do
	(		
		l = LayerManager.getLayerFromName "- Splines Murs Fond"
		sel = selection as array
		for s in sel do l.addnode s
	)
	
	
	on backwallCreate pressed  do
	(	
		target = LayerManager.getLayerFromName "- Splines Murs Fond"
			
		if target == undefined then 
		(
			messageBox "Pour créer les mur du Fond vous devez 'Préparer murFond'"
		) 
		else
		(
			target.nodes &theNodes
			
			createWall theNodes backwallHauteurSP.value backwallEpaisseurSP.value
		)
	)
)



rollout addIntWall "Ajouter les murs Interieurs" width:350 height:230
(		
	
	group "Murs Interieurs:"
	(
		spinner intwallHauteurSP "Hauteur :" type: #worldunits range: [0,500, 160] across: 2
		spinner intwallEpaisseurSP "Epaisseur :" type: #worldunits range: [0,500, 10] 
		button intWallLayerBT  "add to layer"
	)
	
	button 'intwallCreate' "Créer les murInt" across: 2
	button createSelectionBT "Créer Selection"
	
	
	on intWallLayerBT pressed do
	(		
		l = LayerManager.getLayerFromName "- Splines Murs Int"
		sel = selection as array
		for s in sel do l.addnode s
	)
	
	on intwallCreate pressed  do
	(	
		
		target = LayerManager.getLayerFromName "- Splines Murs Int"
		
		if target == undefined then 
		(
			messageBox "Pour créer les mur Interieurs vous devez 'Préparer murInt'"
		) 
		else
		(
			target.nodes &theNodes
			
			createWall theNodes  intwallHauteurSP.value  intwallEpaisseurSP.value
		)
	)
	
	on createSelectionBT pressed do
	(
		theNodes = selection as array
		
		createWall theNodes  intwallHauteurSP.value  intwallEpaisseurSP.value
	)
	
)

rollout finishedWall "Finir les murs" width:350 height:230
(		
	button 'wallCreate' "Finir les murs" pos:[120,10] width:100 height:20 align:#left
	
	on wallCreate pressed  do
	(			
		
		function unifyWall = (			
			clearSelection()			
			target = LayerManager.getLayerFromName "- Splines Murs Int"				
			target.nodes &theNodesInt		
			target.on = false;	
			target = LayerManager.getLayerFromName "- Splines Murs Ext"				
			target.nodes &theNodesExt		
			target.on = false;
			target = LayerManager.getLayerFromName "- Splines Murs Fond"				
			target.nodes &theNodesFond			
			target.on = false;			
			target = LayerManager.getLayerFromName "- Splines Murs Balcon"
			target.nodes &theNodesBalc	
			target.on = false;		
			clearSelection()
			
			target = LayerManager.getLayerFromName "+ Murs"					
			target.current  = true
			theObj = Plane length:1 width:1 pos:[0,0,0] isSelected:on
			convertto theObj editable_poly
			target.addNode $
				
			theFacesToSelect = theObj.Faces									
			polyOp.DeleteFaces  theObj theFacesToSelect
			
			for obj in theNodesInt  do ( 
				theObj + obj
			)			
			for obj in theNodesExt  do ( 
				theObj + obj
			)		
			for obj in theNodesFond  do ( 
				theObj + obj
			)	
			for obj in theNodesBalc  do ( 
				theObj + obj
			)
						
			convertto theObj editable_poly
			select theObj
			
			for i in theObj.verts do
			(
				format "Z pos : %  -" i.pos.z
				if (i.pos.z<2) then (
					--move i [0,0,-20]					
					format "Z pos <2 : %\n" i.pos.z
					i.pos.z = -20
				)
			)
			
			theObj.name = "Murs"
			
			filesMat = getFiles (importfolderLIB + "\\Cells_materials.mat")	
		
			for f in filesMat collect ( 
				format "Import Mat file : %\n" f		
				tempLib = loadTempMaterialLibrary f
				theObj.material = tempLib[1]
			)			
			
		)
		
		target = LayerManager.getLayerFromName "+ Murs"
			
		if target == undefined then (
			LayerManager.newLayerFromName "+ Murs";
			unifyWall()
		) else (
			unifyWall()			
		)	
		
	)
			
)

rollout createGround "Créer les sols" width:350 height:230
(		
	button 'groundInitialize' "Initialiser les sols" pos:[10,10] width:100 height:20 align:#left
	button 'groundFinalize' "Finaliser les sols" pos:[120,10] width:100 height:20 align:#left
	on groundInitialize pressed  do
	(		

		function extractSol = (			
			clearSelection()
			target = LayerManager.getLayerFromName "Plans"
			target.on = false
			target = LayerManager.getLayerFromName "+ Sols"	
			target.current  = true
			theObj = getNodeByName "Murs"
			select theObj
			
			theSection = section pos:[0, 0, 0.5]
			max views redraw
			convertToSplineShape theSection
			theSection.name =  "Sol construction"
			
			target.addNode theSection			
			
			target = LayerManager.getLayerFromName "Plans"
			target.on = true
			
			theObj = getNodeByName "Sol construction"		
			select theObj
			modPanel.setCurrentObject theObj.baseObject
			subobjectLevel = 1			
			for i=1 to (numSplines theObj) do (
				setKnotSelection theObj i #(1,numknots theObj i)
			)
			splineops.weld theObj
			updateShape theObj					
			subobjectLevel = 0			
			
		)
		
		target = LayerManager.getLayerFromName "+ Sols"
			
		if target == undefined then (
			LayerManager.newLayerFromName "+ Sols";
			extractSol()
			
			messageBox "Supprimez la Splines du contour exterieur et les splines des gaines"
		) else (			
			extractSol()	

			messageBox "Supprimez la Splines du contour exterieur et les splines des gaines"			
		)	
		
	)
	
	on groundFinalize pressed  do
	(		

		function actionSol = (			
			clearSelection
			target = LayerManager.getLayerFromName "+ Sols"	
			theObj = getNodeByName "Sol construction"
			
			tempLib  = undefined
			
			filesMat = getFiles (importfolderLIB + "\\Cells_materials.mat")	
		
			for f in filesMat collect ( 
				format "Import Mat file : %\n" f		
				tempLib = loadTempMaterialLibrary f
			)	
			
			
			maxOps.cloneNodes theObj cloneType:#copy newNodes:&nnl #nodialog
			for i = 1 to nnl.count do
			(				
				nnl[i].name = "Plinte"
				nnl[i].material = tempLib[2]
			)
			
			maxOps.cloneNodes theObj cloneType:#copy newNodes:&nnl #nodialog
			for i = 1 to nnl.count do
			(				
				nnl[i].name = "Sol"
				nnl[i].material = tempLib[2]
			)	
			
			clearSelection()
			theObj = getNodeByName "Sol"
			select theObj
			modPanel.addModToSelection(Extrude()) ui:on		
			modPanel.addModToSelection (Uvwmap ()) ui:on	
			theObj.modifiers[#Extrude].amount = -20
			theObj.modifiers[#Extrude].capStart = on
			theObj.modifiers[#Extrude].capEnd = on
			theObj.modifiers[#UVW_Map].maptype = 4
			theObj.modifiers[#UVW_Map].length = 200
			theObj.modifiers[#UVW_Map].width = 200
			theObj.modifiers[#UVW_Map].height = 200
			
			clearSelection
			theObj = getNodeByName "Plinte"
			select theObj
			modPanel.addModToSelection(Extrude()) ui:on			
			modPanel.addModToSelection(Shell()) ui:on			
			modPanel.addModToSelection (smooth ()) ui:on
			modPanel.addModToSelection (Uvwmap ()) ui:on	
			theObj.modifiers[#Extrude].amount = 10
			theObj.modifiers[#Extrude].capStart = off
			theObj.modifiers[#Extrude].capEnd = off
			theObj.modifiers[#Shell].outerAmount = 0 as integer
			theObj.modifiers[#Shell].innerAmount = 2 as integer					
			theObj.modifiers[#Shell].overrideInnerMatID = on					
			theObj.modifiers[#Shell].matInnerID = 1
			theObj.modifiers[#Shell].overrideOuterMatID = on					
			theObj.modifiers[#Shell].matOuterID = 1
			theObj.modifiers[#Shell].overrideMatID = on					
			theObj.modifiers[#Shell].matID = 1
			theObj.modifiers[#Shell].autoSmoothAngle = 0
			theObj.modifiers[#Shell].straightenCorners = on
			theObj.modifiers[#UVW_Map].maptype = 4
			theObj.modifiers[#UVW_Map].length = 200
			theObj.modifiers[#UVW_Map].width = 200
			theObj.modifiers[#UVW_Map].height = 200		
			
			select theObj
			convertto theObj editable_poly
			
		)
		
		
		target = LayerManager.getLayerFromName "+ Sols"
			
		if target == undefined then (
			LayerManager.newLayerFromName "+ Sols";
			messageBox "Veuillez Initialiser les sols en premier !"
		) else (			
			actionSol()	
		)	
		
	)
			
)

rollout openingWall "Ouverture des murs" width:350 height:230
(	
-- 	edittext 'windowHauteur' "Hauteur Fenetre (cm) : " pos:[12,10] text:"135"	width:160
-- 	edittext 'windowAllege' "Allege fenetre (cm) : " pos:[182,10] text:"90" width:150
-- 	edittext 'porteHauteur' "Hauteur Porte (cm) : " pos:[12,35] text:"204"	width:160
-- 	edittext 'porteFenetreHauteur' "Hauteur Porte fenetre (cm) : " pos:[12,60] text:"215" width:200
	
	group "Fenêtres:"
	(
		spinner windowHauteurSP "Hauteur:" type: #worldunits range: [0,500, 135] across: 2 -- pos:[12,10] text:"135"	width:160
		spinner windowAllegeSP "Allege:" type: #worldunits range: [0.5,500, 90] -- across: 2 -- pos:[182,10] text:"90" width:150
	)
	
	group "Portes:"
	(
		spinner porteHauteurSP "Hauteur:" type: #worldunits range: [0,500, 204] across: 2  -- pos:[12,35] text:"204"	width:160
		spinner porteAllegeSP "Hauteur:" type: #worldunits range: [0.5,500, 0.5] 
	)
	
	group "Porte-Fenêtres:"
	(
		spinner porteFenetreHauteurSP "Hauteur: " type: #worldunits range: [0,500, 215] across: 2  -- pos:[12,60] text:"215" width:200
		spinner porteFenetreAllegeSP "Hauteur: " type: #worldunits range: [0.5,500, 0.5]
	)
	
	button 'wallOpen' "Ouvrir les murs" -- pos:[120,90] width:100 height:20 align:#left
	
	on wallOpen pressed  do
	(		
			
			clearSelection()		
			
			local nnl1 = #()
			local nnl2 = #()
			local nnl3 = #()
		
			-- creation des bloc de portes 
			target = LayerManager.getLayerFromName "- Splines Portes"				
			target.nodes &theNodesPortes	
			
			if theNodesPortes.count > 0 then
			(		
				maxOps.cloneNodes theNodesPortes cloneType:#copy newNodes:&nnl1 #nodialog
		
				move nnl1 [0,0, porteAllegeSP.value]
				
				PorteExtMod = extrude amount: porteHauteurSP.value capStart: on capEnd: on
				PorteUVMod = Uvwmap maptype: 4 length: 150 width: 150 height: 150
						
				for obj in nnl1  do 
				(
					addmodifier obj PorteExtMod
					addmodifier obj PorteUVMod
				)

			)
			target.on = false
			
			-- creation des bloc de portes fenetres
			target = LayerManager.getLayerFromName "- Splines PFenetres"				
			target.nodes &theNodesPFenetres	
			
			if theNodesPFenetres.count > 0 then
			(					
				maxOps.cloneNodes theNodesPFenetres cloneType:#copy newNodes:&nnl2 #nodialog
					
				move nnl2 [0,0, porteFenetreAllegeSP.value]
				
				PFenExtMod = extrude amount: porteFenetreHauteurSP.value capStart: on capEnd: on
				PFenUVMod = Uvwmap maptype: 4 length: 150 width: 150 height: 150
						
				for obj in nnl2  do 
				(
					addmodifier obj PFenExtMod
					addmodifier obj PFenUVMod
				)
			)
			target.on = false
			
			-- creation des bloc de fenetres 
			target = LayerManager.getLayerFromName "- Splines Fenetres"				
			target.nodes &theNodesFenetres
			
			if theNodesFenetres.count > 0 then
			(
				maxOps.cloneNodes theNodesFenetres cloneType:#copy newNodes:&nnl3 #nodialog
-- 				select nnl3
					
-- 				move nnl3 [0,0,0.5]
				move nn3 [0,0,windowAllegeSP.value]
				
				FenExtMod = extrude amount: windowHauteurSP.value capStart: on capEnd: on
				FenUVMod = Uvwmap maptype: 4 length: 150 width: 150 height: 150
						
				for obj in nnl3  do 
				(
					addmodifier obj FenExtMod
					addmodifier obj FenUVMod
				)
			)
			target.on = false		
			
			-- ouverture des murs
			MurOrig = getNodeByName "Murs"
			theObj = copy MurOrig	
			
			l= MurOrig.layer
			l.addnode theObj
			
			MurOrig.ishidden = true
			
-- 			theObj = getNodeByName "Murs"
-- 			MurOrig = copy theObj		
				
			if nnl1.count > 0 then (for obj in nnl1  do ( theObj - obj))			
			if nnl2.count > 0 then (for obj in nnl2  do ( theObj - obj))	
			if nnl3.count > 0 then (for obj in nnl3  do ( theObj - obj))
			-- memo: le second opperator de la soustraction reste intact
						
			-- recupération des bloc de porte temporaire pour en faire des gabarits pour le fenetre
			targetTemp = LayerManager.getLayerFromName "-- Temp Portes"
			if targetTemp == undefined then targetTemp = LayerManager.newLayerFromName "-- Temp Portes"
			
			for obj in  nnl1 do
			(
				obj2 = copy MurOrig
				obj2 * obj
				targetTemp.addNode obj2
			)
			targetTemp.on = false		
			
			-- recupération des bloc de porte fenetre temporaire
			targetTemp = LayerManager.getLayerFromName "-- Temp PFenetres"
			if targetTemp == undefined then targetTemp = LayerManager.newLayerFromName "-- Temp PFenetres"
			
			for obj in  nnl2 do 
			(
				obj2 = copy MurOrig
				obj2 * obj
				targetTemp.addNode obj2
			)
			targetTemp.on = false
			
			-- recupération des bloc de fenetre temporaire
			targetTemp = LayerManager.getLayerFromName "-- Temp Fenetres"
			if targetTemp == undefined then targetTemp = LayerManager.newLayerFromName "-- Temp Fenetres" 
			
			for obj in  nnl3 do
			(
				obj2 = copy MurOrig
				obj2 * obj
				targetTemp.addNode obj2
			)
			targetTemp.on = false

			-- decoupage des plinte
			PlinteOrig = getNodeByName "Plinte"
			theObj = copy PlinteOrig
			
			l= PlinteOrig.layer
			l.addnode theObj
			
			PlinteOrig.ishidden = true
			
-- 			theObj = getNodeByName "Plinte"
			
			if isvalidnode theObj then
			(
				
				for obj in nnl1  do ( theObj - obj)	
				for obj in nnl2  do ( theObj - obj)		
				for obj in nnl3  do ( theObj - obj)
				
				convertto theObj editable_poly
			)
			else
			(
				delete nnl1
				delete nnl2
				delete nnl3
			)
			
-- 			delete MurOrig
	)
			
)

rollout doorFrame "Menuiseries et Portes" width:350 height:270
(	
	listbox 'listFenetres' "Choix de fenetres" pos:[10,10] width:330 height:3
	listbox 'listPFenetres' "Choix de Portes fenetres" pos:[10,80] width:330 height:3
	listbox 'listPortes' "Choix de portes" pos:[10,150] width:330 height:3
	button 'importElements' "Placer ouvertures" pos:[95,230] width:150 height:20 align:#left
	
	on doorFrame open  do
	(
		filesFEN = getFiles (importfolderFEN + "\\*.max")
		filesPOR = getFiles (importfolderPOR + "\\*.max")
		format "List Fenetres : % \nList Portes : %" filesFEN filesPOR
		listFenetres.items = for f in filesFEN collect ( getFilenameFile f)
		listPFenetres.items = for f in filesFEN collect ( getFilenameFile f)
		listPortes.items = for f in filesPOR collect ( getFilenameFile f)
	)
	
	on importElements pressed  do
	(	
	    
		
		targetTemp = LayerManager.getLayerFromName "-- Temp Portes"
		targetTemp.nodes &theNodesPortes
		targetTemp = LayerManager.getLayerFromName "-- Temp PFenetres"	
		targetTemp.nodes &theNodesPFenetres	
		targetTemp = LayerManager.getLayerFromName "-- Temp Fenetres"
		targetTemp.nodes &theNodesFenetres
		
		for obj in theNodesPortes do (
			clearSelection()
			mergemaxfile (importfolderPOR + "\\" + listPortes.selected + ".max") #select #autoRenameDups #useSceneMtlDups
			
			objHead = undefined
			isMoved = false
			
			for tempObj in selection do (				
				if (isGroupHead tempObj) then (
					tempObj.pos = obj.pos
					isMoved = true
				) else (
					objHead = tempObj
				)
			)	

			if isMoved==false  then (
				$.pos = obj.pos	
				objHead = $
				
			) 
			
			modPanel.addModToSelection (SliceModifier ()) ui:on
			objHead.modifiers[#Slice].Slice_Type = 2
			objHead.modifiers[#Slice].slice_plane.position.z = (addIntWall.intwallHauteur.text as float) + 5.0
			modPanel.addModToSelection (Cap_Holes ()) ui:on
		   
		)
		
		for obj in theNodesPFenetres do (
			clearSelection()
			mergemaxfile (importfolderFEN + "\\" + listPFenetres.selected + ".max") #select #autoRenameDups #useSceneMtlDups
			
			objHead = undefined
			isMoved = false
			
			for tempObj in selection do (				
				if (isGroupHead tempObj) then (
					tempObj.pos = obj.pos
					isMoved = true
				) else (
					objHead = tempObj
				)
			)	

			if isMoved==false  then (
				$.pos = obj.pos	
				objHead = $
				
			) 
			
			modPanel.addModToSelection (SliceModifier ()) ui:on
			objHead.modifiers[#Slice].Slice_Type = 2
			objHead.modifiers[#Slice].slice_plane.position.z = in coordsys world ((addExtWall.extwallHauteur.text as float) + 5.0)
			modPanel.addModToSelection (Cap_Holes ()) ui:on
		    
		)
		
		for obj in theNodesFenetres do (
			clearSelection()
			mergemaxfile (importfolderFEN + "\\" + listFenetres.selected + ".max") #select #autoRenameDups #useSceneMtlDups
			
			objHead = undefined
			isMoved = false
			
			for tempObj in selection do (				
				if (isGroupHead tempObj) then (
					tempObj.pos = obj.pos
					isMoved = true
				) else (
					objHead = tempObj
				)
			)	

			if isMoved==false  then (
				$.pos = obj.pos	
				objHead = $
				
			) 
			
			modPanel.addModToSelection (SliceModifier ()) ui:on
			objHead.modifiers[#Slice].Slice_Type = 2
			objHead.modifiers[#Slice].slice_plane.position.z = in coordsys world ((addExtWall.extwallHauteur.text as float) + 5.0)
			modPanel.addModToSelection (Cap_Holes ()) ui:on
				
		)
		
	)
			
)

rollout importAmbiance "Importer Ambiances" width:350 height:230
(		
	button 'loadScandinave' "Scandinave 01" pos:[10,10] width:120 height:20 align:#left
	button 'loadDesign' "Design 01" pos:[200,10] width:120 height:20 align:#left
	
	on loadScandinave pressed  do
	(			
		
		filesObjects = getFiles (importfolderAMB + "\\Scandinave_01.max")	
		
		for f in filesObjects collect ( 
			format "Merge file : %\n" f
			mergemaxfile (f) #select #autoRenameDups #useSceneMtlDups
		)
		
	)
	
	on loadDesign pressed  do
	(			
		
		filesObjects = getFiles (importfolderAMB + "\\Design_01.max")	
		
		for f in filesObjects collect ( 
			format "Merge file : %\n" f
			mergemaxfile (f) #select #autoRenameDups #useSceneMtlDups
		)
		
	)
		
)

dRolFloater = newRolloutFloater "Creation de plans de cellules" 350 650 80 200

addRollout prepareScene dRolFloater rolledUp:true
addRollout addPlan dRolFloater rolledUp:true
addRollout addExtWall dRolFloater rolledUp:true
addRollout addBackWall dRolFloater rolledUp:true
addRollout addIntWall dRolFloater rolledUp:true
addRollout finishedWall dRolFloater rolledUp:true
addRollout createGround dRolFloater rolledUp:true
addRollout openingWall dRolFloater rolledUp:false
addRollout doorFrame dRolFloater rolledUp:true
addRollout importAmbiance dRolFloater rolledUp:true

