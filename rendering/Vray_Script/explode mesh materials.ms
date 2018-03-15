/*
maj:
	rajouter le nouvel objet sur le meme  calque que l'original
*/

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
	local splitObjList = #(s)
	-- debug de l objet
	resetpivot s
	if (InstanceMgr.CanMakeObjectsUnique sel) then (InstanceMgr.MakeObjectsUnique sel #prompt )

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
		format "id: % facelist: %\n" id (facelist as bitarray)
		
		local newMesh = meshop.detachFaces s faceList delete: true asMesh: true
		
		-- creation de la nouvelle mesh
-- 		format "res: %\n" res
		emesh = Editable_mesh() --create an empty Editable_mesh
		emesh.mesh = newMesh --assign the detached faces to the new mesh
		update emesh --update the mesh
		
		emesh.material = s.material[id]
		emesh.transform = s.transform
		
		append splitObjList emesh
	)
	s.material = s.material[1]
	update s
	
	splitObjList
)

sel =  selection as array
clearselection
for s in sel do
(
	objs = exploseMeshBymat s
	selectmore objs
)

-- $.pivot
-- $.objecttransform 
-- $.objectoffsetpos = [0,0,0] 

/*
-- explode mulitmat pour polygone
fn explodeMultiMatDef s matchMat: false=
(
	local idArray = getFacesID s
	local multiMtl = s.material 
	local splitObjList = #(s)
	
	for id in idArray do
	(
		local faceMax = meshop.getNumFaces s
		local faceList = #()
		
		if id != 1 do
		(
			local countBefore = objects.count
			
			faceList = for f to faceMax where  (getFaceMatID s i) == id collect f

			
			newName = uniquename (s.name + "_mat_" + (id as string))
				
-- 			polyop.detachFaces s #selection delete: true asNode: true name: newName
			meshop.detachFaces s faceList asMesh: true
			
			
			if matchMat then
			(
				local res = getnodebyname newName
				res.material = multiMtl[id]
				format "obj: %, \tmat: % \n" res.name multiMtl[id]
				append splitObjList res
			)
			
			
			-- copy/paste original modifier
			local contAfter = objects.count
-- 			format "count"
			mf = for m in  s.modifiers collect m
				
			for i = (countBefore + 1) to objects.count do
			(
				for m in s.modifiers do addmodifier objects[i] m
			)
			
		)
	)
	
	if matchMat then s.material = multiMtl[idArray[1]]
	format "explode material done: %\n" s
	splitObjList
)
*/








