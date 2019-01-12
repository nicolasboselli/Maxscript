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
	-- preparation percement (cf prepa_percement_sandbox.ms)
		-- rendre editable tous les objets à la construction (type de fenetre) pour en ajouter ou en supprimer (creation ou suppression de calque)
		x- ajustement des reperes de percement
			x- integrer la fonction d'ajustement directement dans le rollout de gabarit
			-- debug:
				-- pour qu'il s'auto aligne au mur
				x- pour qu'il fonctionne en horaire et en anti horaire (actuellement fonctionne seulement en anti horaire)
			
		-- rendre parametrable l'avant et l'apres (à editer lorsqu'on pourra ajouter des types de gabarit cf rebuild)
		-- rendre invisible l'operation d'ajustement des reperes de fenetres, la faire executer à la creation des gabarits
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

-- global cellRoot = @"M:\Interieur\Cellules\"
global cellRoot = @"J:\_svn\zz_ressources3D\Cellules\"

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
global splinesMursExtLName =  "_Splines Murs Ext"
global splinesMursBalconLName = "_Splines Murs Terrasses" 
global splinesMursFondLName = "_Splines Murs Fond"
global splinesMursIntName = "_Splines Murs Interieurs"

global SplinesFenetresLName = "__Splines Fenetres"
global SplinesPFenetresLName = "__Splines PFenetres"
global SplinesPortesLName = "__Splines Portes"

 global TmpFenLName = "___Gabarits Fenetres"
 global TmpPFenLName = "___Gabarits PFenetres"
 global TmpPortesLName  =  "___Gabarits Portes"

global solsPrepaLname = "____ Sol construction"

global solsLname = "Sol"
global AptLName  = "Appartement"



-- Preparation des calques de travail
function createWorkLayer = 
(	
-- 	layerList = #( splinesMursExtLName, 
-- 		splinesMursBalconLName ,
-- 		splinesMursFondLName ,
-- 		splinesMursIntName ,
-- 		SplinesFenetresLName ,
-- 		SplinesPFenetresLName ,
-- 		SplinesPortesLName
-- 	)
	
	layerList = #( SplinesFenetresLName ,
		SplinesPFenetresLName ,
		SplinesPortesLName
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

filein "adjust_gabarit.ms" -- quiet: true

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
		createWorkLayer()
		
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
	
fn createWall oneArray hauteur epaisseur =
(
	extMod = Extrude amount: hauteur capStart: off capEnd: off
	shellMod = Shell outerAmount: 0.0 innerAmount: epaisseur	overrideInnerMatID: on	 matInnerID: 2 overrideOuterMatID: on matOuterID: 1 \
	overrideMatID: on matID: 3 autoSmoothAngle: 0 straightenCorners: on
	uvwMapMod = Uvwmap maptype: 4 length: 150 width: 150 height: 150
		
	for obj in oneArray  do 
	( 
		-- nettoyage de la spline
		local modcount = obj.modifiers.count
		for i = 1 to modCount do deletemodifier obj 1
		
		-- creation du mur
		addmodifier obj extMod
		addmodifier obj shellMod
		addmodifier obj uvwMapMod
		
-- 			format "mur balcon: %\n" obj.name
	)
)

rollout addExtWall "Preparation des Murs" width:350 height:230
(	
	
	local params = #("open", "extwallHauteurSP", "extwallEpaisseurSP", "terrassewallHauteurSP", "terrassewallEpaisseurSP", "backwallHauteurSP", \
		"backwallHauteurSP", "intwallHauteurSP", "intwallEpaisseurSP" )

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
		button createSelectionBT "Créer murs sur Selection" -- across: 2
-- 		checkButton hideLayerCB "\"Murs\" layers visibility toggle"
	)
	
	on addExtWall open do
	(
		loadRolloutParams addExtWall params
	)
	
	on addExtWall close do
	(
		writeRolloutParams addExtWall params
	)

	
-- 	on hideLayerCB changed state do
-- 	(
-- 		local layerList = #(splinesMursExtLName, splinesMursBalconLName, splinesMursFondLName, splinesMursIntName)
-- 		for n in layerList do
-- 		(
-- 			l = LayerManager.getLayerFromName n
-- 			if l != undefined then
-- 			(
-- 				l.on =  state
-- 			)else()
-- 		)
-- 	)
	
	on extWallLayerBT pressed do
	(		
		l = LayerManager.getLayerFromName splinesMursExtLName
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
		target = LayerManager.getLayerFromName splinesMursExtLName
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
		l = LayerManager.getLayerFromName splinesMursBalconLName
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
		target = LayerManager.getLayerFromName splinesMursBalconLName
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
		l = LayerManager.getLayerFromName splinesMursFondLName
		sel = selection as array
		for s in sel do 
		(
			l.addnode s
			s.wirecolor = yellow
		)
	)
	
	
	on backwallCreate pressed  do
	(	
		target = LayerManager.getLayerFromName splinesMursFondLName
			
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
		l = LayerManager.getLayerFromName splinesMursIntName
		sel = selection as array
		for s in sel do 
		(
			l.addnode s
			s.wirecolor = brown
		)
	)
	
	on intwallCreate pressed  do
	(	
		
		target = LayerManager.getLayerFromName splinesMursIntName
		
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
			if n.layer.name ==splinesMursExtLName then( append mursExtAr n)
			else if n.layer.name == splinesMursBalconLName then( append mursBalconAr n)
			else if n.layer.name == splinesMursFondLName then( append mursFondAr n)
			else if n.layer.name == splinesMursIntName then( append mursIntAr n) 
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
	format "hideOthersLayer: %\n" l.name
	l.on = true
	for i = 0 to (LayerManager.count - 1) do
	(
		testL = LayerManager.getLayer i
		if testL != l then testL.on = false
	)
)

fn collectGabarit =
(
	-- recuperation des blocs de gabarits sur les calques
	local nnl1 = #()
	local nnl2 = #()
	local nnl3 = #()

	-- recuperation des blocs de gabarits sur les calques
	TmpPFenL = LayerManager.getLayerFromName TmpPFenLName
	if TmpPFenL != undefined then TmpPFenL.nodes & nnl1
		
	TmpfenL = LayerManager.getLayerFromName TmpFenLName
	if TmpfenL != undefined then TmpfenL.nodes & nnl2
	
	TmpPorteL = LayerManager.getLayerFromName TmpPortesLName
	if TmpPorteL != undefined then TmpPorteL.nodes & nnl3
	
	(nnl1 + nnl2 + nnl3)
)

rollout openingWall "Preparation des percements" width:350 height:230
(	
	local params = #("open", "windowHauteurSP", "windowAllegeSP", "porteHauteurSP", "porteAllegeSP", "porteFenetreHauteurSP", "porteFenetreAllegeSP" )
		
	group "Fenêtres:"
	(
		spinner windowHauteurSP "Hauteur:" type: #worldunits range: [0,500, 215] across: 2 -- pos:[12,10] text:"135"	width:160
		spinner windowAllegeSP "Allege:" type: #worldunits range: [0.5,500, 90] -- across: 2 -- pos:[182,10] text:"90" width:150
		button addToFenLayerBT "add to layer" across: 2
		button adjustToFenBT "adjust fenêtres"
	)
	
	group "Portes:"
	(
		spinner porteHauteurSP "Hauteur:" type: #worldunits range: [0,500, 204] across: 2  -- pos:[12,35] text:"204"	width:160
		spinner porteAllegeSP "Allege:" type: #worldunits range: [0.5,500, 0.5] 
		button addToPorteLayerBT "add to layer" across: 2
		button adjustToPorteBT "adjust portes"
	)
	
	group "Porte-Fenêtres:"
	(
		spinner porteFenetreHauteurSP "Hauteur: " type: #worldunits range: [0,500, 215] across: 2  -- pos:[12,60] text:"215" width:200
		spinner porteFenetreAllegeSP "Allege: " type: #worldunits range: [0.5,500, 0.5]
		button addToPorteFenLayerBT "add to layer" across: 2
		button adjustToPorteFenetreBT "adjust portes Fenêtres"
	)
	 
	button createGabaritBT "Créer les Gabarits" -- across: 2

	
	on openingWall open do
	(
		loadRolloutParams openingWall params
	)
	
	on openingWall close do
	(
		writeRolloutParams openingWall params
	)
	
	on addToFenLayerBT pressed do
	(
		fenL = LayerManager.getLayerFromName SplinesFenetresLName	
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
	
	on adjustToFenBT pressed do
	(
		fenL = LayerManager.getLayerFromName SplinesFenetresLName	
		fenL.nodes &theNodesFenetres
		
		format "theNodesFenetres: %\n" theNodesFenetres
		for f in theNodesFenetres do
		(
			adjustGabaritSpline2 f shift1: 3 shift2: 3
		)
	)
	
	on addToPorteLayerBT pressed do
	(		
		porteL = LayerManager.getLayerFromName SplinesPortesLName				
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
	
	on adjustToPorteBT pressed do
	(
		porteL = LayerManager.getLayerFromName SplinesPortesLName	
		porteL.nodes &theNodesPortes
		
		format "theNodesPortes: %\n" theNodesPortes
		for p in theNodesPortes do
		(
			adjustGabaritSpline2 p shift1: 3 shift2: 3
		)
	)
	
	
	on addToPorteFenLayerBT pressed do
	(
		PFenL = LayerManager.getLayerFromName SplinesPFenetresLName	
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
	
	on adjustToPorteFenetreBT pressed do
	(
		PFenL = LayerManager.getLayerFromName SplinesPFenetresLName	
		PFenL.nodes &theNodesPFen
		
		format "theNodesPFen: %\n" theNodesPFen
		for pf in theNodesPFen do
		(
			adjustGabaritSpline2 pf shift1: 3 shift2: 3
		)
	)
	
	on createGabaritBT pressed do
	(
		-- creation des bloc de portes 
		porteL = LayerManager.getLayerFromName SplinesPortesLName				
		porteL.nodes &theNodesPortes	
	
		TmpPorteL = LayerManager.getLayerFromName TmpPortesLName
		if TmpPorteL == undefined then TmpPorteL = LayerManager.newLayerFromName TmpPortesLName
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
			p.pos.z = 0
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
		PFenL = LayerManager.getLayerFromName SplinesPFenetresLName				
		PFenL.nodes &theNodesPFenetres	
		
		TmpPFenL = LayerManager.getLayerFromName TmpPFenLName
		if TmpPFenL == undefined then TmpPFenL = LayerManager.newLayerFromName TmpPFenLName
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
			f.pos.z = 0
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
		fenL = LayerManager.getLayerFromName SplinesFenetresLName				
		fenL.nodes &theNodesFenetres
		
		TmpfenL = LayerManager.getLayerFromName TmpFenLName
		if TmpfenL == undefined then TmpfenL = LayerManager.newLayerFromName TmpFenLName 
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
			f.pos.z = 0
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
-- 		local MursL = LayerManager.getLayerFromName solsPrepaLname
		
		-- recuperation des blocs de gabarits sur les calques	
		nnl = collectGabarit ()
		
		-- recuperation des mur
		theMurs = #()
		MursBalL = LayerManager.getLayerFromName splinesMursBalconLName
		MursBalL.nodes &MursBal
		
		MursExtL = LayerManager.getLayerFromName splinesMursExtLName
		MursExtL.nodes &MursExt
		
		MursFondL = LayerManager.getLayerFromName splinesMursFondLName
		MursFondL.nodes &MursFond
		
		MursIntL = LayerManager.getLayerFromName splinesMursIntName
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
	)
	
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
		/*
		target = LayerManager.getLayerFromName splinesMursIntName				
		target.nodes &theNodesInt		
-- 		target.on = false
			
		target = LayerManager.getLayerFromName splinesMursExtLName				
		target.nodes &theNodesExt		
-- 		target.on = false
			
		target = LayerManager.getLayerFromName splinesMursFondLName				
		target.nodes &theNodesFond			
-- 		target.on = false	
			
-- 		target = LayerManager.getLayerFromName splinesMursBalconLName
-- 		target.nodes &theNodesBalc	
-- 		target.on = false	

		local theMurs = theNodesInt + theNodesExt + theNodesFond -- + theNodesBalc
		*/
-- 		
		local mursLayerList = collectLayer pattern: "_Splines Murs *"
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
	local nnl = collectGabarit()
	
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
	)
	
	
	on openWallBT pressed do
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
-- 			local MursL = LayerManager.getLayerFromName solsPrepaLname
			
			-- recuperation des blocs de gabarits sur les calques	
			nnl = collectGabarit ()
			
			-- recuperation des mur
			theMurs = #()
-- 			MursBalL = LayerManager.getLayerFromName splinesMursBalconLName
-- 			MursBalL.nodes &MursBal
-- 			
-- 			MursExtL = LayerManager.getLayerFromName splinesMursExtLName
-- 			MursExtL.nodes &MursExt
-- 			
-- 			MursFondL = LayerManager.getLayerFromName splinesMursFondLName
-- 			MursFondL.nodes &MursFond
-- 			
-- 			MursIntL = LayerManager.getLayerFromName splinesMursIntName
-- 			MursIntL.nodes &MursIntL
-- 			
-- 			theMursOrig = MursBal + MursExt + MursFond + MursIntL
			
			local mursLayerList = collectLayer pattern: "_Splines Murs *"
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
	local mursList = collectLayerNames pattern: "_Splines Murs *" 
	local spGabList = #(SplinesFenetresLName, SplinesPFenetresLName, SplinesPortesLName)
	local gabList = #(TmpFenLName, TmpPFenLName, TmpPortesLName)
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
		
	on hideMursCB changed state do
	(		
		hideLayers mursList state
	)
	
	on hideSplineGabaritsLayerCB changed state do
	(		
		hideLayers spGabList state
	)
	
	on hideGabaritsLayerCB changed state do
	(		
		hideLayers gabList state
	)
	
	on hidePrepaSolLayerCB changed state do
	(		
		hideLayers prepSolList state
	)
	
	on hideAptLayerCB changed state do
	(		
		hideLayers AptList state
	)
	
	on transMursCB changed state do
	(
		for l in mursList do transLayer l state
	)
	
	
)


addRollout prepareScene dRolFloater 
addRollout addPlan dRolFloater --rolledUp:true

addRollout displayRLT dRolFloater

addRollout addExtWall dRolFloater --rolledUp:false
addRollout openingWall dRolFloater --rolledUp:false

addRollout createGround dRolFloater --rolledUp:false

addRollout creationAptRLT dRolFloater --rolledUp:false

addRollout importAssetRLT dRolFloater --rolledUp:false

