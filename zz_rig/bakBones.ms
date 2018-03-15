-- BakBones

-- var = getThisScriptFilename() 
-- print var

-- fonction
fn BakBonesFN bonesSel =
(
	local BakLayer
-- 	local bonesSel 
	local LayerList = LayerManager
		
	if (LayerList.current.ishidden != true) AND (bonesSel.count > 1) then
	(
		-- création de la copie 
		bonesBak = for o in bonesSel collect (copy o)
		for i = 2 to bonesBak.count do  bonesBak[i].parent =  bonesBak[i-1]
		for o in bonesBak do o.wirecolor = (color 175 175 175)
		for o in bonesSel do o.wirecolor = (color 50 125 50)
		
		-- vérifie si un calque pour sauver les bones existe déja sinon le crée
		if (LayerList.getLayerFromName "BakBones" == undefined) then
		(
			BakLayer = LayerList.newLayerFromName "BakBones"
		)
		else
		(
			BakLayer = LayerList.getLayerFromName "BakBones" 
		)

		-- place la copie de sauvegarde sur le calque bakbones
		for o in bonesBak do 
		(
			o.boneEnable=true
			o.boneFreezeLength=true
			BakLayer.addnode o
		)
			
		-- place la copie de travail sur le calque de travail
		for o in bonesSel do
		(
			o.boneEnable=true
			o.boneFreezeLength=true
			LayerList.current.addnode o
		)
		
		-- LayerList.current.name
		select bonesSel
		BakLayer.ishidden = true
	)
	else
	(
		messagebox "le calque actif est masqué ou le nombre de bones choisi est insuffisant"	
	)
)


-- BakBonesFN ($selection as array)

	/*
	-- sélectionne toute la hiérarchie
	bonesSel = $selection as array
	while $.children.count > 0 do
	(
		append bonesSel $.children[1]
		select $.children[1]
	)
	*/
