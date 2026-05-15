/*
	autoFaceGroupToSpline.ms
	
	Regroupe automatiquement toutes les faces d'un Edit_Poly / Editable_Poly
	par orientation (faces connectées dans un seuil d'angle),
	puis extrait une spline de bordure pour chaque groupe.
	
	Les faces isolées (sans voisine dans le seuil) sont regroupées
	par orientation similaire dans un groupe commun "isolated".
*/

-- ============================================================
-- utilitaire : angle entre deux normales (en degrés)
-- ============================================================
fn angleBetweenNormals n1 n2 =
(
	local d = dot (normalize n1) (normalize n2)
	d = amax -1.0 (amin 1.0 d)  -- clamp pour éviter NaN sur acos
	acos d
)

-- ============================================================
-- collecte les faces adjacentes à une face via ses edges
-- retourne un array d'ids de faces voisines
-- ============================================================
fn getAdjacentFaces s ep isEditablePoly faceId =
(
	local adjFaces = #()
	if isEditablePoly then
	(
		-- Editable_Poly : polyop.*
		local edgeBit = polyop.getFaceEdges s faceId
		for edgeId in (edgeBit as array) do
		(
			local faceBit = polyop.getEdgeFaces s edgeId
			for nId in (faceBit as array) do
				if nId != faceId then append adjFaces nId
		)
	)
	else
	(
		-- Edit_Poly modifier : méthodes directes
		local edgeCount = ep.GetFaceEdgeCount faceId
		for i = 1 to edgeCount do
		(
			local edgeId = ep.GetFaceEdge faceId i
			local faceCount = ep.GetEdgeFaceCount edgeId
			for j = 1 to faceCount do
			(
				local neighborId = ep.GetEdgeFace edgeId j
				if neighborId != faceId then append adjFaces neighborId
			)
		)
	)
	adjFaces
)

-- ============================================================
-- fonction principale
-- ============================================================
fn autoFaceGroupToSpline angleThreshold:15.0 =
(
	-- ---- récupération de l'objet et du modifier ----
	local sel = selection as array
	if sel.count == 0 do
	(
		messageBox "Sélectionne un objet." title:"autoFaceGroupToSpline"
		return undefined
	)
	local s = sel[1]
	local ep

	local curObj = modPanel.getCurrentObject()
	if classof curObj == Editable_Poly then
		ep = s
	else if classof curObj == Edit_Poly then
		ep = s.edit_poly
	else
	(
		messageBox "L'objet doit avoir un modifier Edit_Poly ou être un Editable_Poly." title:"autoFaceGroupToSpline"
		return undefined
	)

	-- ---- collecte de toutes les faces ----
	local totalFaces
	if classof curObj == Editable_Poly then
		totalFaces = polyop.getNumFaces s
	else
		totalFaces = ep.GetNumFaces()
	if totalFaces == 0 do
	(
		messageBox "Aucune face trouvée." title:"autoFaceGroupToSpline"
		return undefined
	)
	format "autoFaceGroupToSpline : % faces à traiter\n" totalFaces

	-- flag pour dispatcher les appels API selon le type
	local isEditablePoly = (classof curObj == Editable_Poly)

	-- ---- précalcul des normales ----
	local normals
	if isEditablePoly then
		normals = for i = 1 to totalFaces collect polyop.getFaceNormal s i
	else
		normals = for i = 1 to totalFaces collect ep.GetFaceNormal i

	-- ---- flood fill : groupement par faces connectées + seuil d'angle ----
	-- groupId[i] == 0  => non traité
	local groupIds   = for i = 1 to totalFaces collect 0
	local groups     = #()   -- groups[g] = array of face ids
	local currentGroup = 0

	local unvisited = #{1..totalFaces}   -- bitarray de toutes les faces

	while unvisited.numberSet > 0 do
	(
		-- prend la première face non visitée
		-- unvisited[1] retourne true/false en MAXScript, pas l'index
		-- on itère le bitarray pour récupérer le premier index actif
		local seedId = 0
		for id in unvisited do ( seedId = id ; exit )
		-- retire la seed
		unvisited[seedId] = false

		currentGroup += 1
		local grp = #(seedId)
		groupIds[seedId] = currentGroup

		-- stack pour le flood fill
		local stack = #(seedId)

		while stack.count > 0 do
		(
			local current = stack[stack.count]
			stack.count = stack.count - 1

			local neighbors = getAdjacentFaces s ep isEditablePoly current

			for nId in neighbors do
			(
				if unvisited[nId] then
				(
					local ang = angleBetweenNormals normals[current] normals[nId]
					if ang <= angleThreshold then
					(
						unvisited[nId] = false
						groupIds[nId] = currentGroup
						append grp nId
						append stack nId
					)
				)
			)
		)

		append groups grp
	)

	format "% groupes trouvés\n" groups.count

	-- ---- sépare les isolées des groupes normaux ----
	-- une face isolée = groupe de 1 seule face
	-- on les regroupe par orientation similaire dans des "super-groupes isolés"
	local normalGroups  = #()   -- groupes avec > 1 face
	local isolatedFaces = #()   -- faces seules

	for grp in groups do
	(
		if grp.count > 1 then
			append normalGroups grp
		else
			append isolatedFaces grp[1]
	)

	format "% groupes normaux, % faces isolées\n" normalGroups.count isolatedFaces.count

	-- regroupe les faces isolées par orientation (seuil identique)
	local isolatedGroups = #()
	local isolatedAssigned = for i = 1 to isolatedFaces.count collect false

	for i = 1 to isolatedFaces.count do
	(
		if not isolatedAssigned[i] then
		(
			local iGrp = #(isolatedFaces[i])
			isolatedAssigned[i] = true
			for j = i+1 to isolatedFaces.count do
			(
				if not isolatedAssigned[j] then
				(
					local ang = angleBetweenNormals normals[isolatedFaces[i]] normals[isolatedFaces[j]]
					if ang <= angleThreshold then
					(
						append iGrp isolatedFaces[j]
						isolatedAssigned[j] = true
					)
				)
			)
			append isolatedGroups iGrp
		)
	)

	-- fusion : tous les groupes à traiter
	local allGroups = normalGroups
	for ig in isolatedGroups do append allGroups ig

	format "% groupes au total après fusion des isolées\n" allGroups.count

	-- ---- extraction d'une spline par groupe ----
	local allShapes = #()

	for g = 1 to allGroups.count do
	(
		local grp = allGroups[g]

		-- construit le bitarray de sélection
		local faceBit = #{}
		for fId in grp do faceBit[fId] = true

		-- applique la sélection de faces
		if isEditablePoly then
		(
			polyop.setFaceSelection s faceBit
			subobjectLevel = 4
			s.ConvertSelectionToBorder #Face #Edge
			subobjectLevel = 2
		)
		else
		(
			ep.setSelection #face faceBit
			subobjectLevel = 4
			ep.ConvertSelectionToBorder #Face #Edge
			subobjectLevel = 2
		)

		-- nom basé sur la normale moyenne du groupe
		local avgNormal = [0,0,0]
		for fId in grp do avgNormal += normals[fId]
		avgNormal = normalize avgNormal

		local shapeName = uniqueName (s.name + "_grp" + (g as string) + "_shape")

		-- snapshot des handles avant
		local handlesBefore = for o in objects collect getHandleByAnim o

		-- extraction
		if isEditablePoly then
			s.createShape shapeName false s
		else
			ep.CreateShape shapeName

		-- collecte la nouvelle shape
		local newShapes = for o in objects where (findItem handlesBefore (getHandleByAnim o)) == 0 collect o
		for ns in newShapes do
		(
			updateshape ns
			append allShapes ns
		)

		format "groupe % : % faces -> shape '%'\n" g grp.count shapeName
	)

	-- remet le subobjectLevel à 0
	subobjectLevel = 0
	select allShapes

	format "autoFaceGroupToSpline terminé : % splines créées\n" allShapes.count
	allShapes
)

-- ============================================================
-- UI
-- ============================================================
try(destroyDialog autoFaceGroupRLT)catch()

rollout autoFaceGroupRLT "Auto Face Groups to Spline"
(
	spinner angleSP "Seuil d'angle (°):" range:[0.1, 180.0, 15.0] type:#float fieldWidth:50
	button runBT "Extraire les splines" width:160 height:30

	on runBT pressed do
	(
		autoFaceGroupToSpline angleThreshold: angleSP.value
	)
)

createDialog autoFaceGroupRLT width:200
