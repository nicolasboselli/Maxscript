/*
-- maj:
	/- a l'ajout des spline de murs, porte, fenetres... etc.. renommer les spline et changer leur wirecolor

	-- créer un auto snap des spline de murs
	x- determiner l'orientation des gabarit de box
	-- placer les lights devant les fenetres et au dessus de chaque piece
	-- reprendre le déroulé du script en séparant prépa et finalisation, notament au niveau des sols et surtout des plintes
	-- plutot que de faire des murs de differentes hauteur, proposer de monter ou descendre les splines de la difference entre mur haut et mur bas
	-- decouper une plane en fonction des murs en spline pour faire les sol (la technique de la section fait l'affaire)
	
-- deroulement:
	x- murs
	x- sols
	x- ouverture
	- sol terrasse
	- garde corps
	/- placement fenetre
	/- placement porte
	- lights
	- placard
	- sdb
	- cuisines
	- cadres
	- plantes
	- reste
	
*/


------------ DECLARATION DES VARIABLES ----------------------

global countPlan = 0
global planFile = undefined

global importfolderFEN = "M:\\Interieur\\Cellules\\Modelisation\\Fenetres\\"
global importfolderPOR = "M:\\Interieur\\Cellules\\Modelisation\\Portes\\"
-- global importfolderCAM = "M:\\Interieur\\Cellules\\Modelisation\\CamLights\\"
-- global importfolderCAM = @"M:\Elements_batiments\Light\"
global importfolderCAM = @"M:\Light\"
global importfolderPST = "M:\\Interieur\\Cellules\\Modelisation\\Presets\\"
global importfolderVray = "M:\\Interieur\\Cellules\\Modelisation\\Vray\\"
global importfolderLIB = "M:\\Interieur\\Cellules\\Modelisation\\Library\\"
global importfolderAMB = "M:\\Interieur\\Cellules\\Modelisation\\Ambiances\\"

global filesFEN
global filesPOR

try(closerolloutfloater dRolFloater) catch()


global mursLayer = "+ Sol construction"

-- Preparation des calques de travail
function createWorkLayer = 
(	
	layerList = #( "- Splines Murs Ext", 
		"- Splines Murs Balcon",
		"- Splines Murs Fond",
		"- Splines Murs Int",
		"- Splines Fenetres",
		"- Splines PFenetres",
		"- Splines Portes"
	)
	
	for l in layerList do
	(
		if  LayerManager.getLayerFromName l == undefined then LayerManager.newLayerFromName l
	)
)

-- inversion du sens de la spline
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
-- 	button initLayersBT "initialiser les calques" 
	button 'loadCamLight' "Importer CAM & Light" across: 2 -- pos:[10,10] width:120 height:20 align:#left
	button 'loadRenderPset' "Preset Rendu" -- pos:[200,10] width:120 height:20 align:#left
	
	on prepareScene open do createWorkLayer()
-- 	on initLayersBT pressed do createWorkLayer()

	
	on loadCamLight pressed  do
	(			
		f = (importfolderCAM + "light_cellules.max")	
		
		if doesfileexist f then mergemaxfile (f) #select #autoRenameDups #useSceneMtlDups
		else 	format "fichier de lighting introuvable: %\n" f
		
	)
		
	on loadRenderPset pressed  do
	(		
		renderSceneDialog.close()
		
		renderWidth = 4900
		renderHeight = 4165
		
		presetFile = importfolderCAM + "passe_cellule.rps"
		if doesfileexist presetFile then
		(
			format "Import Preset file : %\n" presetFile			
			renderPresets.LoadAll 0 presetFile
		)
		
		/*
		filesVray = importfolderVray + "\\Correction_Couleur.vccglb"
		if doesfileexist filesVray then 
		(
			format "Import Vray Preset file : %\n" filesVray
			vfbControl #loadglobalccpreset filesVray
		)
		*/
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

rollout addExtWall "Creation des Murs" width:350 height:230
(	
	group "Murs Exterieurs:"
	(
		spinner extwallHauteurSP "Hauteur :" type: #worldunits range: [0,500, 110] across: 2
		spinner extwallEpaisseurSP "Epaisseur :" type: #worldunits range: [0,500, 34]
		button extWallLayerBT "add to layer" across: 2
		button extwallCreate "Créer murs exterieurs"   
	)
	
	group "Murs Terrasses:"
	(
		spinner terrassewallHauteurSP "Hauteur :"type: #worldunits range: [0,500, 20]	across: 2
		spinner terrassewallEpaisseurSP "Epaisseur :"  type: #worldunits range: [0,500, 20]
		button terWallLayerBT "add to layer" across: 2
		button terWallCreateBT "Créer murs terrasse"
	)
	
	
	group "Murs du Fond:"
	(
		spinner backwallHauteurSP "Hauteur :" type: #worldunits range: [0,500, 230] across: 2
		spinner backwallEpaisseurSP "Epaisseur :" type: #worldunits range: [0,500, 20] 
		button backWallLayerBT "add to layer" across: 2
		button 'backwallCreate' "Créer murs Fond" 
	)
	
	group "Murs Interieurs:"
	(
		spinner intwallHauteurSP "Hauteur :" type: #worldunits range: [0,500, 230] across: 2
		spinner intwallEpaisseurSP "Epaisseur :" type: #worldunits range: [0,500, 10] 
		button intWallLayerBT  "add to layer" across: 2
		button 'intwallCreate' "Créer murs Interieur" -- across: 2
	)
	
	group "Tools:"
	(
		button extwallInverser "Inverser sens spline"  across: 2
		button delAllModBT "Supprimer Modifiers"
		button createSelectionBT "Créer murs sur Selection"
	)
	
	
	on extWallLayerBT pressed do
	(		
		l = LayerManager.getLayerFromName "- Splines Murs Ext"
		sel = selection as array
		for s in sel do 
		(
			l.addnode s
			s.wirecolor = orange
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

	)
	
	on terWallLayerBT pressed do
	(
		l = LayerManager.getLayerFromName "- Splines Murs Balcon"
		sel = selection as array
		for s in sel do
		(
			l.addnode s
			s.wirecolor = gray
		)
	)
	
	on terWallCreateBT pressed do
	(
		-- creation de balcon
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
	
	on backWallLayerBT pressed do
	(		
		l = LayerManager.getLayerFromName "- Splines Murs Fond"
		sel = selection as array
		for s in sel do 
		(
			l.addnode s
			s.wirecolor = yellow
		)
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
	
		
	on intWallLayerBT pressed do
	(		
		l = LayerManager.getLayerFromName "- Splines Murs Int"
		sel = selection as array
		for s in sel do 
		(
			l.addnode s
			s.wirecolor = brown
		)
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
	
	
	-- TOOLS
	
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
	
	on createSelectionBT pressed do
	(
		format "youpi\n"
		theNodes = selection as array
		
		local mursExtAr = #()
		local mursBalconAr = #()
		local mursFondAr = #()
		local mursIntAr = #()
		
		for n in theNOdes do
		(
			if n.layer.name == "- Splines Murs Ext" then( append mursExtAr n)
			else if n.layer.name == "- Splines Murs Balcon" then( append mursBalconAr n)
			else if n.layer.name == "- Splines Murs Fond" then( append mursFondAr n)
			else if n.layer.name == "- Splines Murs Int" then( append mursIntAr n) 
		)
		
		format "mursExtAr: %, mursBalconAr: %, mursFondAr: % mursIntAr:%\n" mursExtAr mursBalconAr mursFondAr mursIntAr
		
-- 		dans la selection determiner les types de murs
		if mursExtAr.count > 0 then 	createWall theNodes  extwallHauteurSP.value  extwallEpaisseurSP.value
		else if mursBalconAr.count > 0 then 	createWall theNodes  terrassewallHauteurSP.value  terrassewallEpaisseurSP.value
		else if mursFondAr.count > 0 then 	createWall theNodes  backwallHauteurSP.value  backwallEpaisseurSP.value
		else if mursIntAr.count > 0 then 	createWall theNodes  intwallHauteurSP.value  intwallEpaisseurSP.value
	)
)

fn hideOthersLayer l =
(
	for i = 0 to (LayerManager.count - 1) do
	(
		testL = LayerManager.getLayer i
		if testL != l then testL.on = false
	)
)

rollout createGround "Créer les sols" width:350 height:230
(	
	
	local murPourSol
	
	button 'wallCreate' "fusionner les murs" across: 2 enabled: false  -- pos:[120,10] width:100 height:20 align:#left
	button 'groundInitialize' "Initialiser les sols"  -- pos:[10,10] width:100 height:20 align:#left

	
	button createGaineBT "creation des gaines" across: 2 enabled: false -- pos:[10,10] width:100 height:20 align:#left
	button createPlinteBT "creation des plintes" enabled: false 
	button 'groundFinalize' "Finaliser les sols" -- pos:[120,10] width:100 height:20 align:#left
	
	
	-- fusionne les murs
	function unifyWall  = 
	(			
			
		target = LayerManager.getLayerFromName "- Splines Murs Int"				
		target.nodes &theNodesInt		
-- 		target.on = false
			
		target = LayerManager.getLayerFromName "- Splines Murs Ext"				
		target.nodes &theNodesExt		
-- 		target.on = false
			
		target = LayerManager.getLayerFromName "- Splines Murs Fond"				
		target.nodes &theNodesFond			
-- 		target.on = false	
			
		target = LayerManager.getLayerFromName "- Splines Murs Balcon"
		target.nodes &theNodesBalc	
-- 		target.on = false	

		local theMurs = theNodesInt + theNodesExt + theNodesFond + theNodesBalc
		
-- 		fusion des murs
		local mursL = LayerManager.getLayerFromName mursLayer					
			
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
		converttopoly theObj
		
		theObj
	
	)
	
	-- création des splines pour le sol
	function extractSol = 
	(			
		-- creation de la spline des sols
		theSection = section pos:[0, 0, 0.5]		
		max views redraw
		convertToSplineShape theSection
		theSection.name =  "Sol construction"
		
		-- fusion des vertex
		format "extract sol theSection: %\n" theSection
		select theSection
		modPanel.setCurrentObject theSection.baseObject
		subobjectLevel = 1			
		for i=1 to (numSplines theSection) do
		(
			setKnotSelection theSection i #(1,numknots theSection i)
		)
		splineops.weld theSection
		updateShape theSection

		theSection
	)

		
	-- création du sol
	function actionSol =
	(			
		solL = LayerManager.getLayerFromName "+ Sols"	
		theObj = getNodeByName "Sol construction"
		
		tempLib  = undefined
		
		-- import des materiaux
		fileMat = importfolderLIB + "\\Cells_materials.mat"
		if doesfileexist fileMat then tempLib = loadTempMaterialLibrary fileMat
		
		uvwMapMod = uvwmap maptype: 4 length: 200 width: 200 height: 200
					
		-- creation des sol
		theSolLine = copy theObj
		solL.addnode theSolLine
		
		theSolLine.name = "sol"
		theSolLine.material = tempLib[2]
		
		solExtMod = extrude amount: -20 capstart: on capend: on
		addmodifier theSolLine solExtMod
		addmodifier theSolLine uvwMapMod
		
		-- creation des plintes
		thePlinteLine = copy theObj
		solL.addnode thePlinteLine
		
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
	
	fn createPlinte l =
	(
		thePlinteLine = copy l
		l.layer.addnode thePlinteLine
		
		thePlinteLine.name = "plinte"
		thePlinteLine.material = tempLib[2]
		
		plinteExtMod = extrude amount: 10 capstart: off capend: off
		plinteShellMod = shell outerAmount: 0 innerAmount: 2 overrideInnerMatID: on matInnerID: 1 overrideOuterMatID: on \
		matOuterID: 1 overrideMatID: on matID: 1 autoSmoothAngle: 0 straightenCorners: on
			
		addmodifier thePlinteLine plinteExtMod
		addmodifier thePlinteLine plinteShellMod
		addmodifier thePlinteLine  (smooth ())
-- 		addmodifier thePlinteLine uvwMapMod
		
		thePlinteLine
-- 		convertto thePlinteLine editable_poly
	)
	
	on wallCreate pressed  do
	(	
		-- teste le calque murs
		mursL = LayerManager.getLayerFromName mursLayer
		if mursL == undefined then mursL = LayerManager.newLayerFromName mursLayer
		
		hideOthersLayer mursL
		unifyWall()
	)
	
	on groundInitialize pressed  do
	(		
		mursL = LayerManager.getLayerFromName mursLayer
		if mursL == undefined then mursL = LayerManager.newLayerFromName mursLayer
		
		solsL = LayerManager.getLayerFromName "+ Sols"
		if solsL == undefined then solsL = LayerManager.newLayerFromName "+ Sols"
		
		mursL.current = true
		hideOthersLayer mursL
		tmpMurs = unifyWall()
		extractSol()
		delete tmpMurs
		messageBox "Supprimez la Splines du contour exterieur et les splines des gaines"
	)
	
	
	on groundFinalize pressed  do
	(		
		
		target = LayerManager.getLayerFromName "+ Sols"
		
		if target == undefined then 
		(
			LayerManager.newLayerFromName "+ Sols"
			messageBox "Veuillez Initialiser les sols en premier !"
		) 
		else 
		(			
			actionSol()	
		)	
	)
	
	on createGaineBT pressed do
	(
		splineOps.detach $
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
			for s in sel do
			(
				fenL.addnode s
				s.wirecolor = blue
				s.name = uniquename "Fline_"
			)
		)
	)
	
	on addToPorteLayerBT pressed do
	(		
		porteL = LayerManager.getLayerFromName "- Splines Portes"				
		if porteL == undefined then()
		else
		(
			sel = selection as array
			for s in sel do 
			(
				porteL.addnode s
				s.wirecolor = red
				s.name = uniquename "PLine_"
			)
		)
	)
	
	on addToPorteFenLayerBT pressed do
	(
		PFenL = LayerManager.getLayerFromName "- Splines PFenetres"	
		if PFenL == undefined then()
		else
		(
			sel = selection as array
			for s in sel do 
			(
				PFenL.addnode s
				s.wirecolor = green
				s.name = uniquename "PFline_"
			)
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
			converttopoly newP
-- 			newP.pivot = newP.center
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
			converttopoly newPF
-- 			newPF.pivot = newPF.center
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
			converttopoly newF
-- 			newF.pivot = newF.center
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
		MursL = LayerManager.getLayerFromName mursLayer
		
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
			
			-- ajout au calque murL
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

rollout cretionAptRLT "Création Appartement"
(
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
addRollout addExtWall dRolFloater rolledUp:false
-- addRollout addBackWall dRolFloater rolledUp:true
-- addRollout addIntWall dRolFloater rolledUp:true
-- addRollout finishedWall dRolFloater rolledUp:true
addRollout createGround dRolFloater rolledUp:true
addRollout openingWall dRolFloater rolledUp:false
addRollout doorFrame dRolFloater rolledUp:true
addRollout importAmbiance dRolFloater rolledUp:true

