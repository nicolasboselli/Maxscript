-- transfer children
/*
maj:
	-x faire apparaitre les target depuis le point source
	-x un bouton pour forcer le passage d'une target en master
	-- un bouton pour updater les children sur la selection
	-- un bouton pour updater toutes les target de la scene
	
	-- dupliquer et renommer les calques en fonction de la target
	-- proposer le choix entre copy ou instance(forcement la copy remplacerait tous les enfants)
	-- rescale en fonction d'un gabarit (object replacer)
	
debug:
	-- ne copie pas les objet en instance dans les enfants(? ça semble fonctionner, peut etre que je n'avais pas bien parenter les objets)

rebuild:
	-- s'appuyer sur un modifier et pas les propriétés d'objets
*/

 fn tagSourceProperties s =
(
	local str = stringstream ""
	format "isChildrenTransferPoint = %\n isSource = %\n sourceName = %\n" true true s.name to: str
	setUserPropBuffer s str
-- 	print str
)
-- print "isChildrenTransferPoint = true\nisMaster = false\nmasterName = undefined\n"

fn tagTargetProperties s sourceName =
(
	local str = stringstream ""
	format "isChildrenTransferPoint = %\n isSource = %\n sourceName = %\n" true false sourceName to: str
	setUserPropBuffer s str
-- 	print str
)

fn findRealSource s = 
(
	-- rendre recursif pour vraiment trouver la source
	local virtualSource
	local isSource = true
	
	try(isSource = (getUserProp s "isSource"))catch(isSource = true)
-- 	format "isSource:%\n" isSource
	if isSource == undefined then ()
	else if not isSource then
	(
		try
		(
			virtualSource = getnodebyname (getUserProp s "sourceName")
-- 					format "virtualSource: %\n" virtualSource
-- 					if virtualSource == undefined then virtualSource = s
		)catch()
	)else()
	
	if isvalidnode virtualSource then virtualSOurce else s
)
-- findRealSource $


fn findRealSource2 o = 
(
	-- rendre recursif pour vraiment trouver la source
	sel = #(o)
	local virtualSource
	local isSource = true
	
	
	format "isSource:%\n" isSource
	i = 1
	for s in sel do
	(
		format "\ns: %\n" s
		try(isSource = (getUserProp s "isSource"))catch(isSource = true)
			
		if isSource == undefined then exit
			
		else if not isSource then
		(
			try
			(
				virtualSource = getnodebyname (getUserProp s "sourceName")
				
				if isvalidnode  virtualSource and virtualSource != s then
				(
					append sel virtualSource
					format "i: %\n" i
					format "sel: %\n" sel
					format "virtualSource: %\n" virtualSource

					i =  i + 1
				)else()
			)catch()
		)else exit
		
		if i > 10 then exit
	)
	
	sel[sel.count]
	
-- 	if isvalidnode virtualSource then virtualSOurce else s
)
-- findRealSource2 $
-- getUserProp $ "sourceName"

-- $.banode

fn transferChildren source target checkSource: false presName: true presMat: true presTrans: true presLayer: true =
(
	format "########### transfer start: %\n" target.name
	/*
	todo: 
		-- rendre le tag de properties optionnel
		-- proposer le mode instance ou copy
	*/
	
	/*
	memo sur l'option checkSource:
		si l'option est active, la focntion recherche la source reelle de la source selectionner et utilise cette source pour faire la copie et tagger les user properties
	*/
	
	-- option pour remonter à la source
		-- si la source n'est pas tagger comme source et a une source qui existe dans la scene prendre cette source
	
	if checkSource then
	(
		realSource = findRealSource source
		if isvalidnode realSource then source = realSource
		else(tagSourceProperties source)
	)
	else
	(
		tagSourceProperties source
	)
		
	-- collecte des enfants de la source
	local childrenAr = #(source)
	local sourceRC = #()
	local sourceRCbanode = #()
	for c in childrenAr do 
	(
		for ch in c.children do appendifunique childrenAr ch
	)
	format "childrenAr.count: %\n" childrenAr.count
	
	-- collecte des  enfants de la target
	childTargetAr = #(target)
	for c in childTargetAr do 
	(
		for ch in c.children do appendifunique childTargetAr ch
	)
	
	--creation de la copy
	maxOps.cloneNodes childrenAr cloneType:#instance newNodes:&copyChilds
	format "copyChilds.count: %\n" copyChilds.count
	
	-- prise en charge des instances de railclone: desinstancier les railclones
		-- aprés la copy desinstancier collecter les railclone et affecter l'instance de la spline d'origine
	for cc in copyChilds where classof cc == railclone_pro do
	(
		-- trouver l instance de la spline/banode d origine dans les copies
		local newBanode = #()
		-- pour chaque spline de la source
		for b in cc.banode do
		(
			-- touver les instances de la spline de la source
			InstanceMgr.GetInstances b &bInst
			-- pour chaque instance de la spline de la source
			for bi in bInst do
			(
				-- tester si l'instance est dans les copies
				res = finditem copyChilds bi
				-- si oui 
				if res > 0 then append newBanode bi -- print "youpi"
			)
		)
		InstanceMgr.GetInstances cc &rcInstances

		-- desinstancier le railclone
		if (InstanceMgr.CanMakeObjectsUnique cc ) then InstanceMgr.MakeObjectsUnique cc #prompt
		
		-- affecter l'instance de la spline d origine
		cc.banode = newBanode
	)

	-- mettre les copies sur les bons calques
	local refLay = target.layer
	for c in copyChilds do refLay.addnode c
			
	-- transfer du transform sur le parent de la copie
	 copyChilds[1].transform = target.transform
	
	-- transfert des attributs des enfants
	for i = 2 to copyChilds.count do
	(
		local instances
		
		-- transférer le parent
		if copyChilds[i].parent == copyChilds[1] then copyChilds[i].parent = target
		
		-- trouver la correpondance entre un enfant de la target et une copy d'un enfant de la source en recherchant les instance
		InstanceMgr.GetInstances copyChilds[i] &instances
		for ct in childTargetAr do
		(
			res = finditem instances ct
			if res > 0 and isvalidnode ct then 
			(
				format "% instance of %\n"  copyChilds[i].name ct.name
				-- préserver le layer
				-- préserver le materiau
				if presMat then copyChilds[i].material = ct.material
				
				-- préserver le transform
				if presTrans then copyChilds[i].transform = ct.transform
				
				-- préserver le nom
				if presName then copyChilds[i].name = ct.name
					
				if presLayer then ct.layer.addnode copyChilds[i]
			)
-- 			else(format "% instance of nothing\n"  copyChilds[i].name )
			else()
		)
		
		if isvalidnode childTargetAr[i] then delete childTargetAr[i]
	)
	-- nettoyage
	delete  copyChilds[1]
	tagTargetProperties target source.name
	
	format "########### transfer done: %\n" target.name
)


/*###################### EXPLORER*/
-- permet de recolter les targets dans la scene
fn getTargets source =
(
	local isChildrenTransferPoint = false
	local isSource = true
	local virtualSource = undefined
	local targetAr = #()
	
	format "###### source: % \n" source
	for h in helpers do
	(
		try(isChildrenTransferPoint = (getUserProp h "isChildrenTransferPoint"))catch(isChildrenTransferPoint = false)
-- 		format "h: % isChildrenTransferPoint: %\n" h isChildrenTransferPoint
		if isChildrenTransferPoint != undefined then
		(
			if isChildrenTransferPoint then
			(
				
				try(isSource = (getUserProp h "isSource"))catch(isSource = true)
-- 				format "h: % isSource: %\n" h isSource
				if isSource != undefined then
				(
					if not isSource then
					(
						try(virtualSource = getnodebyname (getUserProp h "sourceName"))catch(virtualSource = undefined)
							
						if isvalidnode virtualSource then 
						(
							if virtualSource == source then
							(
								append targetAr h
								format "target: %\n" h
							)
						)
					)
				)
			)
		)
	)
	format "###### targetCount: % targetAr: %\n" targetAr.count targetAr
	targetAr
)
-- getTargets $


try(destroyDialog transferChildrenRLT)catch()
rollout transferChildrenRLT "transfer Children"
(
	local params = #("pos", "presNameCB", "presMatCB", "presTransCB", "presLayerCB")

	group "Tools"
	(
		button makeMaster "make Master"
	)
	
	group "options"
	(
		checkbox presNameCB "preserve name" checked: true
		checkbox presMatCB "preserve material" checked: true
		checkbox presTransCB "preserve transform" checked: true
		checkbox presLayerCB "preserve layer" checked: true
	)
	
	button transferOnSelBT "Transfer Children on sel"
	button updateTargetsBT "Update Targets of sel"
	button updateSelBT "Update Sel" enabled: true
	button updateAllBT "Update All" enabled: false
		
	group "info"
	(
		button getTargetsBT "print Targets"
		button selectTargetsBT "select Targets"
		button selectMasterBT "select Master"
		button changeWireColorBT "change wirecolor"
	)
	
	on transferChildrenRLT open do
	(
		loadRolloutParams transferChildrenRLT params
	)
	
	on transferChildrenRLT close do
	(
		writeRolloutParams transferChildrenRLT params
	)
	
	on makeMaster pressed do
	(
		sel = selection as array
		for s in sel do tagSourceProperties s
	)
	
	on transferOnSelBT pressed do
	(
		local correctSel = true
		sel = selection as array
		
		for s in sel do
		(			
			if not classof s == point then  correctSel = false
		)
		
		if correctSel then 
		(
			for i = 2 to sel.count do
			(
				transferChildren sel[1] sel[i] checkSource: true presName: presNameCB.state presMat:  presMatCB.state presLayer: presLayerCB.state
			)
		)
		else
		(
			format "selection non conforme\n"
		)
	)
	
	on updateTargetsBT pressed do
	(
		sel = selection as array
		if classof sel[1] == point then
		(
			local targetsAr = getTargets sel[1]
			for t in targetsAr do
			(
				transferChildren sel[1] t checkSource: true presName:  presNameCB.state presMat:  presMatCB.state
			)
		)
	)
	
	on updateSelBT pressed do
	(
		sel = selection as array
		for s in sel do
		(
			src = findRealSource s
			format "s: %, src: %\n" s.name src.name
			transferChildren src s checkSource: true presName:  presNameCB.state presMat:  presMatCB.state
		)
	)
		
	on getTargetsBT pressed do
	(
		sel = selection as array
		src = findRealSource sel[1]
		getTargets src
	)
	
	on selectTargetsBT pressed do
	(
		sel = selection as array
		src = findRealSource sel[1]
		select src
		selectmore (getTargets src)
		
	)
	
	on selectMasterBT pressed do
	(
		sel = selection as array
		src = findRealSource sel[1]
		select src
	)
	
	on changeWireColorBT pressed do
	(
		local randomColor = color (random 0 255) (random 0 255) (random 0 255)
		for s in selection do s.wirecolor = randomColor
	)	
)
createDialog transferChildrenRLT

