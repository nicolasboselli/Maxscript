rem = MaxOps.GetCurRenderElementMgr ()
num = rem.NumRenderElements ()

elts_array = #()
for i = 0 to (num - 1) do
(
	elt = rem.GetRenderElement i

	if iskindof elt multimatteElement then
	(
		eltPartName = filterString elt.elementName "_"
		if not eltPartName.count == 3 then exit 
		if not MatchPattern eltPartName[1] pattern: "ObjId" then exit
		else
		(
			format "id: % name: %\n" (eltPartName[2] as integer) eltPartName[3]
		)
	)
)


