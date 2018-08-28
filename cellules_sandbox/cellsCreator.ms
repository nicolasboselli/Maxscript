------------ DECLARATION DES VARIABLES ----------------------

global countPlan = 0
global planFile = undefined

global importfolderFEN = "M:\\Interieur\\Cellules\\Modelisation\\Fenetres\\"
global importfolderPOR = "M:\\Interieur\\Cellules\\Modelisation\\Portes\\"
global importfolderCAM = "M:\\Interieur\\Cellules\\Modelisation\\CamLights\\"
global importfolderPST = "M:\\Interieur\\Cellules\\Modelisation\\Presets\\"
global importfolderVray = "M:\\Interieur\\Cellules\\Modelisation\\Vray\\"
global importfolderLIB = "M:\\Interieur\\Cellules\\Modelisation\\Library\\"
global importfolderAMB = "M:\\Interieur\\Cellules\\Modelisation\\Ambiances\\"
global importfolderOBJ = "M:\\Interieur\\Cellules\\Modelisation\\Library\\Objects\\"

global filesFEN
global filesPOR
global filesOBJ

fileingamma = 2.2
fileoutgamma = 1.0

global vr = renderers.current

-- showproperties vr

vr.system_embree_on = true
vr.system_embree_conserveMemory  = true

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

rollout prepareScene "Preparer le cellule" width:350 height:230
(		
	button 'loadCamLight' "Ajouter CAM & Light" pos:[10,10] width:120 height:20 align:#left
	button 'loadRenderPset' "Preset Rendu" pos:[200,10] width:120 height:20 align:#left
	
	on loadCamLight pressed  do
	(			
		
		filesCam = getFiles (importfolderCAM + "\\light_cellules.max")	
		
		for f in filesCam collect ( 
			format "Merge file : %\n" f
			mergemaxfile (f) #select #autoRenameDups #useSceneMtlDups
		)
		
	)
	
	on loadRenderPset pressed  do
	(			
		
		filesPst = getFiles (importfolderPST + "\\passes_cellule.rps")	
		
		for f in filesPst collect ( 
			format "Import Preset file : %\n" f			
			renderPresets.LoadAll 0 (f)
		)
		
		filesVray = getFiles (importfolderVray + "\\Correction_Couleur.vccglb")	
		
		for f in filesVray collect ( 
			format "Import Vray Preset file : %\n" f			
			vfbControl #loadglobalccpreset f		
		
			vr.system_embree_on = true
			vr.system_embree_conserveMemory  = true
		)
		
		vr.system_embree_on = true
		vr.system_embree_conserveMemory  = true
		
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
				
		vr.system_embree_on = true
		vr.system_embree_conserveMemory  = true
		
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

rollout addExtWall "Ajouter les murs Exterieurs" width:350 height:230
(	
	edittext 'extwallHauteur' "Hauteur murExt (cm) : " pos:[10,10] text:"100"	width:160
	edittext 'extwallEpaisseur' "Epaisseur murExt (cm) : " pos:[175,10] text:"34" width:160
	edittext 'terrassewallHauteur' "Hauteur murTer (cm) : " pos:[10,35] text:"80"	width:160
	edittext 'terrassewallEpaisseur' "Epaisseur murTer (cm) : " pos:[175,35] text:"20" width:160
	button 'extwallCreate' "Créer les murExt" pos:[120,60] width:100 height:20 align:#left
	button 'extwallInverser' "Inverser les murExt" pos:[10,60] width:100 height:20 align:#left	
	button 'extwallUpdate' "MàJ des murExt" pos:[230,60] width:100 height:20 align:#left	
		
	on extwallInverser pressed  do
	(	
		
		target = LayerManager.getLayerFromName "- Splines Murs Ext"
			
			if target == undefined then (
				messageBox "Pour créer les mur Exterieur vous devez 'Préparer murExt'"
			) else (
				clearSelection()
				target.nodes &theNodes
				select theNodes
				
				for obj in theNodes  do ( -- this creates a collection of all objects					
					modPanel.setCurrentObject obj.baseObject
					subobjectLevel = 1
					for i=1 to (numSplines obj) do (
						setKnotSelection obj i #(numknots obj i)
					)
					splineOps.makeFirst obj
					subobjectLevel = 0
				)
							
			)
		
	)
	
	on extwallCreate pressed  do
	(	
		
		vr.system_embree_on = true
		vr.system_embree_conserveMemory  = true
		
		target = LayerManager.getLayerFromName "- Splines Murs Ext"
			
			if target == undefined then (
				messageBox "Pour créer les mur Exterieur vous devez 'Préparer murExt'"
			) else (
				clearSelection()
				target.nodes &theNodes
				select theNodes
				modPanel.addModToSelection(Extrude()) ui:on
				modPanel.addModToSelection(Shell()) ui:on
				modPanel.addModToSelection (Uvwmap ()) ui:on
				for obj in theNodes  do ( 
					obj.modifiers[#Extrude].amount = extwallHauteur.text as float
					obj.modifiers[#Extrude].capStart = off
					obj.modifiers[#Extrude].capEnd = off
					obj.modifiers[#Shell].outerAmount = 0 as integer
					obj.modifiers[#Shell].innerAmount = extwallEpaisseur.text as float					
					obj.modifiers[#Shell].overrideInnerMatID = on					
					obj.modifiers[#Shell].matInnerID = 2
					obj.modifiers[#Shell].overrideOuterMatID = on					
					obj.modifiers[#Shell].matOuterID = 1
					obj.modifiers[#Shell].overrideMatID = on					
					obj.modifiers[#Shell].matID = 3
					obj.modifiers[#Shell].autoSmoothAngle = 0
					obj.modifiers[#Shell].straightenCorners = on
					obj.modifiers[#UVW_Map].maptype = 4
					obj.modifiers[#UVW_Map].length = 150
					obj.modifiers[#UVW_Map].width = 150
					obj.modifiers[#UVW_Map].height = 150
				)
				
				target = LayerManager.getLayerFromName "- Splines Murs Balcon"
				clearSelection()
				target.nodes &theNodes
				select theNodes
				modPanel.addModToSelection(Extrude()) ui:on
				modPanel.addModToSelection(Shell()) ui:on
				modPanel.addModToSelection (Uvwmap ()) ui:on
				for obj in theNodes  do ( 
					obj.modifiers[#Extrude].amount = terrassewallHauteur.text as float
					obj.modifiers[#Extrude].capStart = off
					obj.modifiers[#Extrude].capEnd = off
					obj.modifiers[#Shell].outerAmount = 0 as integer
					obj.modifiers[#Shell].innerAmount = terrassewallEpaisseur.text as float					
					obj.modifiers[#Shell].overrideInnerMatID = on					
					obj.modifiers[#Shell].matInnerID = 2
					obj.modifiers[#Shell].overrideOuterMatID = on					
					obj.modifiers[#Shell].matOuterID = 1
					obj.modifiers[#Shell].overrideMatID = on					
					obj.modifiers[#Shell].matID = 3
					obj.modifiers[#Shell].autoSmoothAngle = 0
					obj.modifiers[#Shell].straightenCorners = on
					obj.modifiers[#UVW_Map].maptype = 4
					obj.modifiers[#UVW_Map].length = 150
					obj.modifiers[#UVW_Map].width = 150
					obj.modifiers[#UVW_Map].height = 150
				)
			)
			
	)
	
	on extwallUpdate pressed  do
	(	
		
		target = LayerManager.getLayerFromName "- Splines Murs Ext"
			
			if target == undefined then (
				messageBox "Pour créer les mur Exterieur vous devez 'Préparer murExt'"
			) else (
				clearSelection()
				target.nodes &theNodes
				select theNodes
				for obj in theNodes  do ( 
					obj.modifiers[#Extrude].amount = extwallHauteur.text as integer
					obj.modifiers[#Shell].innerAmount = extwallEpaisseur.text as integer	
				)
				
				target = LayerManager.getLayerFromName "- Splines Murs Balcon"
				clearSelection()
				target.nodes &theNodes
				select theNodes
				for obj in theNodes  do ( 
					obj.modifiers[#Extrude].amount = terrassewallHauteur.text as float
					obj.modifiers[#Shell].innerAmount = terrassewallEpaisseur.text as float	
				)
			)
			
	)
)

rollout addBackWall "Ajouter les murs du Fonds" width:350 height:230
(	
	edittext 'backwallHauteur' "Hauteur murFond (cm) : " pos:[12,10] text:"250"	width:200
	edittext 'backwallEpaisseur' "Epaisseur murFond (cm) : " pos:[12,35] text:"20" width:200
	button 'backwallCreate' "Créer les murFond" pos:[120,60] width:100 height:20 align:#left
	button 'backwallInverser' "Inverser les murFond" pos:[10,60] width:100 height:20 align:#left	
	button 'backwallUpdate' "MàJ des murFond" pos:[230,60] width:100 height:20 align:#left	
	
	
	on backwallInverser pressed  do
	(	
		
		target = LayerManager.getLayerFromName "- Splines Murs Fond"
			
			if target == undefined then (
				messageBox "Pour créer les mur du Fond vous devez 'Préparer murFond'"
			) else (
				clearSelection()
				target.nodes &theNodes
				select theNodes
				
				for obj in theNodes  do ( -- this creates a collection of all objects					
					modPanel.setCurrentObject obj.baseObject
					subobjectLevel = 1
					for i=1 to (numSplines obj) do (
						setKnotSelection obj i #(numknots obj i)
					)
					splineOps.makeFirst obj
					subobjectLevel = 0
				)
								
			)
		
	)
	
	on backwallCreate pressed  do
	(	
		
		vr.system_embree_on = true
		vr.system_embree_conserveMemory  = true
		
		target = LayerManager.getLayerFromName "- Splines Murs Fond"
			
			if target == undefined then (
				messageBox "Pour créer les mur du Fond vous devez 'Préparer murFond'"
			) else (
				clearSelection()
				target.nodes &theNodes
				select theNodes
				modPanel.addModToSelection(Extrude()) ui:on
				modPanel.addModToSelection(Shell()) ui:on					
				modPanel.addModToSelection (Uvwmap ()) ui:on
				for obj in theNodes  do ( 
					obj.modifiers[#Extrude].amount = backwallHauteur.text as integer
					obj.modifiers[#Extrude].capStart = off
					obj.modifiers[#Extrude].capEnd = off
					obj.modifiers[#Shell].outerAmount = 0 as integer
					obj.modifiers[#Shell].innerAmount = backwallEpaisseur.text as integer					
					obj.modifiers[#Shell].overrideInnerMatID = on					
					obj.modifiers[#Shell].matInnerID = 2
					obj.modifiers[#Shell].overrideOuterMatID = on					
					obj.modifiers[#Shell].matOuterID = 2
					obj.modifiers[#Shell].overrideMatID = on					
					obj.modifiers[#Shell].matID = 3
					obj.modifiers[#Shell].autoSmoothAngle = 0
					obj.modifiers[#Shell].straightenCorners = on
					obj.modifiers[#UVW_Map].maptype = 4
					obj.modifiers[#UVW_Map].length = 150
					obj.modifiers[#UVW_Map].width = 150
					obj.modifiers[#UVW_Map].height = 150
				)
			)
			
	)
	
	on backwallUpdate pressed  do
	(	
		
		target = LayerManager.getLayerFromName "- Splines Murs Fond"
			
			if target == undefined then (
				messageBox "Pour créer les mur du Fond vous devez 'Préparer murFond'"
			) else (
				clearSelection()
				target.nodes &theNodes
				select theNodes
				for obj in theNodes  do ( 
					obj.modifiers[#Extrude].amount = backwallHauteur.text as integer
					obj.modifiers[#Shell].innerAmount = backwallEpaisseur.text as integer	
				)
			)
			
	)
)

rollout addIntWall "Ajouter les murs Interieurs" width:350 height:230
(		
	edittext 'intwallHauteur' "Hauteur murInt (cm) : " pos:[12,10] text:"100"	width:200
	edittext 'intwallEpaisseur' "Epaisseur murInt (cm) : " pos:[12,35] text:"7" width:200
	button 'intwallCreate' "Créer les murInt" pos:[120,60] width:100 height:20 align:#left
	button 'intwallInverser' "Inverser les murInt" pos:[10,60] width:100 height:20 align:#left	
	button 'intwallUpdate' "MàJ des murInt" pos:[230,60] width:100 height:20 align:#left	
	
	on intwallInverser pressed  do
	(	
		
		target = LayerManager.getLayerFromName "- Splines Murs Int"
			
			if target == undefined then (
				messageBox "Pour créer les mur Interieur vous devez 'Préparer murInt'"
			) else (
				clearSelection()
				target.nodes &theNodes
				select theNodes
				
				for obj in theNodes  do ( -- this creates a collection of all objects					
					modPanel.setCurrentObject obj.baseObject
					subobjectLevel = 1
					for i=1 to (numSplines obj) do (
						setKnotSelection obj i #(numknots obj i)
					)
					splineOps.makeFirst obj
					subobjectLevel = 0
				)
								
			)
		
	)
	
	on intwallCreate pressed  do
	(	
		
		vr.system_embree_on = true
		vr.system_embree_conserveMemory  = true
		
		target = LayerManager.getLayerFromName "- Splines Murs Int"
			
			if target == undefined then (
				messageBox "Pour créer les mur Interieurs vous devez 'Préparer murInt'"
			) else (
				clearSelection()
				target.nodes &theNodes
				select theNodes
				modPanel.addModToSelection(Extrude()) ui:on
				modPanel.addModToSelection(Shell()) ui:on
				modPanel.addModToSelection (Uvwmap ()) ui:on
				for obj in theNodes  do ( 
					obj.modifiers[#Extrude].amount = (intwallHauteur.text as integer +1)
					obj.modifiers[#Extrude].capStart = off
					obj.modifiers[#Extrude].capEnd = off
					obj.modifiers[#Shell].outerAmount = 0 as integer
					obj.modifiers[#Shell].innerAmount = intwallEpaisseur.text as integer					
					obj.modifiers[#Shell].overrideInnerMatID = on					
					obj.modifiers[#Shell].matInnerID = 2
					obj.modifiers[#Shell].overrideOuterMatID = on					
					obj.modifiers[#Shell].matOuterID = 2
					obj.modifiers[#Shell].overrideMatID = on					
					obj.modifiers[#Shell].matID = 2
					obj.modifiers[#Shell].autoSmoothAngle = 0
					obj.modifiers[#Shell].straightenCorners = on
					obj.modifiers[#UVW_Map].maptype = 4
					obj.modifiers[#UVW_Map].length = 150
					obj.modifiers[#UVW_Map].width = 150
					obj.modifiers[#UVW_Map].height = 150
				)
			)
			
	)
	
	on intwallUpdate pressed  do
	(	
		
		target = LayerManager.getLayerFromName "- Splines Murs Int"
			
			if target == undefined then (
				messageBox "Pour créer les mur Interieur vous devez 'Préparer murInt'"
			) else (
				clearSelection()
				target.nodes &theNodes
				select theNodes
				for obj in theNodes  do ( 
					obj.modifiers[#Extrude].amount = intwallHauteur.text as integer
					obj.modifiers[#Shell].innerAmount = intwallEpaisseur.text as integer	
				)
			)
			
	)
)

rollout finishedWall "Finir les murs" width:350 height:230
(		
	button 'wallCreate' "Finir les murs" pos:[120,10] width:100 height:20 align:#left
	
	on wallCreate pressed  do
	(	
		
		vr.system_embree_on = true
		vr.system_embree_conserveMemory  = true		
		
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
		
		vr.system_embree_on = true
		vr.system_embree_conserveMemory  = true	

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
		
		vr.system_embree_on = true
		vr.system_embree_conserveMemory  = true

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
	edittext 'windowHauteur' "Hauteur Fenetre (cm) : " pos:[12,10] text:"135"	width:160
	edittext 'windowAllege' "Allege fenetre (cm) : " pos:[182,10] text:"90" width:150
	edittext 'porteHauteur' "Hauteur Porte (cm) : " pos:[12,35] text:"204"	width:160
	edittext 'porteFenetreHauteur' "Hauteur Porte fenetre (cm) : " pos:[12,60] text:"215" width:200
	button 'wallOpen' "Ouvrir les murs" pos:[120,90] width:100 height:20 align:#left
	
	on wallOpen pressed  do
	(	
		
		vr.system_embree_on = true
		vr.system_embree_conserveMemory  = true
		
			clearSelection()			
			target = LayerManager.getLayerFromName "- Splines Portes"				
			target.nodes &theNodesPortes	

				select theNodesPortes
		
			maxOps.cloneNodes theNodesPortes cloneType:#copy newNodes:&nnl1 #nodialog
			select nnl1
		
				move $ [0,0,0.5]
		
				modPanel.addModToSelection(Extrude()) ui:on
				modPanel.addModToSelection (Uvwmap ()) ui:on
				for obj in nnl1  do ( 
					obj.modifiers[#Extrude].amount = porteHauteur.text as float
					obj.modifiers[#Extrude].capStart = on
					obj.modifiers[#Extrude].capEnd = on
					obj.modifiers[#UVW_Map].maptype = 4
					obj.modifiers[#UVW_Map].length = 150
					obj.modifiers[#UVW_Map].width = 150
					obj.modifiers[#UVW_Map].height = 150
				)
		
			target.on = false
			target = LayerManager.getLayerFromName "- Splines PFenetres"				
			target.nodes &theNodesPFenetres	
			
				clearSelection()
				select theNodesPFenetres
				
			maxOps.cloneNodes theNodesPFenetres cloneType:#copy newNodes:&nnl2 #nodialog
			select nnl2
				
				move $ [0,0,0.5]
				
				modPanel.addModToSelection(Extrude()) ui:on
				modPanel.addModToSelection (Uvwmap ()) ui:on
				for obj in nnl2  do ( 
					obj.modifiers[#Extrude].amount = porteFenetreHauteur.text as float
					obj.modifiers[#Extrude].capStart = on
					obj.modifiers[#Extrude].capEnd = on
					obj.modifiers[#UVW_Map].maptype = 4
					obj.modifiers[#UVW_Map].length = 150
					obj.modifiers[#UVW_Map].width = 150
					obj.modifiers[#UVW_Map].height = 150
				)
				
			target.on = false
			target = LayerManager.getLayerFromName "- Splines Fenetres"				
			target.nodes &theNodesFenetres
			
				clearSelection()
				select theNodesFenetres
				
			maxOps.cloneNodes theNodesFenetres cloneType:#copy newNodes:&nnl3 #nodialog
			select nnl3
				
				move $ [0,0,0.5]
				move $ [0,0,windowAllege.text as float]
				
				modPanel.addModToSelection(Extrude()) ui:on
				modPanel.addModToSelection (Uvwmap ()) ui:on
				for obj in nnl3  do ( 
					obj.modifiers[#Extrude].amount = windowHauteur.text as float
					obj.modifiers[#Extrude].capStart = on
					obj.modifiers[#Extrude].capEnd = on
					obj.modifiers[#UVW_Map].maptype = 4
					obj.modifiers[#UVW_Map].length = 150
					obj.modifiers[#UVW_Map].width = 150
					obj.modifiers[#UVW_Map].height = 150
				)
				
			target.on = false		
			
			theObj = getNodeByName "Murs"		
			select theObj
			
			maxOps.cloneNodes theObj cloneType:#copy newNodes:&tempObj #nodialog
				
			convertto theObj editable_mesh
				
			for obj in nnl1  do ( 
				theObj - obj
			)			
			for obj in nnl2  do ( 
				theObj - obj
			)		
			for obj in nnl3  do ( 
				theObj - obj
			)
						
			convertto theObj editable_poly	
			
			clearSelection()
			
			targetTemp = LayerManager.getLayerFromName "-- Temp Portes"
			if targetTemp == undefined then (
				LayerManager.newLayerFromName "-- Temp Portes";
				targetTemp = LayerManager.getLayerFromName "-- Temp Portes"
			)
			
			for obj in  nnl1 do (
				maxOps.cloneNodes tempObj[1] cloneType:#copy newNodes:&tempObjtemp #nodialog
				for obj2 in tempObjtemp do (
					targetTemp.addNode obj2
					clearSelection()
					select obj2
				)
				$ * obj
			)
			targetTemp.on = false			
			
			targetTemp = LayerManager.getLayerFromName "-- Temp PFenetres"
			if targetTemp == undefined then (
				LayerManager.newLayerFromName "-- Temp PFenetres";
				targetTemp = LayerManager.getLayerFromName "-- Temp PFenetres"
			) 
			
			for obj in  nnl2 do (
				maxOps.cloneNodes tempObj[1] cloneType:#copy newNodes:&tempObjtemp #nodialog
				for obj2 in tempObjtemp do (
					targetTemp.addNode obj2
					clearSelection()
					select obj2
				)
				$ * obj
			)
			targetTemp.on = false
			
			targetTemp = LayerManager.getLayerFromName "-- Temp Fenetres"
			if targetTemp == undefined then (
				LayerManager.newLayerFromName "-- Temp Fenetres";
				targetTemp = LayerManager.getLayerFromName "-- Temp Fenetres"
			) 
			
			for obj in  nnl3 do (
				maxOps.cloneNodes tempObj[1] cloneType:#copy newNodes:&tempObjtemp #nodialog				 
				for obj2 in tempObjtemp do (
					targetTemp.addNode obj2
					clearSelection()
					select obj2
				)
				$ * obj
			)
			targetTemp.on = false
			delete tempObj
			
			clearSelection()
			
			theObj = getNodeByName "Plinte"		
			select theObj
			
			ConvertTo theObj Editable_Poly
			
			for obj in nnl1  do ( 	
				move obj [0,0,-2]
				ProBoolean.createBooleanObjects theObj obj 2 0 0
				ConvertTo theObj Editable_Poly
			)			
			
			for obj in nnl2  do ( 
				move obj [0,0,-2]
				ProBoolean.createBooleanObjects theObj obj 2 0 0
				ConvertTo theObj Editable_Poly
			)		
			
			for obj in nnl3  do ( 
				move obj [0,0,-2]					
				ProBoolean.createBooleanObjects theObj obj 2 0 0
				ConvertTo theObj Editable_Poly
			)
						
			convertto theObj editable_poly				
			
			targetTemp = LayerManager.getLayerFromName "-- Temp Portes"
			targetTemp.nodes &tempPortes	
			
			for obj in  tempPortes do (				
				obj.pivot = ( obj.min + obj.max ) / 2
				obj.pivot.z = 0.5
			)
			
			targetTemp = LayerManager.getLayerFromName "-- Temp PFenetres"
			targetTemp.nodes &tempPFenetres	
			
			for obj in  tempPFenetres do (				
				obj.pivot = ( obj.min + obj.max ) / 2
				obj.pivot.z = 0.5
			)
			
			targetTemp = LayerManager.getLayerFromName "-- Temp Fenetres"
			targetTemp.nodes &tempFenetres	
			
			for obj in  tempFenetres do (				
				obj.pivot = ( obj.min + obj.max ) / 2
				obj.pivot.z = windowAllege.text as float
			)				
			
	)
			
)

rollout doorFrame "Menuiseries et Portes" width:350 height:270
(	
	listbox 'listFenetres' "Choix de fenetres" pos:[10,10] width:320 height:3
	listbox 'listPFenetres' "Choix de Portes fenetres" pos:[10,80] width:320 height:3
	listbox 'listPortes' "Choix de portes" pos:[10,150] width:320 height:3
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
	button 'loadScandinave2' "Scandinave 02" pos:[10,40] width:120 height:20 align:#left
	button 'loadDesign' "Design 01" pos:[200,10] width:120 height:20 align:#left
	button 'loadIndus' "Indus 01" pos:[200,40] width:120 height:20 align:#left	
	button 'loadChic' "Chic 01" pos:[10,70] width:120 height:20 align:#left
	
	on loadScandinave pressed  do
	(			
		
		filesObjects = getFiles (importfolderAMB + "\\Scandinave_01.max")	
		
		for f in filesObjects collect ( 
			format "Merge file : %\n" f
			mergemaxfile (f) #select #autoRenameDups #useSceneMtlDups
		)
		
	)
	
	on loadScandinave2 pressed  do
	(			
		
		filesObjects = getFiles (importfolderAMB + "\\Scandinave_02.max")	
		
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
	
	on loadIndus pressed  do
	(			
		
		filesObjects = getFiles (importfolderAMB + "\\Indus_01.max")	
		
		for f in filesObjects collect ( 
			format "Merge file : %\n" f
			mergemaxfile (f) #select #autoRenameDups #useSceneMtlDups
		)
		
	)
	
	on loadChic pressed  do
	(			
		
		filesObjects = getFiles (importfolderAMB + "\\Chic_01.max")	
		
		for f in filesObjects collect ( 
			format "Merge file : %\n" f
			mergemaxfile (f) #select #autoRenameDups #useSceneMtlDups
		)
		
	)
		
)

rollout importObjects "Importer des éléments" width:350 height:270
(	
	listbox 'listObjects' "Choix de l'objet" pos:[10,10] width:320 height:14
	button 'importObject' "Importer objet" pos:[95,230] width:150 height:20 align:#left
	
	on importObjects open  do
	(
		filesOBJ = getFiles (importfolderOBJ + "\\*.max")
		format "List Objects : % \n" filesOBJ 
		listObjects.items = for f in filesOBJ collect ( getFilenameFile f)
	)
	
	on importObject pressed  do
	(		    
			mergemaxfile (importfolderOBJ + "\\" + listObjects.selected + ".max") #select #autoRenameDups #renameMtlDups			
	)
			
)


dRolFloater = newRolloutFloater "Creation de plans de cellules" 350 650 80 200

addRollout prepareScene dRolFloater rolledUp:false
addRollout addPlan dRolFloater rolledUp:true
addRollout addExtWall dRolFloater rolledUp:true
addRollout addBackWall dRolFloater rolledUp:true
addRollout addIntWall dRolFloater rolledUp:true
addRollout finishedWall dRolFloater rolledUp:true
addRollout createGround dRolFloater rolledUp:true
addRollout openingWall dRolFloater rolledUp:true
addRollout doorFrame dRolFloater rolledUp:true
addRollout importAmbiance dRolFloater rolledUp:true
addRollout importObjects dRolFloater rolledUp:true

