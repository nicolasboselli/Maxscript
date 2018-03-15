
Global re = maxOps.GetCurRenderElementMgr ()

maxVers = getFileVersion "$max/3dsmax.exe"

-- vrayCreateVRayPhysicalCamera()

fn convertToVrCam s =
(
	if classof s == TargetCamera or classof s == FreeCamera or classof s == Physical then
	(
		vrCam = VRayPhysicalCamera transform: s.transform name: s.name targeted: false specify_fov: true fov: s.fov vignetting: false shutter_speed: 150 f_number: 9 	whiteBalance_preset: 2 whiteBalance: color 191.25 226.023 255
		s.name = s.name + "_bak"
		vrCam.specify_fov = false
	)
	else(format "camera inconvertible: %\n" s)
)

try(destroyDialog Pt2vue_renderer_UI)catch()
rollout Pt2vue_renderer_UI "Rendeur de points de vues" width: 500
(
	local maxIni = getMAXIniFile()
	local armadasScriptsIni = (getFilenamePath maxIni) + "armadasScriptsIni.ini"
	
	-- 	vars
	local renderSize
	
	local camArray = #()
	
	local outputPath
	local outputPathFolder
	
	local sceneCam = #()
			
	local camSel 
	local oneCamSelected = undefined
	
	-- vars maquette materials
	/*
	local vr=renderers.current

	local MatMaqDirt = VRayDirt radius: 100 occluded_color: (color 104 129 146) unoccluded_color: (color 230 230 230 )
	local OverMatMaquette = VRayMtl name: "over_maquette" diffuse:  (color 230 230 230 ) texmap_diffuse: MatMaqDirt
	
	local AtmosVRtoon =  VrayToon widthtype: 1 color: (color 72 96 108)	opacity: 0.8 lineworld: 2

	local OverMatVitre = VRayMtl name: "over_vitre" diffuse:  (color 92 175 196 ) 
	*/
-- 	vars bakup
	local Pt2vueNode
		
	-- functions
	
-- 	extrait une seule camera à partir de la selection dans la mutibox
	fn oneCamSelectedFN multiBoxVar =
	(
		oneCamSelected = undefined
		multiCamSel = (multiBoxVar.selection as array)
-- 		print (multiCamSel as string)
		if multiCamSel.count ==1 then oneCamSelected = multiCamSel[1] 
		
		oneCamSelected
	)


	fn collectCamFN =
	(
		CamSel = for c in cameras where classof c != Targetobject collect c
		CamSel
	)
	
-- 	rafraichis les elements d'une listbox
	fn refreshItemsFN listboxname itemsArray =
	(
		listboxname.items = for o in itemsArray collect o.name
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

	
	group "Gestion Liste de Cameras"
	(
		
		Multilistbox Cam2Render "Cameras:"  
		button sortCamName "Classer par nom" across: 2
		button RebootCamBT "Reinitialiser"
		
		pickbutton PickCam "Piquer une Camera"  filter: cam_filt across: 4
		button addCamSelect "Ajout de Cameras" 
		button delCamSelect "Supprimer selection"
		button delOtherCamBT "Supprimer les autres"
	)
	
	group "Gestion Cameras dans la Scene"
	(
		button selectCamBT "Selectionner" across: 3
		button CamViewBT "Camera View"
		button vrCamBT "convert to vr cam" enabled: true

		button duplicateCamSelBT "Dupliquer" across:2
		button deleteReelCamBT "Supprimer"
		
		edittext RenameCamEdit "Renommer" 
		button test
	)
	
	group "chemin d'enregistrement"
	(
		edittext savepath  "Folder:" text: "" readonly: true
		
		edittext suffixNameEdit "File Name :"  text: "" readonly: false across: 2
		edittext fileNameType "Type: " text: "" readonly: true
		
		button SelectPathFile "..."
	)
	
	/*
	group "render options:"
	(
		checkbox MaqRenderCB "Rendu Maquette" across: 3
		checkbox NetRenderCB "Net Render" 
		radiobuttons RenderSizeRB "Render Size:" labels: #("1350x750", "2700x1500")

	)
	*/
	
	button rendCamSelBT "Render Cameras Selectionnées"		
-- 	button rendAllCamBT "Render All Cam v2" 
	
-- 	button testNameBT "Test Name"
	
	-- actions

	
	
-- 	ouverture
	on Pt2vue_renderer_UI open do
	(
		camArray = collectCamFN ()
		refreshItemsFN Cam2Render camArray
		
		savepath.text = getINISetting armadasScriptsIni "Pt2Vue" "outputPathFolder"
		format  "outputPathFolder: %\n" savepath.text
-- 		application materiau maquette override
-- 		vr.options_overrideMtl_on = true
-- 		vr.options_overrideMtl_mtl = OverMatMaquette
		
-- 		addAtmospheric  AtmosVRtoon
-- 		setActive AtmosVRtoon true
		
-- 		MaqRenderCB.state = true
		
-- 		taille du rendu
		
	)
	
	on Pt2vue_renderer_UI close do
	(
		if savepath.text != undefined do
		(
			setINISetting armadasScriptsIni "Pt2Vue" "outputPathFolder" 	savepath.text
		)
	)
	
	on Cam2Render selectionEnd do
	(
		print "youhou"
		oneCamSelected = oneCamSelectedFN Cam2Render
		print oneCamSelected
		
		if oneCamSelected != undefined then	
		(	
			camSel = camArray[oneCamSelected]
			
			RenameCamEdit.text = camSel.name
			
			if classof camSel != VRayPhysicalCamera then vrCamBT.enabled = true
			else vrCamBT.enabled = false
		)
		else
		(
			RenameCamEdit.text = ""
		)
	)
	
	on Cam2Render doubleClicked oneCam do
	(
		viewport.setCamera camArray[oneCamSelected]
		select  camArray[oneCamSelected]
	)		

	on vrCamBT pressed do
	(
-- 		print "youhou"
-- 		print camSel
		convertToVrCam camSel
	)
	
-- 	gestion camera	

	
	on sortCamName pressed do
	(
		qsort camArray sortbyname
-- 		camArray = sort camArray
		refreshItemsFN Cam2Render camArray
	)
	
	on RebootCamBT pressed do
	(
		camArray = collectCamFN ()
		refreshItemsFN Cam2Render camArray
	)
	
	
	on addCamSelect pressed do 
	(
		CamTempSet = selection as array
		for o in CamTempSet do append camArray o
		camArray = makeuniqueArray camArray
		refreshItemsFN Cam2Render camArray
	)
	
	on delCamSelect pressed do
	(
		for i=(Cam2Render.selection as array).count to 1 by -1  do
		(			
			deleteItem camArray (Cam2Render.selection as array)[i]
		)
		refreshItemsFN Cam2Render camArray
	)
	
	on PickCam picked obj do
	(
		append camArray obj
		camArray = makeuniqueArray camArray
		refreshItemsFN Cam2Render camArray
	)
	
	
	-- Events gestion cameras dans la scene
	on duplicateCamSelBT pressed do
	(
		if oneCamSelected != undefined then
		(
		select camArray[oneCamSelected]
		copyCamTemp = copy camArray[oneCamSelected]
		append camArray copyCamTemp
		refreshItemsFN Cam2Render camArray
		)
		else
		(
			print "selectionnez une seule camera"
		)
	)
	
	on deleteReelCamBT pressed do
	(
		if oneCamSelected != undefined then
		(
		delete camArray[oneCamSelected]
		deleteitem camArray oneCamSelected
		refreshItemsFN Cam2Render camArray
		)
		else 
		(
			print "selectionnez une seule camera"
		)
	)
	
	on selectCamBT pressed do
	(
		if oneCamSelected != undefined then
		(
			select camArray[oneCamSelected]
		)
		else 
		(
			print "selectionnez une seule camera"
		)
	)
	
	on CamViewBT pressed do
	(
		if oneCamSelected != undefined then 
		(
			viewport.setCamera camArray[oneCamSelected]
		)
		else 
		(
			print "selectionnez une seule camera"
		)
	)
	
	
	on RenameCamEdit entered NewNameString do 
	(
		if oneCamSelected != undefined then
		(		
			camArray[oneCamSelected].name = NewNameString
			refreshItemsFN Cam2Render CamArray
		)
		else
		(
			print "selectionner un seul element"
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
	

	on MaqRenderCB changed thestate do
	(
		vr.options_overrideMtl_on = thestate

		setActive AtmosVRtoon thestate
	)
	
-- 	render
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
			/*
			renderSize = case RenderSizeRB.state of
			(
				1: 750
				2: 1500
			)
			*/
			
			camAr = (Cam2Render.selection) as array
			
			for i = 1 to camAr.count do
			(
				renderSceneDialog.close ()	
				
				outputPathNameDef = (savepath.text + suffixNameEdit.text + "_" + CamArray[camAr[i]].name + fileNameType.text)
			
				bakOutput = rendOutputFilename
				bakWidth = renderWidth
				bakHeight = renderHeight
				 
-- 				rendTimeType = 1
				rendSaveFile = true
-- 				rendusenet = NetRenderCB.state
				rendOutputFilename =  outputPathNameDef
				
-- 				renderWidth = 1500
-- 				renderHeight = 1000
				
				
				re.setElementsActive false
				
-- 				CleanOutEltsFN ()
				viewport.setCamera CamArray[camAr[i]]

				renderSceneDialog.commit()
				max quick render

				rendOutputFilename = bakOutput
				renderWidth = bakWidth
				renderHeight = bakHeight
				

			)
		)
	)
	

)

createdialog Pt2vue_renderer_UI



--------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------
-- ameliorations:

-- parametrer la taille de l'image

	-- conserver plusieurs asset de camera


	-- ajouter directement la date et le nom du rendu au rendu (script photoshop)




