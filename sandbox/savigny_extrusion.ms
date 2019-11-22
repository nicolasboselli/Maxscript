for o in objects do
(
	try
	(
		if (iskindof o.extrude extrude) then
		(
			format "extrusion: %\n" o.name
			deletemodifier o o.extrude
			addmodifier o (edit_poly())
		)
	)
	catch(/*format "no extrusion: %\n" o.name*/)
)

-- deletemodifier $ $.extrude


for o in objects where iskindof o PolyMeshObject do
(
	format "o: %\n" o.name
)


-- classof $.baseobject