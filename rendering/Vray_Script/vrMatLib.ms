/*
maj:
	-- debug:
		x- save doens't work
		-- open max file crash
	
	-- maj: 
		-- save matlib after addition or deletion
		-- mark material edited
		-- sort material by name
		
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

	(-- materials mapping
		-- synchronise material libray with scenematerial applied to objects
			-- from library to editor, like replace(isntance)
			-- from editor to library
			-- check name
			-- map when apply material edited to object
			-- auto re-map on opening when compare lib map with scene mat)
			
	--  library cleaning
		(-- make same material with same property unique)
		(-- auto change name on material with same name)
			

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
		button upLibBT "refresh lib"
		listbox matLB "materials list:"
		button editMatBT "edit material"
		button loadMatBT "copy material"
-- 		button replaceMatBT "replace material" enabled: false
	)
	
	/*
	group "map material:"
	(
		button mapLibToEdBT "library => editor"  enabled: false
		button mapEdToLibBT "editor => library"  enabled: false
	)
	*/
	
-- 	actions
	on vrMatRlt open do
	(
		matLibLoaded = false
		
		-- init lobrary path
		if vrLibPath == undefined then
		(
			try 
			(
				vrLibPath = getINISetting armadasScriptsIni "vrMatLib" "DefaultMatLibPath"
			)
			catch()
		)
		
		-- load library
		if doesfileexist vrLibPath then
		(
			vrLib = loadTempMaterialLibrary vrLibPath
			matLibLoaded = true
			
			matAr = for mat in vrLib collect mat
		)
		else
		(
			vrLib = materialLibrary ()
		)
		
		/*
		-- collect material 
		for m in vrLib do
		(
			mTmp = matStruct mat: m
			append matColAr mTmp
		)
		
		-- collect material to display
		matDispAr = matColAr
		
		-- sort by name  material array to display
		qsort matColAr sortMatbyname
		*/
		
		/*
		-- refresh ui
		if matLibLoaded then
		(
			libPthBT.text = vrLibPath
			matLB.items = for mat in vrLib collect mat.name
		)
		else (libPthBT.text = "???")
		*/
		
		-- refresh ui 2
		if matLibLoaded then
		(
			libPthBT.text = vrLibPath
			matLB.items = for mat in matAr collect mat.name
		)
		else (libPthBT.text = "???")
	)
	
	on vrMatRlt close do
	(
		setINISetting armadasScriptsIni "vrMatLib" "DefaultMatLibPath" 	vrLibPath
	)
	
	on openLibBT pressed do
	(
		vrLibPath = getOpenFileName caption: "open material library" types: "mat(*.mat)|*.mat|All Files|*.*"
-- 		openFileName = fileOpenMatLib()
		print vrLibPath
		
		if vrLibPath != undefined do
		(
			vrLib = loadTempMaterialLibrary vrLibPath
			libPthBT.text = vrLibPath
			matLB.items = for mat in vrLib collect mat.name
		)
	)
	
	on saveLibBT pressed do
	( 
		if doesfileexist vrLibPath then
		(
			res = saveTempMaterialLibrary  vrLib vrLibPath
			if res do print "library saved"
		)
		else
		(
			print "path not valid"
		)
	)
	
	on saveAsLibBT pressed do
	(
		tmpPath = getSaveFileName caption: "save material library" types: "mat(*.mat)|*.mat|All Files|*.*"
		if tmpPath != undefined then
		(
			saveTempMaterialLibrary  vrLib tmpPath
		)
		else
		(
			print "path not valid"
		)
	)

	
	on upLibBT pressed do
	(
-- 		tmpLib = materialLibrary
-- 		vrLib = loadTempMaterialLibrary vrLibPath
		matLB.items = for mat in vrLib collect mat.name
	)
	
	on addMatBT pressed do
	(
		append  vrLib meditMaterials[activeMeditSlot]
		matLB.items = for mat in vrLib collect mat.name
	)
	
	on delMatBT pressed do
	(
		matName = matLB.selection
		deleteItem vrLib matName
		matLB.items = for mat in vrLib collect mat.name
	)
	 
	
	on editMatBT pressed do
	(
		matName = matLB.selected
		meditMaterials[activeMeditSlot] =  vrlib[matName]
	)
	
	on loadMatBT pressed do
	(
		matName = matLB.selected
		meditMaterials[activeMeditSlot] = copy vrlib[matName]
	)
	
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