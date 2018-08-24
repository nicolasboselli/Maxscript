
Global re = maxOps.GetCurRenderElementMgr ()


global Pt2vue_renderer_UI = undefined
global camArray = #()

global camSel = undefined


global oneCamSelected = undefined

rollout Pt2vue_renderer_UI "Rendeur de points de vues" width: 500
(
	-- 	vars

	local camArrayNames = #()
	local outputPath
	local outputPathFolder
	local sceneCam = #()
	
	-- vars maquette materials
	local vr=renderers.current

	local MatMaqDirt = VRayDirt radius: 100 occluded_color: (color 104 129 146) unoccluded_color: (color 230 230 230 )
	local OverMatMaquette = VRayMtl name: "over_maquette" diffuse:  (color 230 230 230 ) texmap_diffuse: MatMaqDirt
	
	local AtmosVRtoon =  VrayToon widthtype: 1 color: (color 72 96 108)	opacity: 0.8 lineworld: 2

	local OverMatVitre = VRayMtl name: "over_vitre" diffuse:  (color 92 175 196 ) 
	
-- 	vars bakup
	local Pt2vueNode
		
	-- functions
-- 	extrait une seule camera à partir de la selection dans la mutibox
	fn oneCamSelectedFN multiBoxVar =
	(
		multiCamSel = (multiBoxVar.selection as array)
		print (multiCamSel as string)
		if multiCamSel.count ==1 then oneCamSelected = multiCamSel[1] else oneCamSelected = undefined
		return oneCamSelected
	)


	
	fn FindPt2vueNodeFN =
	(
	
		if (getnodebyname "Pt2vueNode") == undefined then 
		(
			Pt2vueNode = point name: "Pt2vueNode"

			ZeroLayer = LayerManager.getLayer 0
			ZeroLayer.addnode Pt2vueNode


			the_Pt2vueNodeAT1 = attributes CameraStack
			(
			)
			custAttributes.add Pt2vueNode the_Pt2vueNodeAT1
			
			the_Pt2vueNodeAT2 = attributes OutPathname
			(
			)
			custAttributes.add Pt2vueNode the_Pt2vueNodeAT2
			print "pt2vuenode vient d'etre creer"
		)
		else
		(
			Pt2vueNode = (getnodebyname "Pt2vueNode")
			print "pt2vuenode detecte"
		)
		return Pt2vueNode
	)



	fn collectCamFN =
	(
		local CamSel = #()
		for o in ($* as array) do
		(
			if (classof o == freecamera ) do append CamSel o
			if (classof o == targetcamera ) do append CamSel o
			if (classof o == vrayphysicalcamera ) do append CamSel o
		)
		return CamSel
	)
	
	fn refreshItems listboxname =
	(
		camArrayNames = for o in camArray collect o.name
		listboxname.items = camArrayNames
	)
	
	fn cam_filt obj = classof obj == freecamera

	fn sortbyname v1 v2 =
	(
	-- 	vars
		local d
		
		if ( v1.name < v2.name) then
			d=-1
		else
			d=1
		
	--compare les numeros entre eux et les classe	
		case of
		(
			(d < 0.): -1
			(d > 0.): 1
			default: 0
		)
	)

	-- def ui

	
	group "asset de cameras"
	(
		
		Multilistbox Cam2Render "Cameras:"  items: camArrayNames 
		button sortCamName "Classer par nom" align:#center 	
	)
	
	group "Gestion Liste de Cameras"
	(
		pickbutton PickCam "Piquer une Camera"  filter: cam_filt across: 3
		button addCamSelect "Ajout de Cameras" 
		
		button delCamSelect "Supprimer"
	)
	
	group "Gestion Cameras dans la Scene"
	(
		button selectCamBT "Selectionner" across: 4
		button CamViewBT "Camera View"

		button duplicateCamSelBT "Dupliquer" 
		button deleteReelCamBT "Supprimer"
		edittext RenameCamEdit "Renommer" 
		
	)
	
	group "chemin d'enregistrement"
	(
		edittext savepath  "Folder:" text: "" readonly: true
		
		edittext suffixNameEdit "File Name :"  text: "" readonly: false across: 2
		edittext fileNameType "Type: " text: "" readonly: true
		
		button SelectPathFile "..."
	)
		
	group "rendus"
	(
		checkbox MaqRenderCB "Rendu Maquette" across: 2
		checkbox NetRenderCB "Net Render" 
		button rendCamSelBT "Render Cam Selected v2" across: 2
		button rendAllCamBT "Render All Cam v2" 
		
	)
	
		group "Bakup"
	(
-- 		button CreatePt2vueNodeBT "Create Point de Vue Node" across: 2
		button CheckPt2vueNodeBT "Check Point de Vue Bakup" across: 3
		button SelPt2vueNodeBT "select Pt de vue node"
		button DelPt2vueNodeBT "delete pt de vue node"
		button SaveCamAssetBT "Save Current Camera Asset" across: 2
		button ReloadCamAssetBT "Reload Camera Asste"
	)
	
	-- actions
	on RenameCamEdit entered NewNameString do 
	(
		camArray[oneCamSelected].name = NewNameString
		Pt2vue_renderer_UI.refreshItems Cam2Render
	)
	
	
-- 	ouverture
	on Pt2vue_renderer_UI open do
	(
		camArray = collectCamFN ()
		Cam2Render.items = for o in camArray collect o.name
		
-- 		application materiau maquette override
		vr.options_overrideMtl_on = true
		vr.options_overrideMtl_mtl = OverMatMaquette
		
		addAtmospheric  AtmosVRtoon
		setActive AtmosVRtoon true
		
		MaqRenderCB.state = true	

-- recuperation du pt2vueNode
		Pt2vueNode = FindPt2vueNodeFN ()
	)
	
	
	on Cam2Render selectionend do
	(
		print "toto"
		oneCamSelected = (oneCamSelectedFN Cam2Render)
		print oneCamSelected
		if oneCamSelected != undefined then	
		(	
		RenameCamEdit.text = camArray[oneCamSelected].name
		)
		else
		(
			RenameCamEdit.text = ""
		)
		
	)
	
-- 	gestion camera	

	
	on sortCamName pressed do
	(
		qsort camArray sortbyname
-- 		camArray = sort camArray
		refreshItems Cam2Render
	)
	
	
	on addCamSelect pressed do 
	(
		CamTempSet = $selection as array
		for o in CamTempSet do append camArray o
		camArray = makeuniqueArray camArray
		refreshItems Cam2Render
	)
	
	on delCamSelect pressed do
	(
		if oneCamSelected != undefined then
		(
			deleteItem camArray oneCamSelected
			refreshItems Cam2Render
		)
	)
	
	on PickCam picked obj do
	(
		append camArray obj
		camArray = makeuniqueArray camArray
		refreshItems Cam2Render
	)
	
	on selectCamBT pressed do
	(
		if oneCamSelected != undefined then 
		(
			select camArray[oneCamSelected]
		)

	)
	
	on CamViewBT pressed do
	(
		if oneCamSelected != undefined then 
		(
			viewport.setCamera camArray[oneCamSelected]
		)
	)
	
-- 	chemin enregistrement
	
	on SelectPathFile pressed do
	(
		outputPath = getBitmapSaveFileName filename: savepath.text
		
		if outputPath != undefined then
		(
			savepath.text = getFilenamePath outputPath
			suffixNameEdit.text = getFilenameFile outputPath
			fileNameType.text = getFilenameType outputPath
		)
		else
		(
			print "Fail"
		)
	)
	
-- 	render
	on MaqRenderCB changed thestate do
	(
		vr.options_overrideMtl_on = thestate

		setActive AtmosVRtoon thestate
	)
	
	on rendCamSelBT pressed do
	(
		if savepath.text =="" then
		(			
			messagebox "définir un chemin d'enregistrement"
		)
		else if suffixNameEdit.text == "" then 
		(
			messagebox "définir un chemin d'enregistrement"
		)
		else if fileNameType.text == "" then
		(
			messagebox "définir un chemin d'enregistrement"
		)
		else
		(
			CamSel = ((Cam2Render.selection) as array)
-- 			print camsel
-- 			for i = 1 to CamSel.count do print camArray[i]
				
			for i = 1 to CamSel.count do
			(
				renderSceneDialog.close ()	
				
				outputPathNameDef = (savepath.text + suffixNameEdit.text + "_" + CamArray[i].name + fileNameType.text)
			
				bakOutput = rendOutputFilename

				 
-- 				rendTimeType = 1
				rendusenet = NetRenderCB.state
				rendOutputFilename =  outputPathNameDef
				
				
-- 				re.setElementsActive EltsRendMatteCB.state

-- 				CleanOutEltsFN ()

				renderSceneDialog.commit()
				max quick render

				rendOutputFilename = bakOutput

			)
		)
	)
			
		-- 	backup
	on CheckPt2vueNodeBT pressed do
	(
		FindPt2vueNodeFN ()		
	)
	
	on SelPt2vueNodeBT pressed do
	(
		select Pt2vueNode
	)
		
	on DelPt2vueNodeBT pressed do
	(
		delete Pt2vueNode
	)
	
	on ReloadCamAssetBT pressed do
	(
		camArray = (custAttributes.getdefdata (custAttributes.getdef Pt2vueNode.camerastack))
		outputPathFolder = (custAttributes.getDefData (custAttributes.getdef Pt2vueNode.OutPathname))
			
		Cam2Render.items = for o in camArray collect o.name
		savepath.text = outputPathFolder
	)
	
	on SaveCamAssetBT pressed do
	(
		custAttributes.setDefData (custAttributes.getdef Pt2vueNode.camerastack) CamArray
		custAttributes.setDefData (custAttributes.getdef Pt2vueNode.OutPathname) (savepath.text)
	)

-- 	fermeture du rollout
	on Pt2vue_renderer_UI close do
	(
		print "salut"
		print camArray
		print (Pt2vue_renderer_UI.savepath.text)
-- 		custAttributes.setDefData (custAttributes.getdef $.camerastack) CamArray
-- 		custAttributes.setDefData (custAttributes.getdef $.OutPathname) (Pt2vue_renderer_UI.savepath.text)
		
-- 		nettoyage maquette override
		vr.options_overrideMtl_mtl = undefined
		vr.options_overrideMtl_on = false
		
		setActive AtmosVRtoon false
		deleteAtmospheric 1
	)
)

createdialog Pt2vue_renderer_UI



--------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------
-- ameliorations:

-- parametrer la taille de l'image

	-- conserver plusieurs asset de camera

	-- dupliquer une camera

	-- ajouter directement la date et le nom du rendu au rendu (script photoshop)




