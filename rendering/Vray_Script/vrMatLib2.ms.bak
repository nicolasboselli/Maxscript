/*
maj:
	-- debug:
		x- save doens't work
		-- open max file crash
	
	-- maj: 
		-- save matlib after addition or deletion
		-- mark material edited
		x- sort material by name
		-- proposer un replace lorsqu'on veut enregistrer un materiau avec un nom deja existant
		
		-- versioning material library file
		-- add thumbnail
		-- collect texture
	
	-- dev: 
		-- mat structure
			-- mat
			-- name
			
		-- collect material from libray to array of structure on openning
		-- rebuilt libray from array on save
		-- separate materials collected  from materials displayed		

*/


fn sortMatbyname v1 v2 =
(
	-- qsort <array> sortbyname
-- 	vars
	local d
	
	if ( (toLower v1.name) < (toLower v2.name)) then
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
	
	global vrLib = materiallibrary()
	global matAr = #()
	
-- 	UI
	group "library file:"
	(
-- 		button loadCoreBT "load core"
		edittext libPthBT "lib :" readonly: true
		button openLibBT "..." across: 3
		button saveLibBT "save"
		button saveAsLibBT "save as"
	)
	
	group "manage library:"
	(
		button addMatBT "add mat"
		button delMatBT "delete mat" enabled: true
-- 		button upLibBT "refresh lib"
		listbox matLB "materials list:"
		button editMatBT "edit material"
-- 		button copyMatBT "copy material"
-- 		button replaceMatBT "replace material" enabled: false
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
			matLibLoaded = true
			
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
			if res do (format "library saved: %\nlibrary saved: %\n" vrLibPath matAr) 
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
		matLibLoaded = false
		
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
		-- save pref
		setINISetting armadasScriptsIni "vrMatLib" "DefaultMatLibPath" 	vrLibPath
		-- save lib
		writeLib vrLibPath
	)
	
	on openLibBT pressed do
	(
		vrLibPath = getOpenFileName caption: "open material library" types: "mat(*.mat)|*.mat|All Files|*.*"
		
-- 		load library
		loadLib vrLibPath
		
		refreshUI()
	)
	
	on saveLibBT pressed do
	( 
		if doesfileexist vrLibPath then writeLib vrLibPath
		else 	( format "path not valid: %\n" vrLibPath )
	)
	
	on saveAsLibBT pressed do
	(
		tmpPath = getSaveFileName caption: "save material library" types: "mat(*.mat)|*.mat|All Files|*.*"
		if tmpPath != undefined then writeLib tmpPath
		else 	( format "path not valid: %\n" tmpPath )
	)
	
	on upLibBT pressed do refreshUI()
	
	on addMatBT pressed do
	(
		append matAr meditMaterials[activeMeditSlot]
		refreshUI()
		
-- 		matLB.items = for mat in vrLib collect mat.name
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
		meditMaterials[activeMeditSlot] =  copy vrlib[matName]
	)
	
	/*
	on copyMatBT pressed do
	(
		matName = matLB.selected
		meditMaterials[activeMeditSlot] = copy vrlib[matName]
	)
*/
	
)
createdialog vrMatRlt


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