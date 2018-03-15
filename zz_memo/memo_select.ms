
-- function
-- invert selection

fn invertSelFN obj =
(
	local allObjects = $* as array
	local ObjectSelected = obj as array

	for o in ObjectSelected collect
	(
		elt2del = findItem  allObjects o
		deleteItem allObjects elt2del
	)
	
	return allObjects
)

-- filter object visibles
fn ObjVisFN obj =
(
	local ObjectSelected = obj as array
	local VisObject = #()
	
	for o in ObjectSelected do
	(
		if (getUserProp o "VRay_Matte_Enable" != undefined) then
		(
			append VisObject o
		)
	)
	
	return VisObject
)

-- filtrer object with vrprop

fn VrPropFilterFN obj =
(
	local VRobject = #()
	local ObjectSelected = obj as array
	
	for o in ObjectSelected do
	(
		if (getUserProp o "VRay_Matte_Enable" != undefined) then
		(
			append VRobject o
		)
	)
	return VRobject
)

-- main

InvertSel = invertSelFN ($selection as array)
VisiblesObj = ObjVisFN InvertSel
VrInvertSel = VrPropFilterFN VisiblesObj

select VrInvertSel
