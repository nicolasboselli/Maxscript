/*
[DESCRIPTION]
Reset 3DS Max Windows - Reset All 3DS Max "floating" Windows to pos: 0,0 (when gone)

[INFO]
- Put the files in maxroot\scripts\ (e.g.: C:\3dsmax2012\Scripts\)
- Tested with 3DS Max 2009 <--> 2012

[CREATION INFO]
Last Modified: May 04, 2011
Author: Raymond Homme Ingebretsen
Webpage: http://www.homme3d.com

[History]
V1.0: First version.
V1.1: Added more Dialog Windows
V1.2: Added support to reset invidually
V1.3: Added Backup 3dsmax.ini (By Anubis / http://project3d.narod.ru)
*/
----------------------------------------------------------------------------------------------------------------------------------------------------------
	try(closeRolloutFloater ResetMaxWindowsFloater) catch()
----------------------------------------------------------------------------------------------------------------------------------------------------------

Rollout Roll_ResetMaxWindows "Reset 3DS Max Windows" category:1
	(
		
		group "Reset: All Max Windows to Pos 0,0"
			(
				button btn_WinLayout "Reset All Windows" width:200 height:35 align:#center tooltip:"Reset All 3DS Max Floating Windows to POS 0,0"
				button btn_BackupMAXIni "Backup 3dsmax.ini" width:200 height:25 align:#center tooltip:"The Backupfile is located and backed up in 3dsmax archives or autobackup folder"
			)
			
		on btn_WinLayout pressed do
			(
			inipath = getMAXIniFile()
			
-- Misc:
			setINISetting inipath "DialogResizer_SizeAndPositions" "SelectObjectsDialog" "0 0 838 714"
			setINISetting inipath "DialogResizer_SizeAndPositions" "BatchRenderTool" "0 0 558 711"
			setINISetting inipath "DialogResizer_SizeAndPositions" "BatchRenderProgressTool" "0 0 382 245"
			setINISetting inipath "DialogResizer_SizeAndPositions" "SceneStateSaveDialog" "0 0 753 628"
			setINISetting inipath "DialogResizer_SizeAndPositions" "DwfExporter" "0 0 767 726"
			setINISetting inipath "DialogResizer_SizeAndPositions" "CloneAndAlignTool" "0 0 362 669"
			
-- Rendering:
			setINISetting inipath "RenderProgressDialogPosition" "Dimension" "0 0 379 372"
			setINISetting inipath "RenderVFBPosition" "Position" "0 0 412 156"
			setINISetting inipath "RenderDialogPosition" "Dimension" "0 0 457 1023"
			setINISetting inipath "RenderMessageWindow" "Dimension" "0 0 871 406"
			setINISetting inipath "RenderPresetsCategoryDialogPosition" "RenderPresetsCategoryDialogDimension" "0 0 210 280"
			setINISetting inipath "mentalrayMessagesPosition" "Dimension" "0 0 600 400"
			
-- Material:
			setINISetting inipath "MaterialBrowserDialogPosition" "ModalDimension" "0 0 187 745"
			setINISetting inipath "MaterialBrowserDialogPosition" "Dimension" "0 0 115 823"
			setINISetting inipath "MaterialBrowserDialogPosition" "NavDimension" "0 0 542 653"
			setINISetting inipath "MtlEditorPosition" "MainWindow" "0 0 368 734"
			setINISetting inipath "MtlEditorPosition" "MagWindow0" "0 0 255 293"
			setINISetting inipath "MtlEditorPosition" "MagWindow1" "0 0 255 293"
			
-- Utilities:
			setINISetting inipath "MoreUtilitiesDlgSize" "Size" "0 0 314 418"
			
-- Layer Dialog:
			setINISetting inipath "LayerDialog" "Dimension" "0 0 578 679"
			
-- Environment:
			setINISetting inipath "EnvironmentDialogPosition" "Dimension" "0 0 348 820"
			
-- Xref:
			setINISetting inipath "ObjectXRefDialogPosition" "Dimension" "0 0 439 619"
			setINISetting inipath "SceneXRefDialogPosition" "Dimension" "0 0 424 583"
		)
		
/*
Backup max.ini code is writen by Anubis <<---->>  http://project3d.narod.ru
*/
		on btn_BackupMAXIni pressed do
		(
			bkpDir = if (maxVersion())[1] >= 9000 then (GetDir #archives) else (GetDir #autoback)
			bkpFile = bkpDir + "\\3dsmax.ini"
			iniFile = getMAXIniFile()
			if doesFileExist bkpFile do deleteFile bkpFile
			copyFile iniFile bkpFile
		)
/*
End of Backup max.ini code is writen by Anubis <<---->>  http://project3d.narod.ru
*/
	)
---------------------------------------------------------------------------------------------------------------------------------------

Rollout Roll_Misc "Reset - Misc" category:2
	(
			group "Reset: Misc"
			(
				button btn_SelectObjectsDialog "Select Objects" width:210 height:25 align:#center
				button btn_BatchRenderTool "Batch Render Tool" width:210 height:25 align:#center
				button btn_BatchRenderProgressTool "Batch Render Progress Tool" width:210 height:25 align:#center
				button btn_SceneStateSaveDialog "Scene State Save Dialog" width:210 height:25 align:#center
				button btn_DwfExporter "Dwf Exporter" width:210 height:25 align:#center
				button btn_CloneAndAlignTool "Clone And Align Tool" width:210 height:25 align:#center
			)
			
			
			on btn_SelectObjectsDialog pressed do
		(
			inipath = getMAXIniFile()
			setINISetting inipath "DialogResizer_SizeAndPositions" "SelectObjectsDialog" "0 0 838 714"
		)

			on btn_BatchRenderTool pressed do
		(
			inipath = getMAXIniFile()
			setINISetting inipath "DialogResizer_SizeAndPositions" "BatchRenderTool" "0 0 558 711"
		)
		
			on btn_BatchRenderProgressTool pressed do
		(
			inipath = getMAXIniFile()
			setINISetting inipath "DialogResizer_SizeAndPositions" "BatchRenderProgressTool" "0 0 382 245"
		)

			on btn_SceneStateSaveDialog pressed do
		(
			inipath = getMAXIniFile()
			setINISetting inipath "DialogResizer_SizeAndPositions" "SceneStateSaveDialog" "0 0 753 628"
		)


			on btn_DwfExporter pressed do
		(
			inipath = getMAXIniFile()
			setINISetting inipath "DialogResizer_SizeAndPositions" "DwfExporter" "0 0 767 726"
		)

			on btn_CloneAndAlignTool pressed do
		(
			inipath = getMAXIniFile()
			setINISetting inipath "DialogResizer_SizeAndPositions" "CloneAndAlignTool" "0 0 362 669"
		)
	)
----------------------------------------------------------------------------------------------------------------------------------------------------------
	
Rollout Roll_Rendering "Reset - Rendering" category:3
	(		
			group "Reset: Rendering"
			(
				button btn_RenderVFBPosition "Render VFB Dialog" width:210 height:25 align:#center	
				button btn_RenderProgressDialogPosition "Render Progress Dialog" width:210 height:25 align:#center
				button btn_RenderDialogPosition "Render Dialog" width:210 height:25 align:#center	
				button btn_RenderMessageWindow "Render Message Window" width:210 height:25 align:#center	
				button btn_RenderPresetsCategoryDialogPosition "Render Presets Category Dialog" width:210 height:25 align:#center	
				button btn_mentalrayMessagesPosition "Mentalray Messages" width:210 height:25 align:#center	
			)
			
			
			on btn_RenderVFBPosition pressed do
		(
			inipath = getMAXIniFile()
			setINISetting inipath "RenderVFBPosition" "Position" "0 0 412 156"
		)
			
			on btn_RenderProgressDialogPosition pressed do
		(
			inipath = getMAXIniFile()
			setINISetting inipath "RenderProgressDialogPosition" "Dimension" "0 0 379 372"
		)
			
			on btn_RenderDialogPosition pressed do
		(
			inipath = getMAXIniFile()
			setINISetting inipath "RenderDialogPosition" "Dimension" "0 0 457 1023"
		)
			
			on btn_RenderMessageWindow pressed do
		(
			inipath = getMAXIniFile()
			setINISetting inipath "RenderMessageWindow" "Dimension" "0 0 871 406"
		)
				
			on btn_RenderPresetsCategoryDialogPosition pressed do
		(
			inipath = getMAXIniFile()
			setINISetting inipath "RenderPresetsCategoryDialogPosition" "RenderPresetsCategoryDialogDimension" "0 0 210 280"
		)
				
			on btn_mentalrayMessagesPosition pressed do
		(
			inipath = getMAXIniFile()
			setINISetting inipath "mentalrayMessagesPosition" "Dimension" "0 0 600 400"
		)
	)
----------------------------------------------------------------------------------------------------------------------------------------------------------
	
Rollout Roll_Material "Reset - Material" category:4
	(
			group "Reset: Material"
			(
				button btn_ModalDimension "Modal Dimension" width:210 height:25 align:#center	
				button btn_Dimension "Dimension" width:210 height:25 align:#center
				button btn_NavDimension "Nav Dimension" width:210 height:25 align:#center	
				button btn_MainWindow "Main Window" width:210 height:25 align:#center	
				button btn_MagWindow0 "Mag Window 0" width:210 height:25 align:#center	
				button btn_MagWindow1 "Mag Window 1" width:210 height:25 align:#center	
			)
			
			
			
			on btn_ModalDimension pressed do
		(
			inipath = getMAXIniFile()
			setINISetting inipath "MaterialBrowserDialogPosition" "ModalDimension" "0 0 187 745"
		)
		
			on btn_Dimension pressed do
		(
			inipath = getMAXIniFile()
			setINISetting inipath "MaterialBrowserDialogPosition" "Dimension" "0 0 115 823"
		)
		
			on btn_NavDimension pressed do
		(
			inipath = getMAXIniFile()
			setINISetting inipath "MaterialBrowserDialogPosition" "NavDimension" "0 0 542 653"
		)
		
			on btn_MainWindow pressed do
		(
			inipath = getMAXIniFile()
			setINISetting inipath "MtlEditorPosition" "MainWindow" "0 0 368 734"
		)
		
			on btn_MagWindow0 pressed do
		(
			inipath = getMAXIniFile()
			setINISetting inipath "MtlEditorPosition" "MagWindow0" "0 0 255 293"
		)
		
			on btn_MagWindow1 pressed do
		(	
			inipath = getMAXIniFile()
			setINISetting inipath "MtlEditorPosition" "MagWindow1" "0 0 255 293"
		)
	)
----------------------------------------------------------------------------------------------------------------------------------------------------------
	
Rollout Roll_Utilities "Reset - Utilities" category:5
	(
			group "Reset: Utilities"
			(
				button btn_MoreUtilitiesDlgSize "More Utilities Dialog Size" width:210 height:25 align:#center
			)
			
			on btn_MoreUtilitiesDlgSize pressed do
		(	
			inipath = getMAXIniFile()
			setINISetting inipath "MoreUtilitiesDlgSize" "Size" "0 0 314 418"
		)
	)
----------------------------------------------------------------------------------------------------------------------------------------------------------
	
Rollout Roll_LayerDialog "Reset - Layer Dialog" category:6
	(		
			group "Reset: Layer"
			(
				button btn_LayerDialog "Layer Dialog" width:210 height:25 align:#center
			)
			
			on btn_LayerDialog pressed do
		(	
			inipath = getMAXIniFile()
			setINISetting inipath "LayerDialog" "Dimension" "0 0 578 679"
		)
	)
----------------------------------------------------------------------------------------------------------------------------------------------------------
	
Rollout Roll_Environment "Reset - Environment" category:7
	(
			group "Reset: Environment"
			(
				button btn_EnvironmentDialogPosition "Environment Dialog" width:210 height:25 align:#center	
			)
			
			on btn_EnvironmentDialogPosition pressed do
		(	
			inipath = getMAXIniFile()
			SetINISetting inipath "EnvironmentDialogPosition" "Dimension" "0 0 348 820"
		)
	)
----------------------------------------------------------------------------------------------------------------------------------------------------------

Rollout Roll_XRef "Reset - XRef" category:8
	(		
			group "Reset: XRef"
			(
				button btn_ObjectXRefDialogPosition "Object XRef Dialog" width:210 height:25 align:#center
				button btn_SceneXRefDialogPosition "Scene XRef Dialog" width:210 height:25 align:#center
			)
			
			on btn_ObjectXRefDialogPosition pressed do
		(	
			inipath = getMAXIniFile()
			setINISetting inipath "ObjectXRefDialogPosition" "Dimension" "0 0 439 619"
		)	
			
			on btn_SceneXRefDialogPosition pressed do
		(	
			inipath = getMAXIniFile()
			setINISetting inipath "SceneXRefDialogPosition" "Dimension" "0 0 424 583"
		)	
	)
	
Rollout Roll_About "About" category:9
	(
		button btn_About "ABOUT" width:210 height:25
		HyperLink homepage1 "..:: Raymond H.Ingebretsen'2011 ::.." address:"http://www.homme3d.com/" color:(color 255 255 255) hovercolor:(color 111 111 111) visitedcolor:(color 255 255 255) align:#center
		HyperLink homepage2 "..:: Thanks to Anubis for 3dsmax.ini backup ::.." address:"http://project3d.narod.ru" color:(color 255 255 255) hovercolor:(color 111 111 111) visitedcolor:(color 255 255 255) align:#center
		
		on btn_About pressed do
		(
		messagebox "
[DESCRIPTION]
Reset 3DS Max Windows V1.3 – Reset All 3DS Max “floating” Windows to position 0,0 upper left when they are gone or out of range.

[INFO]
- Put the files in maxroot\scripts\ (e.g.: C:\3dsmax2012\Scripts\)
- Tested with 3DS Max 2009 <--> 2012

[NOTE]
Use and modify at you own risk.

[SPECIAL THANKS TO]
Anubis for 3dsmax.ini backup code
Webpage: http://project3d.narod.ru

[CREATION INFO]
Last Modified: May 04, 2011
Author: Raymond Homme Ingebretsen
Webpage: http://www.homme3d.com

[HISTORY]
V1.0: First version.
V1.1: Added more Dialog Windows
V1.2: Added support to reset invidually.
V1.3: Added Backup 3dsmax.ini (By Anubis / http://project3d.narod.ru)
")
)
---------------------------------------------------------------------------------------------------------------------------------------

	ResetMaxWindowsFloater=NewRolloutFloater "Reset 3DS Max Windows V1.3" 245 400 350 150

	Addrollout Roll_ResetMaxWindows ResetMaxWindowsFloater rolledUp:false
	
	Addrollout Roll_Misc ResetMaxWindowsFloater rolledUp:true
	Addrollout Roll_Rendering ResetMaxWindowsFloater rolledUp:true
	Addrollout Roll_Material ResetMaxWindowsFloater rolledUp:true
	Addrollout Roll_Utilities ResetMaxWindowsFloater rolledUp:true
	Addrollout Roll_LayerDialog ResetMaxWindowsFloater rolledUp:true
	Addrollout Roll_Environment ResetMaxWindowsFloater rolledUp:true
	Addrollout Roll_XRef ResetMaxWindowsFloater rolledUp:true
	Addrollout Roll_About ResetMaxWindowsFloater rolledUp:false

	print "Reset 3DS Max Floating Windows V1.3"