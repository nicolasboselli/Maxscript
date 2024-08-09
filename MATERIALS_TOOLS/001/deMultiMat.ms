-- maj:
	-- x ajouter outil pour rajouter un uvw map cubique
	-- faire fonctionner le wirecolor sur une selection d'objet
	
	-- créer un custom convert physical mat to vray
	-- créer un custom ressource collector ?
	-- créer un custom clean multi mat
	
/*	
for s in $* where s.material == undefined do selectmore s
*/

filein "uvwsquare.ms"
filein "replace_inst_mat_in_slate.ms"
try(destroydialog repInstRLT)catch()


fn removeReflection = 
(
	vrMtlAr = getClassInstances vraymtl
	for m in vrMtlAr do 
	(
		format "m: % m.reflection: % \n" m.name m.reflection
		m.reflection = color 0 0 0
	)
)

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

fn convertMultiMat =
(
	multi = meditmaterials[activeMeditSlot]

	for i = 1 to multi.count do
	(
		if classof multi[i] == standard then
		(
			colref = multi[i].diffuse
			newMat = VRayMtl diffuse: colref name: multi[i].name
			multi[i] = newMat
		)
	)
)
-- convertMultiMat()

fn createMultiMat =
(
	meditmaterials[activeMeditSlot] = (multimaterial ())
)


fn tagMtlName tag=
(
	for m in scenematerials do
	(
		format "mat: %\n" m.name
		m.name =  tag + m.name
		format "mat: %\n" m.name
	)
)
-- tagMtlName "MATLOT_"

fn randomColorFN sel =
(
-- 	randomColor = color (random 0 255) (random 0 255) (random 0 255)
-- 	randomColor = random (color 50 50 50) (color 200 200 200) 
	sel.wirecolor =  random (color 50 50 50) (color 200 200 200) 
)

fn randomWireFN useFirstId: true =
(
	for mat in sceneMaterials do 
	(
		randomWire = color (random 0 255) (random 0 255) (random 0 255) 
		sel = objects as array
		for o in sel do 
		(
			if (superclassof o == GeometryClass) do 
			(
				if (classof o.material) == multimaterial and useFirstId == true then
				(
					if o.material[1] == mat  do o.wirecolor = randomWire
				)
				else if  o.material == mat then
				(
					o.wirecolor = randomWire
				)
			)
		)
	)
)

fn addUVWCube uvSize =
(
	local UvModExist = True
	local UvwSquare = Uvwmap  maptype: 4 length: uvSize width: uvSize  height: uvSize  axis: 2
	
	modPanel.addModToSelection (UvwSquare) ui:on
)

fn addUVWCube2 uvSize =
(
	
	local UvwSquare = Uvwmap  maptype: 4 length: uvSize width: uvSize  height: uvSize  axis: 2
	local sel = selection as array
	for s in sel do
	(
		local UvModExist = false
		for m in s.modifiers do
		(
			if classof m == Uvwmap then
			(
				UvModExist = true
-- 				UvwSquare = m
				m.length = uvSize
				m.width = uvSize
				m.height = uvSize
			)
			else
			(
-- 				addmodifier s UvwSquare
			)
		)
		
-- 		if not UvModExist then	modPanel.addModToSelection (UvwSquare) ui:on
		if not UvModExist then	addmodifier s UvwSquare -- ui:on
	)
	
	
)

-- make unique instance material
fn InstanceMatByName mat = (
	(for o in objects where o.mat != undefined and o.mat.name == mat.name collect o).mat = mat
)
 
-- collect id materials as array
fn idArrayDef s =
(
	local idArray = #()
	format "s: %\n" s
	local faceMax = s.GetNumFaces ()
	for i = 1 to faceMax do
	(
-- 		s.editablePoly.setSelection #face #{i}
		append idArray (s.editablePoly.GetFaceMaterial i)
	)
	return (sort(makeuniquearray idArray ))
)

-- explode mulitmat pour polygone
fn explodeMultiMatDef s matchMat: false=
(
	local idArray = idArrayDef s
	local multiMtl = s.material 
	local splitObjList = #(s)
	
	for id in idArray do
	(
		if id != 1 do
		(
			countBefore = objects.count
			s.selectByMaterial  id
			newName = uniquename (s.name + "_mat_" + (id as string))
			polyop.detachFaces s #selection delete: true asNode: true name: newName
			
			format "newNode: %\n"	newName
			
			if matchMat then
			(
				local res = getnodebyname newName
				if isvalidnode res then
				(
					res.material = multiMtl[id]
					format "obj: %, \tmat: % \n" res.name multiMtl[id]
					append splitObjList res
				)
				else(format "newNode unknow: %\n" newname)
			)
			
			
			-- copy/paste original modifier
			contAfter = objects.count
-- 			format "count"
			mf = for m in  s.modifiers collect m
			for i = (countBefore + 1) to objects.count do
			(
-- 				format "i :%\n" i
-- 				format "obj explode:%\n" objects[i]
				for m in s.modifiers do addmodifier objects[i] m
			)
			
		)
	)
	
	if matchMat then s.material = multiMtl[idArray[1]]
	format "explode material done: %\n" s
	splitObjList
)
-- explodeMultiMatDef $ matchMat: true


-- explose meshes
fn getFacesID s =
(
	local idArray = #()
	local faceMax = meshop.getNumFaces s
	for i = 1 to faceMax do appendifunique idArray (getFaceMatID s i)
	idArray
)

fn exploseMeshBymat s = 
(
	-- maj: mettre les morceaux sur le meme calque que l'objet unique
	local splitObjList = #(s)
	-- debug de l objet
	resetpivot s
	if (InstanceMgr.CanMakeObjectsUnique s) then (InstanceMgr.MakeObjectsUnique s #prompt )

	idArray = getFacesID s

	for id in idArray where id > 1 do
	(
		local new
		local faceMax = meshop.getNumFaces s
		local faceList = #()
		for f = 1 to faceMax do
		(
			if (getFaceMatID s f ) == id do append faceList f
		)
-- 		format "id: % facelist: %\n" id (facelist as bitarray)
		
		local newMesh = meshop.detachFaces s faceList delete: true asMesh: true
		
		-- creation de la nouvelle mesh
-- 		format "res: %\n" res
		emesh = Editable_mesh() --create an empty Editable_mesh
		emesh.mesh = newMesh --assign the detached faces to the new mesh
		update emesh --update the mesh
		
		emesh.material = s.material[id]
		emesh.transform = s.transform
		
		-- ajout des modifiers au nouvel objet créer
		for m in  s.modifiers do addmodifier emesh m
		
		-- collecte des nouveaux objets créés
		append splitObjList emesh
		
		-- ajout sur le meme calque
		s.layer.addnode emesh
	)
	s.material = s.material[1]
	update s
	
	splitObjList
)


-- refresh scenematerial
fn updateSceneMaterials =
 (
	 -- teste drive
	testAr = "jdc"
	local drive
	 for i = 1 to testAr.count do
	(
		dir = getDirectories (testAr[i] + ":*")
		
		if dir.count > 0 then
		(
			drive = testAr[i]
			exit
		)
	)
	-- ecriture du filename
	 str = stringstream ""
	 format "%:/tmp.max" drive to: str
	 str as string
	
	saveNodes #() (str as string)
	deleteFile  (str as string)
	
-- 	saveNodes #() "c:/tmp.max"
-- 	deleteFile "c:/tmp.max"
 )
-- updateSceneMaterials()

 
fn skinMultiMatdef s =
(
-- for one object
	-- count multimaterial number

	
	multiTmp = s.material.count
	
	-- count objet id
	idMax = 0
	faceMax = s.GetNumFaces ()
	for i = 1 to faceMax do
	(
		polyop.setFaceSelection s i
		if (s.getMaterialIndex true) > idMax do idMax = s.getMaterialIndex true
	)
	polyop.setFaceSelection s #none
	print idMax
	
	tmpMat
	-- pour chaque id de l'objet a partir de 2:
	for i = 2 to idMax do
	(
		tmpMat = s.material
		-- detach faces with one material
		s.selectByMaterial  i
		newName = uniquename (s.name + "_mat_" + (i as string))
		polyop.detachFaces s #selection delete: false asNode: true name: newName
		
		newSkin = getnodebyname newName
		
		-- option: split edge by smoothing group
		-- appliquer un shell sur le nouvel objet
		-- faire un outline sur l'objet
		-- rename object by material
		-- apply unique matching material
		newSkin.material = tmpMat[i]
	)
	
-- 	s.material = tmpMat[1]
)


fn isolateByMat mat sel isolate: true =
(
	clearselection()

	for s in sel do
	(
		if s.material == mat then
		(
			selectmore s
			if isolate then s.ishidden = false
		)
		else
		(
			if isolate then s.ishidden = true
		)
	)
)



fn countByMat mat sel =
(
	clearselection()
	local count  = 0
	for s in sel do
	(
		if s.material == mat then
		(
			count +=1
-- 			selectmore s
-- 			s.ishidden = false
		)
		else
		(
-- 			s.ishidden = true
		)
	)
	format "mat: % count: %\n" mat.name count
)



fn createVrMtl =
(
	meditMaterials[activeMeditSlot] = vraymtl()
)

fn createTile =
(
	meditMaterials[activeMeditSlot] = bricks()
)

-- remove materiel
fn removeMatDef =
(
	$.material = undefined
)


-- collect scene multimaterial
fn publishMatArray  matArray maxMatNum: 0 =
(
	local lastMatNum = maxMatNum + 24
	format "total: %, min: %, max: %\n" matArray.count maxMatNum lastMatNum 
	
	if  matArray.count  <= lastMatNum do
	(
		lastMatNum = matArray.count 
	)
	
	for i =  1 to 24 do
	(
		if matArray[i + maxMatNum] != undefined then
		(
			meditMaterials[i] = matArray[i + maxMatNum]
		)
		else
		(
			meditMaterials[i] = standard()
		)
	)
	
	#(matArray.count, lastMatNum)
)

fn collectClassOfMat classOfMat maxMatNum: 0 =
(
	local matArray = getclassinstances classOfMat target: scenematerials
	publishMatArray matArray maxMatNum: maxMatNum
)

fn collectMultiMatDef2 maxMatNum: 0 =
(
	local multimatArray = getclassinstances Multimaterial target: scenematerials
	publishMatArray multimatArray maxMatNum: maxMatNum
)

fn collectstandardMat maxMatNum: 0  =
(
	local standMatAr = getclassinstances standard target: sceneMaterials
	publishMatArray standMatAr maxMatNum: maxMatNum
)

fn publishSceneMatDef vrOnly: true  maxMatNum: 0 sortByName: false =
(
	local matToPubAr = #()

	-- collect scene material in array
	for i = 1 to sceneMaterials.count do
	(
		tmpMat = sceneMaterials[i]
		if classof tmpMat == vraymtl and vrOnly == true do
		(
			continue
		)
		append matToPubAr tmpMat
	)
	
	-- classe par ordre alphabetique
	if sortByName do qsort matToPubAr sortMatbyname 
	
	publishMatArray matToPubAr  maxMatNum: maxMatNum
)


fn convertToGGX =
(
	for i = 1 to sceneMaterials.count do
	(
		allVr = getClassInstances vraymtl
		for m in allVr do m.brdf_type = 4
	)
)
-- convertToGGX()

fn collectMatFromSel sel maxMatNum: 0 =
(
	local matAr = #()
-- 	for s in sel do print s
	for s in sel where s.material != undefined do appendifunique matAr s.material 
	
	publishMatArray matAr maxMatNum: maxMatNum
)

-- showproperties meditmaterials[activemeditslot]

-- convert standard to vray
fn convertToVrMatDef mat =
(
	local converted = false
	local vrmat
	
	if classof mat == Standard then
	(
		vrMat = VRayMtl diffuse: mat.diffuse name: mat.name texmap_diffuse: mat.diffuseMap texmap_opacity: mat.opacityMap
		converted = true
		
	)
	else if classof mat == VRayMtl then (format "nothing to do\n")
	else if classof mat == Autodesk_Material then 
	(
		vrMat = VRayMtl name: mat.name
		
		
		if matchpattern (getPropNames mat)[1] pattern: "Generic_*" then
		(
			if hasProperty mat "Generic_Color" do vrMat.diffuse = mat.Generic_Color
			if hasProperty mat "Generic_Image" do vrMat.texmap_diffuse = mat.Generic_Image
			converted = true
		)
		else if matchpattern (getPropNames mat)[1] pattern: "Masonry_Color*" then
		(
			if hasProperty mat "Masonry_Color" do vrMat.diffuse = mat.Masonry_Color
			if hasProperty mat "Masonry_Color_Map" do vrMat.texmap_diffuse = mat.Masonry_Color_Map
			converted = true
		)
		else if matchpattern (getPropNames mat)[1] pattern: "Wall_Paint*" then
		(
			if hasProperty mat "Wall_Paint_Color" do vrMat.diffuse = mat.Wall_Paint_Color
			converted = true
		)
		else if matchpattern (getPropNames mat)[1] pattern: "Plastic_*" then
		(
			if hasProperty mat "Plastic_Color" do vrMat.diffuse = mat.Plastic_Color
			if hasProperty mat "Plastic_Color_Map" do vrMat.texmap_diffuse = mat.Plastic_Color_Map
			converted = true
		)

		else if matchpattern (getPropNames mat)[1] pattern: "Metal*" then
		(
			if matchpattern (getPropNames mat)[1] pattern: "Metallic*" then
			(
				if hasProperty mat "Metallic_Paint_Color" do vrMat.diffuse = mat.Metallic_Paint_Color
				if hasProperty mat "Metallic_Paint_Color_Map" do vrMat.texmap_diffuse = mat.Metallic_Paint_Color_Map
				converted = true
-- 				vrMat.diffuse = mat.Metallic_Paint_Color
-- 				vrMat.texmap_diffuse = mat.Metallic_Paint_Color_Map
			)
			else
			(
				if hasProperty mat "Metal_Color" do vrMat.diffuse = mat.Metal_Color
				converted = true
-- 				vrMat.diffuse = mat.Metal_Color
			)
-- 			converted = true
		)
		else if matchpattern (getPropNames mat)[1] pattern: "Concrete*" then
		(
			if hasProperty mat "Concrete_Color" do vrMat.diffuse = mat.Concrete_Color
			if hasProperty mat "Concrete_Color_Map" do vrMat.texmap_diffuse = mat.Concrete_Color_Map
			converted = true
-- 			vrMat.diffuse = mat.Concrete_Color
		)
		else if matchpattern (getPropNames mat)[1] pattern: "Wood*" then
		(
			if  matchpattern (getPropNames mat)[1] pattern: "Wood_Image" then
			(
				if hasProperty mat "Wood_Stain_Color" do vrMat.diffuse = mat.Wood_Stain_Color
				if hasProperty mat "Wood_Image" do vrMat.texmap_diffuse = mat.Wood_Image
				converted = true
			)
			else
			(
				vrMat.diffuse = mat.Wood_Stain_Color
				vrMat.texmap_diffuse = mat.Wood_Image
			)
		)
		else if  matchpattern (getPropNames mat)[1] pattern: "Ceramic*" then
		(
			if hasProperty mat "Ceramic_Color"  do vrMat.diffuse = mat.Ceramic_Color
			if hasProperty mat "Ceramic_Color_Map" do vrMat.texmap_diffuse = mat.Ceramic_Color_Map
			converted = true
		)
		else if matchpattern (getPropNames mat)[1] pattern: "Glazing*"  then
		(
			if matchpattern (getPropNames mat)[1] pattern: "Glazing_Color"  then
			(
				if hasProperty mat "Glazing_Custom_Color" do vrMat.diffuse = mat.Glazing_Custom_Color
				if hasProperty mat "Glazing_Custom_Color_Map" do vrMat.texmap_diffuse = mat.Glazing_Custom_Color_Map
				converted = true
			)
			else if matchpattern (getPropNames mat)[1] pattern: "Glazing_Type" then
			(
				if hasProperty mat "Glazing_Color" do vrMat.diffuse = mat.Glazing_Color
			)
			else if matchpattern (getPropNames mat)[1] pattern: "Glazing_Custom*" then
			(
				if hasProperty mat "Glazing_Custom_Color" do vrMat.diffuse = mat.Glazing_Custom_Color
				if hasProperty mat "Glazing_Custom_Color_Map" do vrMat.texmap_diffuse = mat.Glazing_Custom_Color_Map
				converted = true
			)
			else()
		)
		
		else if  matchpattern (getPropNames mat)[1] pattern: "Masonry_Type" then
		(
			if hasProperty mat "Masonry_Color" do vrMat.diffuse = mat.Masonry_Color
			if hasProperty mat "Masonry_Color_Map" do vrMat.texmap_diffuse = mat.Masonry_Color_Map
			converted = true
		)
		else if  matchpattern (getPropNames mat)[1] pattern: "Solid_Glass_Color" then
		(
			if hasProperty mat "Solid_Glass_Custom_Color" do vrMat.diffuse = mat.Solid_Glass_Custom_Color
			if hasProperty mat "Solid_Glass_Custom_Color_Map" do vrMat.texmap_diffuse = mat.Solid_Glass_Custom_Color_Map
			converted = true
		)
		else if  matchpattern (getPropNames mat)[1] pattern: "Stone_Image" then
		(
			if hasProperty mat "Stone_Image" do vrMat.texmap_diffuse = mat.Stone_Image
			converted = true
		)
		else if matchpattern (getPropNames mat)[1] pattern: "Parameters_Color" then
		(
			if hasProperty mat "Generic_Color" do vrMat.diffuse = mat.Generic_Color
			converted = true
		)
		else if matchpattern (getPropNames mat)[1] pattern: "Parameters_Color_Option" then
		(
			if hasProperty mat "Parameters_Color" do vrMat.diffuse = mat.Parameters_Color
			if hasProperty mat "Parameters_Color_Map" do vrMat.texmap_diffuse = mat.Parameters_Color_Map
			converted = true
		)
		
		
		else
		(
			format "UNKNOW:%\n" (getPropNames mat)[1]
			showproperties 	mat
-- 			continue
		)
		
		if not converted then 
		(
			format "NOT CONVERTED:%\n" (getPropNames mat)[1]
			showproperties 	mat
-- 			continue
		)
-- 		replaceinstances mat vrMat
-- 		meditMaterials[1] = vrMat
	)
	else if classof mat == Architectural then
	(
		format "mat: % class: % \n" mat.name (classof mat) 
		vrMat = VRayMtl diffuse: mat.diffuse name: mat.name texmap_diffuse: mat.diffuseMap -- texmap_opacity: mat.opacityMap
	)
	else if iskindof mat PhysicalMaterial then 
	(
		format "	base_color: %\n" mat.base_color
		format "	base_color_map: %\n" mat.base_color_map
		vrMat = VRayMtl diffuse: mat.base_color name: mat.name texmap_diffuse: mat.base_color_map -- texmap_opacity: mat.opacityMap
		converted = true
	)
	else (format "UNKNOW mat: % class: % \n" mat.name (classof mat) )
	
	if converted then 
	(
		replaceinstances mat vrMat 
		format "CONVERTED: %\n" vrMat
	)
	else if not converted and vrmat!= undefined then 
	(
		meditMaterials[1] = vrMat
		format "CONFIRM CONVERSION: %\n" vrMat
	)
	else()
)

-- showproperties meditMaterials[activeMeditSlot]

-- convertToVrMatDef meditMaterials[activeMeditSlot]

-- classof meditMaterials[activeMeditSlot]
--  meditMaterials[activeMeditSlot].Metal_Color
-- matchpattern (getPropNames meditMaterials[activeMeditSlot])[1] pattern: "Generic_*"
-- meditMaterials[activeMeditSlot].Generic_Color_Option
-- classof meditMaterials[activeMeditSlot]
-- hasProperty meditMaterials[activeMeditSlot] #Generic_Color

-- for p in getPropNames meditMaterials[activeMeditSlot] do
-- format "% = %\n" p (getProperty meditMaterials[activeMeditSlot] p)

-- function to return good smooth grp id
fn convertToSmoothGrpDef num =
(
	if num == 1 then
	(
		return 1
	)
	else
	(
		return (num^0.5 + 1)
	)
)

fn splitSmthGrpDef s =
(
	facesCount = s.editablepoly.ConvertSelection #object #Face

	smoothGroupAr = #()
	for i = 1 to facesCount do
	(
		smoothGroupId = s.editablepoly.GetFaceSmoothingGroups i
	-- 	print smoothGroupId
		append smoothGroupAr  smoothGroupId
	-- 	smoothGroupAr = makeuniquearray smoothGroupAr
	)
	smoothGroupAr = makeuniquearray smoothGroupAr
	print smoothGroupAr

	for o in smoothGroupAr do
	(
		smthGrp = convertToSmoothGrpDef o
		s.editablepoly.selectBySmoothGroup smthGrp
		s.editablepoly.ConvertSelectionToBorder #face #edge
		s.editablepoly.splitEdges()
	)
)
-- splitSmthGrpDef $

-- ### collect same multi material
fn collectSameMultiMat3 matRef matSet=
(
-- 	matRef = $.material
	local sameMultiMatList = #(matRef)
	
	for m in matSet do
	(
		if (classof matRef == multimaterial) and (classof m == multimaterial)   then
		(
			if  m.numsubs == matRef.numsubs then
			(
				local collectMat = true
				
				if m == matRef then  collectMat = false
				
				for i = 1 to matRef.numsubs do
				(
					if matRef[i] != m[i] then 
					(
						collectMat = false 
					)
					else()
				)
				
				if collectMat then append sameMultiMatList m 
			)
		)
	)
	sameMultiMatList
)


fn collectObjByMat matRef objSet =
(
	local sameMultiMatObjList = #()
		
	for o in objSet where isvalidnode o do
	(
		if o.material == matRef do
		(
			append sameMultiMatObjList o
		)
	)
	sameMultiMatObjList
)

filein "empty_filename_sandbox.ms"

-- 	local param = #("pos")

try(closeRolloutFloater  theNewMaterialToolFloater)catch()
theNewMaterialToolFloater = newRolloutFloater "Materials Tools" 300 800
-- try(destroyDialog deMultiMatRLT)catch()
rollout deMultiMatRLT "Materials Tools"
(
	
	local lastManNum = 0
	local RFPos = [0,0]
	local RFSIze = [300,800]
	local params = #("RFPos", "RFSIze")
	
	
	group "wirecolor: "
	(
		button randColBT "random color"
		checkbox multiMatIDCB "use first id for multimaterial" checked: true
		button randomWireBT "wirecolor by material"
	)
	/*
	group "Multi-Materials:"
	(
		button collectMultiBT "collect multi-materials"
		button skinMatBT "skin multi-materials"
		button removeMatBT "remove material"
		button splitEdgeBT "split edges"
		
	)
	*/
	group "remove"
	(
		button removeMatBT "remove material"
	)
	
	group "explode multi-Materials:"
	(
		checkbox matchMatCB "match materials" across:2
		button explodeBT "explode by material"
		button explodeMeshBT "explode mesh by material"
	)
	
	group "scene Materials:"
	(
		button refreshBT "refresh scene materials" across:2
		checkbox vronlyCB "ignore vray materials"
		
		button publishSceneMatBT "publish scene materials" across:2
		button listSceneMatBT "list scene materials"
	)
		
	group "missing :"
	(
		button editMissBmpBT "edit bitmap" across: 2
		button editMissDllBT "edit Dll"
		button editRaytraceBT "edit raytrace" across: 2
		button emptyFilenameBT "empty filename"
	)
	
	group "class materials"
	(
-- 		button collectMultiBT "publish multi-materials"
-- 		button publishStandMatBT "publish standard materials"
		listbox matLB "mat class:" items: #("standard", "Multimaterial","Double_Sided", "vraymtl", "Autodesk_Material", "Architectural")
		button publishMatBT "publish"
	)
	
	group "rename:"
	(
		edittext prefixET "pref:"
		button addPrefBT "add"
	)
	
	group "Vray Material:"
	(
		button createVrMtlBT "create vray material" across:2
		button createMultiBT "create multi-mat" 
		button convertToVrBT "convert to vray mat" across:2
		button okConvertBT "confirm" 
		
		button convertAllMatToVrBT "convert All standards to vray mat" -- across:2
		button convertAutodeskToVrBT "convert Autodesk Materials to vray mat" -- across:2
		button convertAllMatToGGXBT "convert All Vray mat to GGX" -- across:2
		button convertPhysicalToVrmatXBT "convert All physical mat to VrMat" -- across:2
		
		
		button removeReflectionBT "remove reflection"
		
-- 		button showBT "show properties"

-- 		button collectVrMtlBT "collect material"
-- 		button createTileBT "create tile"
	)
	
	group "collect materials... "
	(
		button collectSelMatBT " of the selection"
	)
	
	group "select objects with medit mat only"
	(
		button isolateByMatBT "in scene" across:2
		button isolateByMat2BT "in visibles objects "
-- 		checkbox isolateCB "isolate"
	)
-- 	
-- 	group "count sel medit material..."
-- 	(
-- 		button countBymatBT "in visibles objects "
-- 	)
-- 	
-- 	group "count all medit material..."
-- 	(
-- 		button countAllmatBT "in visibles objects "
-- 	)
	
-- 	group "uvw mapping box:"
-- 	(
-- 		button uv100 "100" across: 3
-- 		button uv250 "250"
-- 		button uv500 "500"
-- 	)
	
	on deMultiMatRLT open do
	(
		local RLTvers = getScriptVersion (getThisScriptFilename())
		format "RLTvers:%\n" RLTvers
		if RLTvers != undefined then theNewMaterialToolFloater.title = theNewMaterialToolFloater.title + " v." + (RLTvers as string)
			
		loadRolloutParams deMultiMatRLT params
		theNewMaterialToolFloater.pos = ( RFPos)
		theNewMaterialToolFloater.size = ( RFSIze)
	)
	
	on deMultiMatRLT close do
	(
-- 		format "ahhhh!: % \n" theNewMaterialToolFloater.pos
		RFPos = theNewMaterialToolFloater.pos
		RFSIze = theNewMaterialToolFloater.size
		writeRolloutParams deMultiMatRLT params
	)
		
	on randColBT pressed do
	(
		for s in selection do randomColorFN s
	)
	
	on randomWireBT pressed do
	(
		randomWireFN useFirstId: multiMatIDCB.state
	)
	
	on collectMultiBT pressed do
	(
		local compare = collectMultiMatDef2 maxMatNum: lastManNum
		local sceneCount = compare[1]
		lastManNum = compare[2]
		if  lastManNum >= sceneCount then lastManNum = 0
	)
	
	on collectSelMatBT pressed do
	(
		sel = selection as array
-- 		collectMatFromSel sel
		
		local compare = collectMatFromSel sel maxMatNum: lastManNum
		local sceneCount = compare[1]
		lastManNum = compare[2]
		if  lastManNum >= sceneCount then lastManNum = 0
		
	)
	
	on explodeBT pressed do 
	(
		sel = selection as array
		
		for s in sel where classof s.material == multimaterial do
		(
			local returnTomesh = false
			if classof s == Editable_mesh then
			(
				converttopoly s
				returnTomesh = true
			)
			
			local splitObj = explodeMultiMatDef s  matchMat: matchMatCB.state
			
			if returnToMesh then
			(
				for o in splitObj do convertToMesh  o
			) else()
		)
	)
	
	on explodeMeshBT pressed do
	(
		sel = selection as array
		for s in sel where classof s.material == multimaterial do
		(
			if classof s.baseobject == Editable_mesh then exploseMeshBymat s
			else if iskindof s.baseobject editable_poly then 
			(
				addmodifier s  (Edit_Mesh ()) before: s.modifiers.count
				maxOps.CollapseNodeTo s s.modifiers.count true
				exploseMeshBymat s
			)
			else(format "classe à traiter: %\n" (classof s.baseobject ))
		)
	)

	on skinMatBT pressed do 
	(
		sel = selection as array
		for s in sel do
		(
			if (classof s.material) == multimaterial do
			(
				undo on
				(
					skinMultiMatdef s
				)
			)
		)
	)
	
	on splitEdgeBT pressed do
	(
		sel = selection as array
		
		for s in sel do
		(
			undo on
			(
				splitSmthGrpDef s
			)
		)
	)
	
	on removeMatBT pressed do removeMatDef()
	
	on  refreshBT pressed do 
	(
		lastManNum = 0
		updateSceneMaterials()
	)

	on publishSceneMatBT pressed do
	(
-- 		print "youhou"
		local compare = publishSceneMatDef vronly: vronlyCB.state maxMatNum: lastManNum sortbyname: true
		local sceneCount = compare[1]
		lastManNum = compare[2]
		if  lastManNum >= sceneCount then lastManNum = 0
		
-- 		print (format "compare : %\n" compare)
	)
	
	on listSceneMatBT pressed do
	(
		local matAr = for mat in scenematerials collect mat
		qsort matAr sortMatbyname
		for m in matAr do format "name: % class: %\n" m.name (classof m)
	)
	
	on editMissBmpBT pressed do
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
	
	on editMissDllBT pressed do
	(
		-- get list of missing plugin classes
		str = stringStream ""
		apropos "*missing*" to:str
		seek str 0
		cls = #()
		while not (eof str) do (
			ln = readLine str
			tk = filterString ln " "
			if tk.count == 4 then (
				clsName = tk[1]
				try (
					val = (execute clsName)
					sc = superClassOf val
					-- Alternative: check for .classID == #(-1,0)
					if sc==MAXWrapper or sc==node or sc==material or sc==MAXWrapperNonRefTarg then (
						append cls val
						format "%: %\n" c val
					) else (
						format "Skipping % (%)\n" val sc
					)
				) catch (
					format "Cannot use % for searching missing plugins.\n" clsName
				)
			) 
			else
			(
				format "Incorrect string found in missing plugin name list: %\n" tk
			)
		)


		-- now search for instances of those missing plugins
		c = 0
		local k = 0
		missingClasses = #()
		foundMissing = #()
		for j = 1 to cls.count do
		(
			cc = cls[j]
			ci = getClassInstances cc
			if ci.count > 0 then 
			(
				format "%: Found % instances of %: %\n" j ci.count cc ci
				for c in ci do 
				(
					format "%\n" (classof c)
					reff = refs.dependents c
					format "reff: %\n" reff
					for r in reff where superclassof r == material do
					(
						k += 1
						if k <= 24 then meditmaterials [k] = r
						format "k: % mat: %\n"k r
					)
-- 					if k == 24 then exit
				)
-- 				if k == 24 then exit
			) 
-- 			if k == 24 then exit
		) 
		format "total incompatible materials: %\n" k
	)
	
	on editRaytraceBT pressed do
	(
		
		-- edit material avec du raytrace
		rayTraceAr = getclassinstances raytrace 
		for r in rayTraceAr do
		(
			maps = refs.dependents r
			i = 0
			if maps != undefined and maps.count>0 then
			(
				for m in maps where superclassof m == material do
				(
					i += 1
					meditmaterials [i] = m
			-- 		print m
				)
			)
			else(format "no raytrace\n")
		)

	)
	
	on emptyFilenameBT pressed do
	(
		collectEmptyFilenameBitmap()
	)
	
	on publishStandMatBT pressed do
	(
		local compare = collectstandardMat maxMatNum: lastManNum
		local sceneCount = compare[1]
		lastManNum = compare[2]
		if  lastManNum >= sceneCount then lastManNum = 0
	)
	
	on publishMatBT pressed do
	(
		local classOfMat
-- 		format "sel: %\n"  matLB.selection
		
		if matLB.selection == 1 then  classOfMat = standard 
		else if  matLB.selection == 2 then classOfMat = multimaterial 
		else if  matLB.selection == 3 then classOfMat = DoubleSided
		else if  matLB.selection == 4 then classOfMat =	vraymtl
		else if  matLB.selection == 5 then classOfMat =	Autodesk_Material
		else if  matLB.selection == 6 then classOfMat =	Architectural
		else(format "UNKNOW\n")
		
		local compare = collectClassOfMat classOfMat maxMatNum: lastManNum
		local sceneCount = compare[1]
		lastManNum = compare[2]
		if  lastManNum >= sceneCount then lastManNum = 0
	)
	
	on convertToVrBT pressed do 
	(
		convertToVrMatDef meditMaterials[activeMeditSlot]
	)
	
	
	on convertAllMatToVrBT pressed do
	(
		local matAr = getclassinstances standard target: scenematerials
-- 		format "count: % matAr: %\n" matAr.count matAr
		for m in matAr do
		(
			format "convert: %\n" m
			convertToVrMatDef m
		)
	)
	
	on convertAutodeskToVrBT pressed do
	(
		local matAr = getclassinstances Autodesk_Material target: scenematerials
-- 		format "count: % matAr: %\n" matAr.count matAr
		for m in matAr do
		(
			format "start convert: %\n" m
			convertToVrMatDef m
		)
	)
	
	on convertPhysicalToVrmatXBT pressed do
	(
		local matAr = getclassinstances PhysicalMaterial target: scenematerials
		
		for m in matAr do
		(
			format "\nstart convert physical mat: %\n" m
			convertToVrMatDef m
		)
	)
		
	on convertAllMatToGGXBT pressed do
	(
		convertToGGX()
	)
	
	on removeReflectionBT pressed do
	(
		removeReflection()
	)
	
	on okConvertBT pressed do
	(
		replaceinstances meditMaterials[activeMeditSlot]  meditMaterials[1]
	)
	
	on createMultiBT pressed do
	(
		createMultiMat()
	)
	
	on showBT pressed do showproperties meditMaterials[activeMeditSlot]
	
	on publishSceneMat2BT pressed do publishSceneMatAdvDef()
	
	on createVrMtlBT pressed do createVrMtl()
	
	on createTileBT pressed do createTile()
	
	on addPrefBT pressed do
	(
		meditMaterials[activeMeditSlot].name = prefixET.text + "_" + meditMaterials[activeMeditSlot].name
	)
	
	
	on isolateByMatBT pressed do
	(
		visSel = $* as array
-- 		isolateByMat meditMaterials[activeMeditSlot] sel isolate: isolateCB.state
		
		sel = collectObjByMat meditmaterials[activeMeditSlot] visSel
		select sel
		
	)
	
	on isolateByMat2BT  pressed do
	(
		visSel =  for o in  $* where o.ishidden == false collect o
-- 		isolateByMat meditMaterials[activeMeditSlot] sel isolate: isolateCB.state
		
		visSel = for o in  $* where o.ishidden == false collect o
		sel = collectObjByMat meditmaterials[activeMeditSlot] visSel
		select sel
	)
	
	on countbyMatBT pressed do
	(
		sel =  for o in  $* where o.ishidden == false collect o
		countByMat meditMaterials[activeMeditSlot] sel
	)
	
	on countAllmatBT pressed do
	(
		sel =  for o in  $* where o.ishidden == false collect o
		mediMat = for m in meditMaterials collect m
		
		for i = 1 to medimat.count do
		(
			countByMat medimat[i] sel
			format "i: %\n" i
		)
	)	
	
	
)
-- createdialog deMultiMatRLT


addRollout deMultiMatRLT theNewMaterialToolFloater
addRollout repInstRLT theNewMaterialToolFloater
addRollout UVSquareRLT theNewMaterialToolFloater

