s = $

ep = editable_mesh name:(uniquename"EPoly") transform:  s.transform --create an empty EMesh
convertTo ep Editable_Poly --convert to Editable_Poly

vCount = polyop.getNumEdges s

for i = 1 to vCount do
(
	local extrudeEdge = false
	
	local border = false
	if (polyop.getBorderFromEdge s i).count > 0 then border = true
	
	local edgeFaces = polyop.getEdgeFaces s i
	local idsMat = for f in edgeFaces collect (polyop.getFaceMatID s f)
	local idsMatDef = makeuniquearray idsMat
	
	doPoly = #()
	-- check turn 1
	if border then 
	(
		append doPoly 1
	)
	else 
	(
		append doPoly 0
	)
	
	-- check turn 2
	if finditem idsMat 1 and finditem idsMat 2 then
	(
		append doPoly 1
	)
	else if finditem idsMat 1 and finditem idsMat 3 then
	(
		append doPoly 1
	)
	else append doPoly 0
	
	-- check turn 3
	if finditem idsMat 1 then append doPoly 1
		
	
	else append doPoly 0
	if idsMatDef.count > 1 then
	(
		-- trouver l'oreintation de la normale
		extrudeEdge = true
	)
	
	if border then
	(
		-- trouver l'oreintation de la normale
		extrudeEdge = true
	)
	
	-- actions
	--tour 1
	if border then
	(
		local edgeVerts = polyop.getEdgeVerts s i
		v1 = polyop.createVert ep (polyop.getVert s edgeVerts[1])
		v2 = polyop.createVert ep (polyop.getVert s edgeVerts[2])
		
		v3 = polyop.createVert ep ((polyop.getVert s edgeVerts[2]) + [0,0,z])
		v4 = polyop.createVert ep ((polyop.getVert s edgeVerts[1]) + [0,0,z])
		polyop.createPolygon ep #(v1,v2,v3,v4)
	)	
	
	if idsMatDef.count > 1 then
	(
		idMax = amax idsMatDef 
	)
	
	(
		format "edges: % faces id: % border: %\n" i idsMat border
		
		if border then
		(
			local edgeVerts = polyop.getEdgeVerts s i
			v1 = polyop.createVert ep (polyop.getVert s edgeVerts[1])
			v2 = polyop.createVert ep (polyop.getVert s edgeVerts[2])
			
			v3 = polyop.createVert ep ((polyop.getVert s edgeVerts[2]) + [0,0,z])
			v4 = polyop.createVert ep ((polyop.getVert s edgeVerts[1]) + [0,0,z])
			polyop.createPolygon ep #(v1,v2,v3,v4)
		)		
	)
)
select ep



