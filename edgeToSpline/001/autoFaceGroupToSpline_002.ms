/*
	autoFaceGroupToSpline.ms
	v002

	Regroupe automatiquement les faces d'un Edit_Poly / Editable_Poly
	par orientation (faces connectées dans un seuil d'angle),
	puis extrait une spline de bordure pour chaque groupe.

	Modifications v002 :
	- Fonctionne sur une sélection de faces OU sur toutes les faces de l'objet
	- Ignore les faces dont la normale pointe vers le bas (paramétrable via seuil Z)
	- Les faces isolées sont regroupées par orientation similaire
*/

-- ============================================================
-- utilitaire : angle entre deux normales (en degrés)
-- ============================================================
fn angleBetweenNormals n1 n2 =
(
	local d = dot (normalize n1) (normalize n2)
	d = amax -1.0 (amin 1.0 d)
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
-- angleThreshold : seuil d'angle entre normales pour regrouper (degrés)
-- downFaceThreshold : Z minimum de la normale pour garder une face
--   ex: 0.0  = ignore tout ce qui pointe sous l'horizontale
--       -1.0 = garde tout (désactivé)
-- ============================================================
fn autoFaceGroupToSpline angleThreshold:15.0 downFaceThreshold:0.0 =
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

	local isEditablePoly = (classof curObj == Editable_Poly)

	-- ---- détermine le pool de faces à traiter ----
	-- si des faces sont sélectionnées on travaille sur elles,
	-- sinon sur toutes les faces de l'objet
	local facePool  -- bitarray
	local selFaces
	if isEditablePoly then
		selFaces = polyop.getFaceSelection s
	else
		selFaces = ep.getSelection #face

	local totalFaces
	if isEditablePoly then
		totalFaces = polyop.getNumFaces s
	else
		totalFaces = ep.GetNumFaces()

	if totalFaces == 0 do
	(
		messageBox "Aucune face trouvée." title:"autoFaceGroupToSpline"
		return undefined
	)

	if selFaces.numberSet > 0 then
	(
		facePool = selFaces
		format "autoFaceGroupToSpline v002 : % faces sélectionnées\n" selFaces.numberSet
	)
	else
	(
		facePool = #{1..totalFaces}
		format "autoFaceGroupToSpline v002 : % faces (objet entier)\n" totalFaces
	)

	-- ---- précalcul des normales pour toutes les faces du pool ----
	local normals = #()
	normals[totalFaces] = undefined  -- pré-alloue
	for fId in facePool do
	(
		if isEditablePoly then
			normals[fId] = polyop.getFaceNormal s fId
		else
			normals[fId] = ep.GetFaceNormal fId
	)

	-- ---- filtre les faces qui pointent vers le bas ----
	-- on retire du pool les faces dont la composante Z de la normale < downFaceThreshold
	local skipped = 0
	local filteredPool = #{}
	for fId in facePool do
	(
		if normals[fId].z >= downFaceThreshold then
			filteredPool[fId] = true
		else
			skipped += 1
	)
	format "% faces ignorées (normale vers le bas, seuil Z = %)\n" skipped downFaceThreshold

	if filteredPool.numberSet == 0 do
	(
		messageBox "Toutes les faces ont été filtrées. Ajuste le seuil Z." title:"autoFaceGroupToSpline"
		return undefined
	)

	-- ---- flood fill : groupement par faces connectées + seuil d'angle ----
	local groupIds = #{}  -- bitarray des faces déjà visitées
	local groups   = #()
	local currentGroup = 0

	local unvisited = copy filteredPool  -- on travaille sur une copie

	while unvisited.numberSet > 0 do
	(
		local seedId = 0
		for id in unvisited do ( seedId = id ; exit )
		unvisited[seedId] = false

		currentGroup += 1
		local grp = #(seedId)

		local stack = #(seedId)

		while stack.count > 0 do
		(
			local current = stack[stack.count]
			stack.count = stack.count - 1

			local neighbors = getAdjacentFaces s ep isEditablePoly current

			for nId in neighbors do
			(
				-- le voisin doit être dans le pool filtré et non encore visité
				if filteredPool[nId] and unvisited[nId] then
				(
					local ang = angleBetweenNormals normals[current] normals[nId]
					if ang <= angleThreshold then
					(
						unvisited[nId] = false
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
	local normalGroups  = #()
	local isolatedFaces = #()

	for grp in groups do
	(
		if grp.count > 1 then
			append normalGroups grp
		else
			append isolatedFaces grp[1]
	)

	format "% groupes normaux, % faces isolées\n" normalGroups.count isolatedFaces.count

	-- regroupe les faces isolées par orientation similaire
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

		local faceBit = #{}
		for fId in grp do faceBit[fId] = true

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

		local shapeName = uniqueName (s.name + "_grp" + (g as string) + "_shape")

		local handlesBefore = for o in objects collect getHandleByAnim o

		if isEditablePoly then
			s.createShape shapeName false s
		else
			ep.CreateShape shapeName

		local newShapes = for o in objects where (findItem handlesBefore (getHandleByAnim o)) == 0 collect o
		for ns in newShapes do
		(
			updateshape ns
			append allShapes ns
		)

		format "groupe % : % faces -> shape '%'\n" g grp.count shapeName
	)

	subobjectLevel = 0
	select allShapes

	format "autoFaceGroupToSpline v002 terminé : % splines créées\n" allShapes.count
	allShapes
)

-- ============================================================
-- UI
-- ============================================================
try(destroyDialog autoFaceGroupRLT)catch()

rollout autoFaceGroupRLT "Auto Face Groups to Spline v002"
(
	group "Paramètres"
	(
		spinner angleSP    "Seuil angle (°):"   range:[0.1, 180.0, 15.0]  type:#float fieldWidth:50 align:#right
		spinner downZSP    "Seuil Z normal.:"   range:[-1.0, 1.0, 0.0]    type:#float fieldWidth:50 align:#right scale:0.05
	)
	label infoLBL "Sélection de faces = mode partiel" align:#center
	label infoLBL2 "Rien de sélectionné = objet entier" align:#center
	button runBT "Extraire les splines" width:180 height:30

	on runBT pressed do
	(
		autoFaceGroupToSpline angleThreshold:angleSP.value downFaceThreshold:downZSP.value
	)
)

createDialog autoFaceGroupRLT width:210
