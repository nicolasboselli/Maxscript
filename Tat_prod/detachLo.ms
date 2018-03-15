tag = "Queue_16"
$.material = undefined

nameAr = filterString  s.name "_"
newname = nameAr[1] + "_" + nameAr[2] + "_" + tag + "_"  + nameAr[3]

face = polyop.getFaceSelection s
elt = polyop.getElementsUsingFace s face
polyop.detachFaces s elt delete: true asNode: true name: newname 

eltsAr = #()
facesNum = polyop.getNumFaces s 
for i = 1 to facesNum do
(
	elt = polyop.getElementsUsingFace s #{i}
	appendifunique eltsAr elt
)

-- Detach element un par un

fn detachElt s =
(
	if s != undefined then
	(
		if i == undefined then i = 0
		try
		(
			elt = polyop.getElementsUsingFace s 1
			
			basename = substitutestring  s.name "_LO" ""
			objName = basename + "_"+ "obj"+ (i as string) +  "_LO"

			polyop.detachFaces s elt delete: true asNode: true name: objName

			res = getnodebyname "objTmp"
			i +=1
			
			res
		)
		catch
		(
			i = undefined
			delete s
		)
	)
)
for s in selection do detachElt s




sel = selection as array
for s in sel do 
(
	print sel
	detachElt s
	print s
)

for s in sel do
(
	detachElt s
	append sel s
)


-- rename lo as parent

fn renameAsParent s =
(
	parentName = s.parent.name
	s.name = substitutestring parentName "_CTRL" "_MDL_LO"
)
for s in selection do renameAsParent s

-- combine in one mesh
Fn Fn_AttachSingleMesh list: = 
(
	undo on
	(
		local ep = editable_mesh name:list[1].name
		convertTo ep Editable_Poly

		for o in list do ep.EditablePoly.attach o ep 
		
		ep
	)
)

ep = Fn_AttachSingleMesh list: (selection as array)
select ep