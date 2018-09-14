/*
-- derouler
	-- placement des murs 
	-- placement des 


-- maj
	-- decouper une plane en fonction des murs en spline pour faire les sol
	x-- decouper les murs spline en fonction des gabarits de porte
	
	-- a l'ajout des porte, fenetres... etc.. renommer les spline et changer leur wirecolor
	
*/


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


rollout createGround "Créer les sols" width:350 height:230
(	
	
	local murPourSol
	
	button 'wallCreate' "fusionner les murs" across: 3 -- pos:[120,10] width:100 height:20 align:#left
	button 'groundInitialize' "Initialiser les sols"  -- pos:[10,10] width:100 height:20 align:#left
	button 'groundFinalize' "Finaliser les sols" -- pos:[120,10] width:100 height:20 align:#left
	
	-- fusionne les murs
	function unifyWall  = 
	(			
			
		target = LayerManager.getLayerFromName "- Splines Murs Int"				
		target.nodes &theNodesInt		
		target.on = false
			
		target = LayerManager.getLayerFromName "- Splines Murs Ext"				
		target.nodes &theNodesExt		
		target.on = false
			
		target = LayerManager.getLayerFromName "- Splines Murs Fond"				
		target.nodes &theNodesFond			
		target.on = false	
			
		target = LayerManager.getLayerFromName "- Splines Murs Balcon"
		target.nodes &theNodesBalc	
		target.on = false	

		local theMurs = theNodesInt + theNodesExt + theNodesFond + theNodesBalc
		
-- 		fusion des murs
		local mursL = LayerManager.getLayerFromName "+ Murs"					
			
		theObj = (editable_mesh())
		mursL.addnode theObj
		
		for obj in theMurs  do ( theObj + obj)
			
		convertto theObj editable_poly
		
-- 		descente du bas des murs
		for i in theObj.verts do
		(
			if (i.pos.z<2) then ( i.pos.z = -20	)
		)
		
		-- rename		
		theObj.name = "Murs"
		
		-- all edge visibles
		converttomesh theObj
		faceCount = theObj.numFaces
		for i = 1 to faceCount do
		(
			setEdgeVis theObj i 1 true
			setEdgeVis theObj i 2 true
			setEdgeVis theObj i 3 true
		)
		update theObj
		
		theObj
	
	)
	
	-- création des splines pour le sol
	function extractSol = 
	(			
		/*
		debug: cacher tout ce qui n'est pas le mur pour faire la section dessus
		*/
		clearSelection()
		target = LayerManager.getLayerFromName "Plans"
		target.on = false
		
		target = LayerManager.getLayerFromName "+ Sols"	
		target.current  = true
		
		-- recuperation du mur
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
		for i=1 to (numSplines theObj) do
		(
			setKnotSelection theObj i #(1,numknots theObj i)
		)
		splineops.weld theObj
		updateShape theObj					
		subobjectLevel = 0		

-- 		delete theObj
		
	)
		
	-- création du sol
	function actionSol =
	(			
		target = LayerManager.getLayerFromName "+ Sols"	
		theObj = getNodeByName "Sol construction"
		
		tempLib  = undefined
		
		-- import des materiaux
		fileMat = importfolderLIB + "\\Cells_materials.mat"
		if doesfileexist fileMat then tempLib = loadTempMaterialLibrary fileMat
		
		uvwMapMod = uvwmap maptype: 4 length: 200 width: 200 height: 200
					
		-- creation des sol
		theSolLine = copy theObj
		theSolLine.name = "sol"
		theSolLine.material = tempLib[2]
		
		solExtMod = extrude amount: -20 capstart: on capend: on
		addmodifier theSolLine solExtMod
		addmodifier theSolLine uvwMapMod
		
		-- creation des plintes
		thePlinteLine = copy theObj
		target.addnode thePlinteLine
		thePlinteLine.name = "plinte"
		thePlinteLine.material = tempLib[2]
		
		plinteExtMod = extrude amount: 10 capstart: off capend: off
		plinteShellMod = shell outerAmount: 0 innerAmount: 2 overrideInnerMatID: on matInnerID: 1 overrideOuterMatID: on \
		matOuterID: 1 overrideMatID: on matID: 1 autoSmoothAngle: 0 straightenCorners: on
			
		addmodifier thePlinteLine plinteExtMod
		addmodifier thePlinteLine plinteShellMod
		addmodifier thePlinteLine  (smooth ())
		addmodifier thePlinteLine uvwMapMod

		convertto thePlinteLine editable_poly
	)
	
	on wallCreate pressed  do
	(			
		target = LayerManager.getLayerFromName "+ Murs"
			
		if target == undefined then
		(
			LayerManager.newLayerFromName "+ Murs"
			unifyWall()
		) 
		else 
		(
			unifyWall()			
		)	
		
	)
	
	on groundInitialize pressed  do
	(		
		target = LayerManager.getLayerFromName "+ Sols"
			
		if target == undefined then
		(
			LayerManager.newLayerFromName "+ Sols";
			extractSol()
			messageBox "Supprimez la Splines du contour exterieur et les splines des gaines"
		)
		else 
		(			
			extractSol()	
			messageBox "Supprimez la Splines du contour exterieur et les splines des gaines"			
		)	
	)
	
	on groundFinalize pressed  do
	(		
		
		target = LayerManager.getLayerFromName "+ Sols"
			
		if target == undefined then 
		(
			LayerManager.newLayerFromName "+ Sols";
			messageBox "Veuillez Initialiser les sols en premier !"
		) 
		else 
		(			
			actionSol()	
		)	
	)
)

rollout openingWall "Ouverture des murs" width:350 height:230
(	
	
	group "Fenêtres:"
	(
		spinner windowHauteurSP "Hauteur:" type: #worldunits range: [0,500, 215] across: 2 -- pos:[12,10] text:"135"	width:160
		spinner windowAllegeSP "Allege:" type: #worldunits range: [0.5,500, 90] -- across: 2 -- pos:[182,10] text:"90" width:150
		button addToFenLayerBT "add to layer"
	)
	
	group "Portes:"
	(
		spinner porteHauteurSP "Hauteur:" type: #worldunits range: [0,500, 204] across: 2  -- pos:[12,35] text:"204"	width:160
		spinner porteAllegeSP "Allege:" type: #worldunits range: [0.5,500, 0.5] 
		button addToPorteLayerBT "add to layer"
	)
	
	group "Porte-Fenêtres:"
	(
		spinner porteFenetreHauteurSP "Hauteur: " type: #worldunits range: [0,500, 215] across: 2  -- pos:[12,60] text:"215" width:200
		spinner porteFenetreAllegeSP "Allege: " type: #worldunits range: [0.5,500, 0.5]
		button addToPorteFenLayerBT "add to layer"
	)
	 
	button createGabaritBT "Créer les Gabarits" across: 2
	button 'wallOpen' "Ouvrir les murs" -- pos:[120,90] width:100 height:20 align:#left
	
	on addToFenLayerBT pressed do
	(
		fenL = LayerManager.getLayerFromName "- Splines Fenetres"	
		if fenL == undefined then()
		else
		(
			sel = selection as array
			for s in sel do fenL.addnode s
		)
	)
	
	on addToPorteLayerBT pressed do
	(		
		porteL = LayerManager.getLayerFromName "- Splines Portes"				
		if porteL == undefined then()
		else
		(
			sel = selection as array
			for s in sel do porteL.addnode s
		)
	)
	
	on addToPorteFenLayerBT pressed do
	(
		PFenL = LayerManager.getLayerFromName "- Splines PFenetres"	
		if PFenL == undefined then()
		else
		(
			sel = selection as array
			for s in sel do PFenL.addnode s
		)
	)
	
	on createGabaritBT pressed do
	(
		
			-- creation des bloc de portes 
			porteL = LayerManager.getLayerFromName "- Splines Portes"				
			porteL.nodes &theNodesPortes	
		
			TmpPorteL = LayerManager.getLayerFromName "-- Temp Portes"
			if TmpPorteL == undefined then TmpPorteL = LayerManager.newLayerFromName "-- Temp Portes"
			else
			(
				-- nettoyage des calques temporaire de gabarit avant la création
				TmpPorteL.nodes &portesToDel
				delete portesToDel
			)
			
			local PorteExtMod = extrude amount: (porteHauteurSP.value - porteAllegeSP.value) capStart: on capEnd: on
-- 			local PorteUVMod = Uvwmap maptype: 4 length: 150 width: 150 height: 150
						
			for p in theNodesPortes do
			(
				local newP = copy p
				
				TmpPorteL.addnode newP
				move newP [0,0, porteAllegeSP.value]
				
				addmodifier newP PorteExtMod
-- 				addmodifier newP PorteUVMod
				
				newP.wirecolor = red
			)
			
			porteL.on = false
			
			-- creation des bloc de portes fenetres
			PFenL = LayerManager.getLayerFromName "- Splines PFenetres"				
			PFenL.nodes &theNodesPFenetres	
			
			TmpPFenL = LayerManager.getLayerFromName "-- Temp PFenetres"
			if TmpPFenL == undefined then TmpPFenL = LayerManager.newLayerFromName "-- Temp PFenetres"
			else
			(
				-- nettoyage des calques temporaire de gabarit avant la création
				TmpPFenL.nodes &PfenToDel
				delete PfenToDel
			)
			
			PFenExtMod = extrude amount: (porteFenetreHauteurSP.value - porteFenetreAllegeSP.value ) capStart: on capEnd: on
-- 			PFenUVMod = Uvwmap maptype: 4 length: 150 width: 150 height: 150
			
			for f in theNodesPFenetres do
			(
				local newPF = copy f
				
				TmpPFenL.addnode newPF
				move newPF [0,0, porteFenetreAllegeSP.value]
				
				addmodifier newPF PFenExtMod
-- 				addmodifier newPF PFenUVMod
				newPF.wirecolor = green
			)

			PFenL.on = false
			
			-- creation des bloc de fenetres 
			fenL = LayerManager.getLayerFromName "- Splines Fenetres"				
			fenL.nodes &theNodesFenetres
			
			TmpfenL = LayerManager.getLayerFromName "-- Temp Fenetres"
			if TmpfenL == undefined then TmpfenL = LayerManager.newLayerFromName "-- Temp Fenetres" 
			else
			(
				-- nettoyage des calques temporaire de gabarit avant la création
				TmpfenL.nodes &fenToDel
				delete fenToDel
			)
			
			FenExtMod = extrude amount: (windowHauteurSP.value - windowAllegeSP.value) capStart: on capEnd: on
-- 			FenUVMod = Uvwmap maptype: 4 length: 150 width: 150 height: 150
			
			for f in theNodesFenetres do
			(
				local newF = copy f
				
				TmpfenL.addnode newF
				move newF [0,0, windowAllegeSP.value]
				
				addmodifier newF FenExtMod
-- 				addmodifier newF FenUVMod
				newF.wirecolor = blue
			)
			fenL.on = false		
	)
	
	on wallOpen pressed  do
	(		
	
		-- ouverture des murs
		
		--  creation et nettoyage du calque appartement
		AptL = LayerManager.getLayerFromName "Appartement"
		if AptL == undefined then AptL = LayerManager.newLayerFromName "Appartement"
		else
		(
			AptL.nodes &tmpAptNodes
			delete tmpAptNodes
		)
			
		-- recuperation du calque murs
		MursL = LayerManager.getLayerFromName "+ Murs"
		
		-- recuperation des blocs de gabarits sur les calques
		local nnl1 = #()
		local nnl2 = #()
		local nnl3 = #()

		-- recuperation des blocs de gabarits sur les calques
		TmpPFenL = LayerManager.getLayerFromName "-- Temp PFenetres"
		if TmpPFenL != undefined then TmpPFenL.nodes & nnl1
			
		TmpfenL = LayerManager.getLayerFromName "-- Temp Fenetres"
		if TmpfenL != undefined then TmpfenL.nodes & nnl2
		
		TmpPorteL = LayerManager.getLayerFromName "-- Temp Portes"
		if TmpPorteL != undefined then TmpPorteL.nodes & nnl3
		
		nnl = nnl1 + nnl2 + nnl3
		
		-- recuperation des mur
		theMurs = #()
		MursBalL = LayerManager.getLayerFromName "- Splines Murs Balcon"
		MursBalL.nodes &MursBal
		
		MursExtL = LayerManager.getLayerFromName "- Splines Murs Ext"
		MursExtL.nodes &MursExt
		
		MursFondL = LayerManager.getLayerFromName "- Splines Murs Fond"
		MursFondL.nodes &MursFond
		
		MursIntL = LayerManager.getLayerFromName "- Splines Murs Int"
		MursIntL.nodes &MursIntL
		
		theMursOrig = MursBal + MursExt + MursFond + MursIntL
		
		--recuperation du materiau
		local tempLib
		f = importfolderLIB + "\\Cells_materials.mat"
		if doesfileexist f then tempLib = loadTempMaterialLibrary f
		
		-- copies des murs
		for m in theMursOrig do
		(
			newM = copy m
			converttomesh newM
			
			-- descente des vertex
			for i in newM.verts do
			(
				if (i.pos.z<2) then	i.pos.z = -20
			)	
			
			-- decoupe du mur
			for obj in nnl  do ( newM - obj)
			
			-- triangulation
			faceCount = newM.numFaces
			for i = 1 to faceCount do
			(
				setEdgeVis newM i 1 true
				setEdgeVis newM i 2 true
				setEdgeVis newM i 3 true
			)
			update newM
			
			-- ajout au calque mur
			AptL.addnode newM
			
			-- ajout du materiaux
			if tempLib != undefined then newM.material = tempLib[1]

			-- ajout de smooth
			addmodifier newM (smooth())
			
			-- ajout du murs aux objets à decouper
			append theMurs newM			
		)
		
		-- cachage des murs fusionner
		MurOrig = getNodeByName "Murs"
		if isvalidnode MurOrig then MurOrig.ishidden = true
		
		
		-- decoupage des plinte
		PlinteOrig = getNodeByName "Plinte"
		thePlinte = copy PlinteOrig
		
		l= PlinteOrig.layer
		l.addnode thePlinte
		
		PlinteOrig.ishidden = true
		
		AptL.addnode thePlinte
					
		if isvalidnode thePlinte then
		(
			if nnl.count > 0 then (for obj in nnl  do ( thePlinte - obj))
		)

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
-- addRollout finishedWall dRolFloater rolledUp:true
addRollout createGround dRolFloater rolledUp:true
addRollout openingWall dRolFloater rolledUp:false
addRollout doorFrame dRolFloater rolledUp:true
addRollout importAmbiance dRolFloater rolledUp:true

