/*
maj:
	-- debug:
		-- open max file crash
	
	-- maj: 
		/- save matlib after addition or deletion
		x- sort material by name
		x- proposer un replace lorsqu'on veut enregistrer un materiau avec un nom deja existant
		
		-- versioning material library file
		-- enregistrer les library en fonction de la verions de max, un dossier par version de max
			-- enregistrer des fichiers materials library en version précedentes de max
		-- add thumbnail
		-- collect texture
	
		
		-- fonction search
		x- add autosave toggle
		
		-- gestion de bitmaps
			-- proposer en option le relinks des fichiers manquants sur un dossier donné
			-- proposer un ressource collector sur un dossier donné
			-- publier les bitmap manquants dans l'editeur de materiaux
			
	
	-- dev: 
		-- optimiser l'enregistrement
		x- mat structure
			-- mat
			-- name
			
		x- collect material from libray to array of structure on openning
		x- rebuilt libray from array on save
		-- separate materials collected  from materials displayed		

*/

fn sortbyname v1 v2 =
(
-- 	vars
	local d
	
	if ( (toLower v1.name) < (toLower v2.name)) then d=-1
	else d=1
	
--compare les numeros entre eux et les classe	
	if 	(d < 0.) then -1
	else if (d > 0.) then 1
	else 0
)


fn addUVWCube uvSize =
(
	local UvwSquare = Uvwmap  maptype: 4 length: uvSize width: uvSize  height: uvSize  axis: 2
	modPanel.addModToSelection (UvwSquare) ui:on
)


struct matStruct 
(
	mat,
	name = mat.name
)

try(destroyDialog vrMatRlt)catch()
-- rollout
rollout vrMatRlt "VRay mat Lib"
(
	
	local maxIni = getMAXIniFile()
	local armadasScriptsIni = (getFilenamePath maxIni) + "armadasScriptsIni.ini"
	
	local vrLibPath
	local openFileName
	
	local matColAr = #()
	local matDispAr = #()
	
	local	vrLib = materiallibrary()
	local matAr = #()
	
-- 	UI
	group "library file:"
	(
-- 		button loadCoreBT "load core"
		edittext libPthBT "lib :" readonly: true
		button openLibBT "..." across: 2
		button loadLibBT "load"
		button saveLibBT "save" across: 2
		button saveAsLibBT "save as"
		checkbox autosaveCB "save on close"
	)
	
	group "scene materials:"
	(
		button collectSceneMatBT "collect scene material"
	)
	
	group "manage library:"
	(
		button addMatBT "add mat"
		button delMatBT "delete mat" enabled: true
-- 		button upLibBT "refresh lib"
		listbox matLB "materials list:" height: 30
		button editMatBT "copy material"
		button instMatBT "instance material"
-- 		button copyMatBT "copy material"
-- 		button replaceMatBT "replace material" enabled: false
	)
	
	group "vray material:"
	(
		button createVrMtlBT "create vray material"
	)
	
	group "uvw mapping box:"
	(
		button uv100 "100" across: 3
		button uv250 "250"
		button uv500 "500"
	)
	
	group "bitmap"
	(
		button scanBT "scan and patch"
		button missBmpBT "edit missing bitmap"
		button missBmpBT2 "format missing bitmap"
	)
	
	
	/*
	group "map material:"
	(
		button mapLibToEdBT "library => editor"  enabled: false
		button mapEdToLibBT "editor => library"  enabled: false
	)
	*/
	
	-- functions
	fn loadLib vrLibPath =
	(
		if doesfileexist vrLibPath then
		(
			format "loading start\n"
			vrLib = loadTempMaterialLibrary vrLibPath
-- 			matLibLoaded = true
-- 			getclassinstances  target: vrLib 
			format "vrLib: %\n" vrLib
			
			matAr = for mat in vrLib collect mat
			qsort matAr sortbyname
			format "loading done: %\n" vrLibPath
		)
		else
		(
			vrLib = materialLibrary ()
			format "loading fail\n"
		)
	)	

	fn writeLib vrLibPath =
	(
		vrMatTmp = materiallibrary()
-- 		vrMatTmp.count

		for m in matAr do append vrMatTmp m
			
		if doesfileexist vrLibPath then
		(
			res = saveTempMaterialLibrary  vrMatTmp vrLibPath
			if res then (format "library saved: %, content: %\n" vrLibPath matAr) 
			else (format "library NOT saved: %,  content: %\n" vrLibPath matAr)
		)
		else
		(
			res = saveTempMaterialLibrary  vrMatTmp vrLibPath
			if res then (format "library saved: % , content: %\n" vrLibPath matAr) 
			else (format "library NOT saved: %,  content: %\n" vrLibPath matAr)
		)
	)
	
	fn refreshUI =
	(
		if vrLibPath!= undefined then libPthBT.text = vrLibPath else libPthBT.text = "???"
		qsort matAr sortbyname
		matLB.items = for mat in matAr collect mat.name
	)
	
-- 	actions
	on vrMatRlt open do
	(
-- 		matLibLoaded = false
		
		-- init library path
		if vrLibPath == undefined then
		(
			try 
			(
				vrLibPath = getINISetting armadasScriptsIni "vrMatLib" "DefaultMatLibPath"
			)
			catch(format "error: %\n" (getcurrentexception()))
		)
		
		-- load library
		loadLib vrLibPath
		
		-- refresh ui 2
		refreshUI()
	)
	
	on vrMatRlt close do
	(
		autosaveCB
		
-- 		format "vrLibPath: %\n" vrLibPath.count
		
		if vrLibPath.count > 0 and autosaveCB.state then
		(
			-- save pref
			setINISetting armadasScriptsIni "vrMatLib" "DefaultMatLibPath" vrLibPath
			-- save lib
			writeLib vrLibPath
		)
		
	)
	
	on openLibBT pressed do
	(
		vrLibPath = getOpenFileName caption: "open material library" types: "mat(*.mat)|*.mat|All Files|*.*"
		
-- 		load library
		loadLib vrLibPath
		
		refreshUI()
	)
	
	on loadLibBT pressed do
	(
		loadLib vrLibPath
		refreshUI()
	)
	
	on saveLibBT pressed do
	( 
		if doesfileexist vrLibPath then 
		(
			writeLib vrLibPath
			loadLib vrLibPath
		
			refreshUI()
		)
		else 	( format "path not valid: %\n" vrLibPath )
	)
	
	on saveAsLibBT pressed do
	(
		tmpPath = getSaveFileName caption: "save material library" types: "mat(*.mat)|*.mat|All Files|*.*"
		if tmpPath != undefined then 
		(
			writeLib tmpPath
			format "MatLib saved: %\n" tmpPath
		)
		else 	( format "path not valid: %\n" tmpPath )
	)
	
	on upLibBT pressed do refreshUI()
	
	on collectSceneMatBT pressed do
	(
			matAr = for mat in scenematerials collect mat
			qsort matAr sortbyname
			
			refreshUI()
	)
	
	on addMatBT pressed do
	(
		local matCand = meditMaterials[activeMeditSlot]
		
-- 		format "matCand: %\n" matCand
		local saving = true
		-- finditem matAr matCand
		
		-- check enregistrer material existant
		for i = matAr.count  to 1 by -1 do
		(
			if matAr[i].name == matCand.name then
			(
				local res = queryBox  "Un materiau avec le même nom existe déja.\n Voulez-vous le remplacer?" title: matAr[i].name 
-- 				format "res: %\n" res
				if res then
				(
					-- erase
					deleteitem matAr i
					exit 
				)
				else
				(
					saving = false
					exit
				)
			)else()
			
		)
		
		-- save
		if saving then
		(
			append matAr matCand
			format "saving done: %\n" matCand
		)
		
		refreshUI()
	)

	on delMatBT pressed do
	(
		id = matLB.selection
		format "matName: %\n" matName
		deleteItem matAr id
		refreshUI()
-- 		matLB.items = for mat in vrLib collect mat.name
	)
	 
	
	on editMatBT pressed do
	(
		matName = matLB.selected
		id = finditem matLB.items matName
		meditMaterials[activeMeditSlot] =  copy matAr[id]
-- 		meditMaterials[activeMeditSlot] =  matAr[id]
	)
	
	on instMatBT pressed do
	(
		matName = matLB.selected
		id = finditem matLB.items matName
-- 		meditMaterials[activeMeditSlot] =  copy matAr[id]
		meditMaterials[activeMeditSlot] =  matAr[id]
	)
	
	on createVrMtlBT pressed do
	(
		meditMaterials[activeMeditSlot] = vraymtl()
	)
	
	on uv100 pressed do addUVWCube 100
		
	on uv250 pressed do addUVWCube 250
		
	on uv500 pressed do addUVWCube 500
	
	on scanBT pressed do
	(
		
-- 		local bmpAr = getclassinstances bitmaptexture target: vrLib
		local bmpAr = getclassinstances bitmaptexture target: scenematerials

		for b in bmpAr do
		(
			if doesfileexist b.filename then
			(
				if matchpattern b.filename pattern: "M:*" or matchpattern b.filename pattern: "R:*" or matchpattern b.filename pattern: "N:*" or matchpattern b.filename pattern: "T:*" then format "FOUND filename: %\n" b.filename
				else if  matchpattern b.filename pattern: "R:\RESSOURCES*" then
				(
-- 					format "RE MAP filename: %\n" b.filename
					newFIleName = substitutestring b.filename "R:\RESSOURCES" "N:\Ressources_Nico"
					if doesfileexist newFIleName then 
					(
						b.filename = newFIleName
						format "RE MAP filename: % >>> newName:%\n" b.filename newFIleName
					)
					else
					(
						format "NOT CONFORM filename: %\n" b.filename
					)
-- 					meditMaterials[activeMeditSlot] = b
				)
				else if matchpattern b.filename pattern: "D:\RESSOURCES*" then
				(
-- 					format "RE MAP filename: %\n" b.filename
					newFIleName = substitutestring b.filename "D:\RESSOURCES" "N:\Ressources_Nico"
					if doesfileexist newFIleName then 
					(
						b.filename = newFIleName
						format "RE MAP filename: % >>> newName:%\n" b.filename newFIleName
					)
					else
					(
						format "NOT CONFORM filename: %\n" b.filename
					)
-- 					meditMaterials[activeMeditSlot] = b
				)
				else 
				(
					format "NOT CONFORM filename: %\n" b.filename
				)
			)
			else
			(
				format "NOT FOUND filename: %\n" b
-- 				meditMaterials[activeMeditSlot] = b
			)
		)
-- 		format "bmpAr: %\n" bmpAr
	)

	on missBmpBT pressed do
	(
		local bmpAr = getclassinstances bitmaptexture target: scenematerials
		local i = 1
		for b in bmpAr do
		(
			
			if not doesfileexist b.filename then
			(
				format "missing filename: %\n" b.filename
				refdep = refs.dependents b  -- immediateOnly: true
-- 				meditmaterials[i] = b
				
				i +=1
				
				for d in refdep do
				(
-- 					format "d: % classof: %, i:%\n" d (classof d) i
					if classof d == vraymtl then 
					(
						format "d: % classof: %, i:%\n" d (classof d) i
						if i < 24 then
						(
							meditmaterials[i] = d
							i += 1
						)
					)
				)
			)
			else
			(
				format "filename: %\n" b.filename
			)
			
			if i == 24 then exit
		)
	)
	
	on missBmpBT2 pressed do
	(
		local bmpAr = getclassinstances bitmaptexture target: scenematerials
		local i = 1
		
		for b in bmpAr do
		(
			if b.filename != undefined then
			(
				if doesfileexist b.filename then
				(
-- 					format "Found: % %\n" i b.filename 
				)
				else if not doesfileexist b.filename then
				(
					format "Not Found: % %\n" i b.filename 
				)
				else()
				i += 1
			)
			else format "Not Found: % %\n" i undefined
		)

	)
)
createdialog vrMatRlt

-- f = @"T:\Ametis\St Jory-Colibri_1017\Perspectives\Scenes 3d\modelisation\wip\antoine\Tone Auto Entreprise\TEXTURES\TEXTURES VISIOLAB\Textures\Chene-verni_antique.jpg"
-- doesfileexist f

/*
-- base material grid
fn createGridBaseMatFN =
(
	local gridmap = bricks Tile_Type: 5 Lock_Gap_Symmetry: 0 Fade_Variance: 0 Brick_Color: (color 0 0 0) Mortar_Color: (color 255 255 255) \
	Vertical_Count: 1 Vertical_Gap: 0 Horizontal_Gap: 2

	local gridMat = standard name: "gc_grid_material" twoSided: true Diffuse: (color 0 0 0 ) opacityMap: gridmap
)

-- vr material enduit
fn createEnduitVRMatFN = 
(
	local enduitMat = vraymtl name: "enduit_blanc" diffuse: (color 235 235 235)
)

-- vr material enduit
fn createConcreteVRMatFN = 
(
	local enduitMat = vraymtl name: "beton_blanc" diffuse: (color 235 235 235)
)


fn createVrayMatFN matName = 
(
	if matName == "gc_grid_material" then return createGridBaseMatFN()
	else if matName == "enduit_blanc" then return createEnduitVRMatFN()
	else if matName == "beton_blanc" then return createConcreteVRMatFN()
	else print "no material definition"
)
*/

/*

vrLib =  materialLibrary()
append vrLib meditMaterials[activeMeditSlot]

for mat in vrLib do print mat
	
saveTempMaterialLibrary  vrLib "G:\vrlib.mat"

tmp =  materialLibrary()
tmp = loadTempMaterialLibrary "G:\vrlib.mat"

meditMaterials[activeMeditSlot] = vrLib[1]

*/



/*
maxIni = getMAXIniFile()
vrayLibIni = (getFilenamePath maxIni) + "vrayLib.ini"
setINISetting vrayLibIni "vrayLib" enduitMat.name  propArVal
	

test = createGridBaseMatFN()
show test.opacityMap


-- enduitMat = vraymtl()
enduitMat = meditMaterials[activeMeditSlot]

propAr = getPropNames  enduitMat
propArVal = for t in propAr collect (getProperty enduitMat t)
with printAllElements on propArVal as string



setINISetting vrayLibIni "vrayLib" enduitMat.name  (with printAllElements on propArVal as string)
vrString = getINISetting vrayLibIni "vrayLib" enduitMat.name
vrVal = execute vrString
*/
-- getProperty enduitMat #texmap_diffuse

-- getPropertyController enduitMat