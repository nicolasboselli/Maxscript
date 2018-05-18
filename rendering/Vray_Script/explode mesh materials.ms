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
-- clearselection()
newSel = #()
for s in sel do
(
	objs = exploseMeshBymat s
	for o in objs do append newsel o
)
select newsel






