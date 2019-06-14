/*
-- maj:		
-- OUTILS MURS
	-- créer un auto snap des spline de murs
	
	-- creer une spline avec l'extrude et le shell correctement configurer, dans le calque adapté
	
	-- plutot que de faire des murs de differentes hauteur, proposer de monter ou descendre les splines de la difference entre mur haut et mur bas (xform) avec un picker
		-- cf move_spline_sandbox.ms
		/- fonction pour monter et descendre la selection spline
			- changer la hauter des segments en fonction de l'id de leur id de materiau sur tout la spline
		-- picker pour retourner le segment de la spline sur laquelle on pique

-- OUTILS FENETRES
	-- bug: sur une spline fermer les reperes ne sont pas créé correctement
	-- preparation percement (cf prepa_percement_sandbox.ms)
		/- rendre editable tous les objets à la construction (type de fenetre) pour en ajouter ou en supprimer (creation ou suppression de calque)
		x- ajustement des reperes de percement
			x- integrer la fonction d'ajustement directement dans le rollout de gabarit
			-- debug:
				-- pour qu'il s'auto aligne au mur
				x- pour qu'il fonctionne en horaire et en anti horaire (actuellement fonctionne seulement en anti horaire)
			
		x- rendre parametrable l'avant et l'apres (à editer lorsqu'on pourra ajouter des types de gabarit cf rebuild)
		x- rendre invisible l'operation d'ajustement des reperes de fenetres, la faire executer à la creation des gabarits
		-- mettre le repere perpendiculaire automatique(pour les murs en biais)
		-- automatiser l'import et les placement des portes		
 
-- OUTILS SOLS
	-- créer une méthode de découpe de plane pour créer le sol afin que ce soit plus propre
	
	-- clarifier creation des sols
		-- cf multiID_sol_sandbox.ms
		-- une fois que la spline de sol est propre, ajouter un editpoly dessus et changer l'id de materiaux en fonction
			-- en fonction de l'idée de materiaux faire des actions. ex: placard(import placard)- gaines(separer et relever) - terrasses(supprimer gaines)

-- OUTILS DIVERS
	-- fonction pour placer automatiquement les lights additionnels
		-- placer les lights devant les fenetres et au dessus de chaque piece
	
	-- refléchir à des fonction pour merger du mobilier standard (toilette, vasque, baignoire, placard, cuisine, cadre) sur des repere (spline) 
		
	-- paramétrer le rendu vray et l'éclairage pour avoir un rendu plus homogène
		-- proposer un chemin d'enregistremant du rendu
	
-- dev:
	-- créé un fonction qui ramasse tous les objets présents sur les calque de construction
	-- utiliser l'appartenance à un calque comme un tag pour traiter l'objet à la construction
	
	-- associer un objet à merger avec un repere
	-- memoriser les configuration pour tout un projet
	
-- arbo:
	-- mettre toutes les ressources utilisees par le script
			-- fichier max light et cam
			-- fichier light additive
			-- preset passe
			-- material library et map associé
			-- fichier asset standard: max porte interieure, porte entree, porte placard, placard
	
*/

------------ DECLARATION DES VARIABLES ----------------------



-- filein @"N:/Ressources_Nico/github/00_wip/Maxscript/cellsCreator/001/adjust_gabarit.ms"
-- toto()

global countPlan = 0
global planFile = undefined

global objectReplacerTool = getroot() + "objReplacer/002/obj_replacer.ms"
global resizerTool = getroot() + "plansManagement/Plan_resizer.ms"
global cleanSplineTool = getroot() + "MODELING_TOOLS/001/cleanSpline.ms"

filein cleanSplineTool

global cellRoot = @"M:\Interieur\Cellules\"
-- global cellRoot = @"J:\_svn\zz_ressources3D\Cellules\"

global importfolderFEN = "M:\\Interieur\\Cellules\\Modelisation\\Fenetres\\"
global importfolderPOR = "M:\\Interieur\\Cellules\\Modelisation\\Portes\\"
-- global importfolderCAM = "M:\\Interieur\\Cellules\\Modelisation\\CamLights\\"
-- global importfolderCAM = @"M:\Elements_batiments\Light\"
global importfolderCAM = @"M:\Light\"
global importfolderPST = "M:\\Interieur\\Cellules\\Modelisation\\Presets\\"
global importfolderVray = "M:\\Interieur\\Cellules\\Modelisation\\Vray\\"
global importfolderLIB = cellRoot + @"Modelisation\Library\"
global importfolderAMB = "M:\\Interieur\\Cellules\\Modelisation\\Ambiances\\"

global filesFEN
global filesPOR

-- try(closerolloutfloater dRolFloater) catch()

-- vars layer
global mursPrefix = "_Splines Murs "
global prepaSuf = "__Splines "
global gabSuf = "___Gabarits "
global decSuf = "____Decoupes "

global solsPrepaLname = "____ Sol construction"

global solsLname = "Sol"
global AptLName  = "Appartement"

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

filein "adjust_gabarit.ms" -- quiet: true


-- find vray
fn findVray  =
(
	local goodR
	for r in rendererClass.classes do
	(
-- 		format "r: %\n" r
		if matchPattern  (r as string)  pattern: "V_Ray_Adv*" then
		(
			goodR = r
			exit
		)
		else if matchPattern  (r as string)  pattern: "V_Ray_Next*" then
		(
			goodR = r
			exit
		)
		else()
	)
-- 	format "good r: %\n" goodR
	 goodR
)


fn collectLayer pattern: "*" =
(
	local layerFoundAr = #()
	for i = 0 to  (LayerManager.count - 1) do
	(
		l = LayerManager.getLayer i
		
		if  matchpattern l.name pattern: pattern then
		(
			append layerFoundAr l
-- 			"l.name: %\n" l.name
		)
	)
	layerFoundAr
)

try(closeRolloutFloater  dRolFloater)catch()
dRolFloater = newRolloutFloater "Creation de plans de cellules" 350 650 80 200
-- RLTvers = getScriptVersion (getThisScriptFilename())
dRolFloater.title =  dRolFloater.title +" v." + ((getScriptVersion (getThisScriptFilename())) as string)
-- classof prepareScene.RFSIze
rollout prepareScene "Preparer le cellule" width:350 height:230
(	
-- 	local openState = false
	local RFPos = [0,0]
	local RFSIze = [300,800]
	local params = #("open", "RFPos", "RFSIze")
	
	
-- 	button initLayersBT "initialiser les calques" 
	button 'loadCamLight' "Importer CAM & Light" across: 2 -- pos:[10,10] width:120 height:20 align:#left
	button 'loadRenderPset' "Preset Rendu" -- pos:[200,10] width:120 height:20 align:#left
	
	on prepareScene open do
	(
-- 	createWorkLayer()
		
		-- pref du rollout loader à l'ouverture
		loadRolloutParams prepareScene params
		try(dRolFloater.pos =  RFPos)catch()
		try(dRolFloater.size =  RFSIze)catch()
	)
	
	on prepareScene close do
	(
		-- pref du rollout enregistrer à la fermeture
		RFPos = dRolFloater.pos
		RFSIze = dRolFloater.size
		writeRolloutParams prepareScene params
	)

	
	on loadCamLight pressed  do
	(	
		local LetCNodes = #()
		LetCL =  LayerManager.getLayerFromName "LetC"
		if LetCL == undefined then LetCL = LayerManager.newLayerFromName "LetC"
				
		f = (importfolderCAM + "light_cellules.max")		
		
		if doesfileexist f then 
		(
			local res = mergemaxfile (f) #select #autoRenameDups #useSceneMtlDups
			if res then LetCNodes = getLastMergedNodes()
		)
		else 	format "fichier de lighting introuvable: %\n" f
		
		for o in LetCNodes do
		(
			LetCL.addnode o
		)
		
		-- imposer l'angle de camera
		
	)
		
	on loadRenderPset pressed  do
	(		
		renderSceneDialog.close()
		
		-- setup vray
		renderers.current = (findvray())()
		showproperties renderers.current
		
		-- render size
		renderWidth = 4900
		renderHeight = 4165
		
		-- charge les passe
		presetFile = importfolderCAM + "passe_cellule.rps"
		if doesfileexist presetFile then
		(
			format "Import Preset file : %\n" presetFile			
			renderPresets.LoadAll 0 presetFile
		)
		
		-- parametre la gi
		-- parametre color mapping
		renderers.current.colorMapping_type = 6

		-- parametre ao
		-- parametre chemin d'enregistrement
		-- parametrer le gamma
		-- parametrer affect background
		renderers.current.colorMapping_affectBackground = false
		
		renderSceneDialog.open()
		
		-- paremetre environnement
		backgroundColor = color 255 255 255
	)
)

rollout addPlan "Preparation du plan" width:350 height:230
(	
	local params = #("open")
	
	button bmpFitBT "bitmap fit" across: 2
	button openResizerBT "resizer tool"
	
	fn ajustUVWmap onePlane= 
	(
		myUV = Uvwmap()
		myUV.length = onePlane.length
		myUv.width = onePlane.width

		addmodifier onePlane myUV	 
		
		myBitmap = onePlane.material.diffusemap.bitmap
		
		bitHeight = myBitmap.height
		bitWidth = myBitmap.width

		UVlength = myUV.length

		myUV.width = (UVlength*bitWidth)/bitHeight
	)
	
	
	on addPlan open do
	(
		loadRolloutParams addPlan params
	)
	
	on addplan close do
	(
		writeRolloutParams addPlan params
	)
	
	on openResizerBT pressed do
	(
		filein resizerTool
	)
	
	on bmpFitBT pressed do
	(
		sel = selection as array
		if sel.count == 1 do
		(
			ajustUVWmap sel[1]
			
			sel[1].name = ("plane_" + (getFilenameFile (sel[1].material.diffuseMap.filename))) 
			local LM = layermanager
			local lay 
				
			if (LM.getLayerFromName "plans") == undefined then lay = LM.newLayerFromName "plans"
			else lay = LM.getLayerFromName "plans"
				
			lay.addnode sel[1]
			
			sel[1].renderable = off
			sel[1].backfacecull = on
		)
	)
)

filein "config_rlt.ms"
filein "prepa_mur_rlt.ms" -- quiet: true
filein "prepa_percement_rlt.ms" -- quiet: true

fn hideOthersLayer l =
(
	format "hideOthersLayer: %\n" l.name
	l.on = true
	for i = 0 to (LayerManager.count - 1) do
	(
		testL = LayerManager.getLayer i
		if testL != l then testL.on = false
	)
)

fn collectLayer pattern: "*" =
(
	local layerFoundAr = #()
	for i = 0 to  (LayerManager.count - 1) do
	(
		l = LayerManager.getLayer i
		
		if  matchpattern l.name pattern: pattern then
		(
			append layerFoundAr l
-- 			"l.name: %\n" l.name
		)
	)
	layerFoundAr
)

fn rafle layerList: #() =
(
	local all = #()
	for l in layerList do
	(
-- 		format "l.name: %\n" l.name
		local tmp
		l.nodes &tmp
-- 		format "tmp: %\n" tmp
		for o in tmp do append all o
	)
	all
)

fn collectGabarit2 onePattern =
(
	local lAr = collectLayer pattern: onePattern
	local allGab = rafle layerList: lAr
	allGab
)

fn createPlinte l =
(
-- 	thePlinteLine = copy l
	l.layer.addnode l
	
	l.name = "plinte_construction"
-- 		thePlinteLine.material = tempLib[2]
	uvwMapMod = uvwmap maptype: 4 length: 200 width: 200 height: 200
	plinteExtMod = extrude amount: 10 capstart: off capend: off
	plinteShellMod = shell outerAmount: 0 innerAmount: 2 overrideInnerMatID: on matInnerID: 1 overrideOuterMatID: on \
	matOuterID: 1 overrideMatID: on matID: 1 autoSmoothAngle: 0 straightenCorners: on
		
	addmodifier l plinteExtMod
	addmodifier l plinteShellMod
	addmodifier l  (smooth ())
	addmodifier l uvwMapMod
	
	l
-- 		convertto thePlinteLine editable_poly
)

rollout createGround "Preparation des sols" width:350 height:230
(	
	local params = #("open")
	local murPourSol
	
	button 'wallCreate' "fusionner les murs" across: 2  enabled: false  -- pos:[120,10] width:100 height:20 align:#left
	button 'groundInitialize' "Initialiser les sols"  -- pos:[10,10] width:100 height:20 align:#left

	button createGaineBT "creation des gaines" across: 2 enabled: false -- pos:[10,10] width:100 height:20 align:#left
	button createPlinteBT "preparation des plintes" -- enabled: false 
		
	group "tools"
	(
		button cleanSplineBT "Clean Spline" -- across: 2
	)
	
	-- fusionne les murs
	function unifyWall2  = 
	(			

		local mursLayerList = collectLayer pattern: (mursPrefix + "*")
		local theMurs = #()
		for l in mursLayerList do 
		(
			l.nodes &tmpAr
			for t in tmpAr do append theMurs t
		)
		
-- 		fusion des murs
		local solPrepaL = LayerManager.getLayerFromName solsPrepaLname					
			
		theObj = (editable_mesh())
		solPrepaL.addnode theObj
		
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
		theSection.name =  "Sol_construction"
		
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

	on createGround open do
	(
		loadRolloutParams createGround params
	)
	
	on createGround close do
	(
		writeRolloutParams createGround params
	)
	
	on wallCreate pressed  do
	(	
		-- teste le calque murs
		local solPrepaL = LayerManager.getLayerFromName solsPrepaLname
		if solPrepaL == undefined then solPrepaL = LayerManager.newLayerFromName solsPrepaLname
		
		unifyWall2()
	)
	
	on groundInitialize pressed  do
	(		
		-- todo: faire la section que sur les murs
		local solPrepaL = LayerManager.getLayerFromName solsPrepaLname
		if solPrepaL == undefined then solPrepaL = LayerManager.newLayerFromName solsPrepaLname
		
		solsL = LayerManager.getLayerFromName solsLname
		if solsL == undefined then solsL = LayerManager.newLayerFromName solsLname
		
		local oldSol = $Sol_construction
		if isvalidnode oldSol then delete oldSol
		
		bakL = LayerManager.current
		solPrepaL.on = true
		solPrepaL.current = true
		
		hideOthersLayer solPrepaL
		tmpMurs = unifyWall2()
		extractSol()
		bakL.current = true
		
		delete tmpMurs
-- 		messageBox "Supprimez la Splines du contour exterieur et les splines des gaines"
	)
	
	on createGaineBT pressed do
	(
		-- supprimer la gaine existante s il y a lieu
		-- extraire la spline selectionner
		-- la renommer en "gaines_construction"
		
		theGaine = $gaines_construction
		
		if theGaine == undefined then()
		else if isvalidnode theGaine then
		(
-- 			addmodifier theGaine (edit_poly())
-- 			move theGaine [0,0,120]
			splineOps.detach $
		)
		else()
	)
	
	on createPlinteBT pressed do
	(
		thePlinte = $plinte_construction
		if isvalidnode thePlinte then delete thePlinte
		
		solSpline = $Sol_construction
		
		if solSpline == undefined then()
		else if isvalidnode solSpline then
		(
			thePlinte = copy solSpline
			solSpline.layer.addnode thePlinte
			
			createPlinte thePlinte
		)
		else()
	)
	
	on cleanSplineBT pressed do
	(
		filein cleanSplineTool
		sel = selection as array
		for s in sel do cleanspline s
	)
)

fn createSol l =
(
	local tempLib
	
	fileMat = importfolderLIB + "\\Cells_materials.mat"
	if doesfileexist fileMat then tempLib = loadTempMaterialLibrary fileMat
	
	l.material = tempLib[2]
	
	uvwMapMod = uvwmap maptype: 4 length: 200 width: 200 height: 200
	solExtMod = extrude amount: -20 capstart: on capend: on
		
	addmodifier l solExtMod
	addmodifier l uvwMapMod
)

fn openPlinte p =
(
	local tempLib
	
	fileMat = importfolderLIB + "\\Cells_materials.mat"
	if doesfileexist fileMat then tempLib = loadTempMaterialLibrary fileMat
	
	p.material = tempLib[2]
	
	-- collect des gabarits
	local nnl = collectGabarit2 (decSuf + "*")
	
	-- booleans
	if isvalidnode p then
	(
		if nnl.count > 0 then (for obj in nnl  do ( p - obj))
	)
)

rollout creationAptRLT "Création Appartement"
(
	local params = #("open")
	
	button openPlinteBT "ouverture des plintes" across: 2 enabled: false -- enabled: false -- pos:[10,10] width:100 height:20 align:#left
	button createSolBT  "creation du sol" -- enabled: false 
	
	button createGaineBT "creation des gaines"  across: 2 enabled: false
-- 	button createSolBT "creation des sol" across: 2
	button openWallBT "ouverture des murs"
		
	on creationAptRLT open do
	(
		loadRolloutParams creationAptRLT params
	)
	
	on creationAptRLT close do
	(
		writeRolloutParams creationAptRLT params
	)
	
	on openPlinteBT pressed do
	(
		solsL = LayerManager.getLayerFromName solsLname
		if solsL == undefined then solsL = LayerManager.newLayerFromName solsLname
		
		plinteToOpen = $plinte
		if isvalidnode plinteToOpen then delete plinteToOpen
		
		thePlinte = $plinte_construction
		
		if thePlinte == undefined then()
		else if isvalidnode thePlinte then
		(
			plinteToOpen = copy thePlinte
			plinteToOpen.name = "plinte"
			solsL.addnode plinteToOpen
			
			openPlinte plinteToOpen			
		)
		else()
	)
	
	on createGaineBT pressed do
	(
		solsL = LayerManager.getLayerFromName solsLname
		if solsL == undefined then solsL = LayerManager.newLayerFromName solsLname
		
		theGaine = $gaines
		if isvalidnode theGaine then delete theGaine
		
		theGaineConst = $gaines_construction

		if theGaineConst == undefined then()
		else if isvalidnode theGaineConst then
		(
			theGaineCopy = copy theGaineConst
			theGaineCopy.name = "gaines"
			solsL.addnode theGaineCopy
			
			addmodifier theGaineCopy (edit_poly())
			move theGaineCopy [0,0,105]
		)
	)
	
	on createSolBT pressed do
	(
		format "start sol creation\n"
		solsL = LayerManager.getLayerFromName solsLname
		if solsL == undefined then solsL = LayerManager.newLayerFromName solsLname
-- 		hideOthersLayer solsL
		
		openPlinteBT.pressed()
		createGaineBT.pressed()
		
		
		solMesh = $sol
		if isvalidnode solMesh then delete solMesh 
		
		solSpline = $Sol_construction
		
		if solSpline == undefined then ()
		else if isvalidnode solSpline then
		(
			solToFinish = copy solSpline
			solToFinish.name = "sol"
			solsL.addnode solToFinish
			
			createSol solToFinish
		)
		else()
		format "end sol creation\n"
	)
	
	
	on openWallBT pressed do
	(
		
			-- ouverture des murs
			--  creation et nettoyage du calque appartement
			AptL = LayerManager.getLayerFromName AptLName
			if AptL == undefined then AptL = LayerManager.newLayerFromName AptLName
			else
			(
				AptL.nodes &tmpAptNodes
				delete tmpAptNodes
			)
			
			-- creation des blocs de decoupes
			prepaPercementRLT.createDecoupeBT.pressed()
			
			-- recuperation des blocs de decoupe sur les calques	
			nnl = collectGabarit2 (decSuf + "*")
			
			--x maj: au lieu d'utiliser les gabarits de fenetre on créé des gabarts avec 3cm de debord
				-- deplacer dans percement
			nnl2 =#()
			-- recuperation des mur
-- 			local theMurs = #()
			
			local mursLayerList = collectLayer pattern: (mursPrefix +  "*")
			local theMursOrig = #()
			for l in mursLayerList do 
			(
				l.nodes &tmpAr
				for t in tmpAr do append theMursOrig t
			)
				
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
				
				-- ajout au calque appart
				AptL.addnode newM
				
				-- ajout du materiaux
				if tempLib != undefined then newM.material = tempLib[1]

				-- ajout de smooth
				addmodifier newM (smooth())
				
				-- ajout du murs aux objets à decouper
-- 				append theMurs newM			
			)
			
			-- cachage des murs fusionner
			MurOrig = getNodeByName "Murs"
			if isvalidnode MurOrig then MurOrig.ishidden = true
	)
	
)

rollout importAssetRLT "import assets"
(
	/*
	todo:
		-- créer les fonctions pour manager une liste d'asset en dur et relatifs à un repertoire
	*/
	local params = #("open")
	
	local assetsList = #((cellRoot + @"Modelisation\Library\Objects\portes.max"),
	(cellRoot + @"Modelisation\Library\Objects\additive_lights.max"),
	@"M:\Elements_batiments\Fenetres\exterieur\pack_fenetres_V3.max"
	)
	
	group "asset list"
	(
		multilistbox assetMLB "assets:"
		button importBT "import"
	)
	
	group "asset tool"
	(
		button addSliceBT "add slice" across: 2 -- enabled: false
		button objRepBT "objects replacer" -- enabled: false
	)
	
	
	fn refreshUI =
	(
		assetMLB.items = for a in assetsList collect getFilenameFile a
	)
	
	on importAssetRLT open do
	(
		refreshUI()
		loadRolloutParams importAssetRLT params
	)
	
	on importAssetRLT close do
	(
		writeRolloutParams importAssetRLT params
	)
	
	on importBT pressed do
	(
-- 		format "sel: %\n" assetMLB.selection
		for i in assetMLB.selection do
		(
			format "sel: %\n" assetsList[i]
			if doesfileexist assetsList[i] then 
			(
				local befCount = objects.count
				mergemaxfile assetsList[i] #select
-- 				clearselection()
-- 				for i = (befCount + 1) to objects.count do selectmore objects[i]
			)
		)
	)
	
	on addSliceBT pressed do
	(
		local capOk = false
		local sliceOk = false
		
		sel = selection as array
		for s in sel do
		(

			
			-- active modifier
			for m in s.modifiers do
			(
				if classof m == Cap_Holes then
				(
					format "%\n" m
					m.enabled = true
					capOk = true
				)
				else if classof m == sliceModifier then
				(
					m.enabled = true
					sliceOk = true
				)
				else()
			)
		)
		
		--add modifier
		if not sliceOk then 
		(
			m = (SliceModifier slice_type: 2)
			modPanel.addModToSelection m ui:on
			m.slice_plane.position.z = in coordsys world 0
			modPanel.addModToSelection (Cap_Holes ()) ui:on			
		)
	)
	
	on objRepBT pressed do
	(
		filein objectReplacerTool
	)
)

rollout displayRLT "display"
(
-- 	local mursList = #(splinesMursExtLName, splinesMursBalconLName, splinesMursFondLName, splinesMursIntName)
	
	local params = #("open")
	
	local mursList 
	local spGabList 
	local gabList 
	
-- 	local spGabList = #(SplinesFenetresLName, SplinesPFenetresLName, SplinesPortesLName)
-- 	local gabList = #(TmpFenLName, TmpPFenLName, TmpPortesLName)
	local prepSolList = #(solsPrepaLname)
	local AptList = #(solsLname, AptLName)
	

	
	group "hide/unhidde"
	(
		checkButton hideMursCB "Prepa Murs" across: 3
		checkButton hideSplineGabaritsLayerCB "Prepa Gabarits" 
		checkButton hideGabaritsLayerCB "Gabarits" 
		checkbutton hidePrepaSolLayerCB "Prepa Sols" across: 2
		checkbutton hideAptLayerCB "Appartement"
	)
	
	group "transparence"
	(
		checkButton transMursCB "Transparence Murs" -- across: 3
	)
	
	fn hideLayers layerList state = 
	(
		for n in layerList do
		(
			l = LayerManager.getLayerFromName n
			if l != undefined then
			(
				l.on = state
			)else()
		)
	)
	
	fn transLayer n state =
	(
		l = LayerManager.getLayerFromName n
		l.nodes &mursNodes
		format "mursNodes: %\n" mursNodes
		for m in mursNodes do
		(
			m.xray = state
		) 
	)
	
	fn collectList =
	(
		
		mursList = collectLayerNames pattern: (mursPrefix + "*") 
		spGabList = collectLayerNames pattern: (prepaSuf + "*") 
		gabList = collectLayerNames pattern: (gabSuf + "*") 
	)
	
	
	on displayRLT open do
	(
		collectList()
		loadRolloutParams displayRLT params
	)
	
	on displayRLT close do
	(
		writeRolloutParams displayRLT params
	)
		
	on hideMursCB changed state do
	(		
		collectList()
		hideLayers mursList state
	)
	
	on hideSplineGabaritsLayerCB changed state do
	(	
		collectList()		
		hideLayers spGabList state
	)
	
	on hideGabaritsLayerCB changed state do
	(	
		collectList()
		hideLayers gabList state
	)
	
	on hidePrepaSolLayerCB changed state do
	(	
		collectList()
		hideLayers prepSolList state
	)
	
	on hideAptLayerCB changed state do
	(		
		collectList()
		hideLayers AptList state
	)
	
	on transMursCB changed state do
	(
		collectList()
		for l in mursList do transLayer l state
	)
	
)

addRollout addPlan dRolFloater --rolledUp:true
addRollout prepareScene dRolFloater 


addRollout displayRLT dRolFloater

addRollout savePrefRLT dRolFloater 
-- addRollout addExtWall dRolFloater --rolledUp:false
addRollout prepaMursRLT dRolFloater 

-- addRollout openingWall dRolFloater --rolledUp:false
addRollout prepaPercementRLT dRolFloater

addRollout createGround dRolFloater --rolledUp:false

addRollout creationAptRLT dRolFloater --rolledUp:false

addRollout importAssetRLT dRolFloater --rolledUp:false

