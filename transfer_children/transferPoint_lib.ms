-- ##################### import Python functions
/*
-- prob: 
	-- les modules importés semblent rester en mémoire aprés la suppression du path du sys.path
	-- je nes sais pas comment charger un package avec des sous dossiers

*/
/*
-- import
pySys = python.import  "sys"
transferChildrenPath = @"N:\Ressources_Nico\github\00_wip\Maxscript\transfer_children"

-- teste si le module à importer est déja dans le sys.path, si oui le supprime
for i = 1 to pySys.path.count where pySys.path[i] == transferChildrenPath do pySys.path.remove(transferChildrenPath)

-- ajoute les module à importer au sys.path
pySys.path.append(transferChildrenPath)

-- print des sys.path
for i = 1 to pySys.path.count do print pySys.path[i]

sb = python.import "sandbox"
python.reload sb

tc = python.import "transfer_children"
python.reload tc
-- tc.pyLib

pl = python.import "pyLib"
python.reload pl
-- pl.pyLib
-- pl.transferChildren_pyLib.hello()
-- tc = python.import "transferChildren_pyLib"


-- tc.hello()
-- sb.hello()
*/

-- ##################### MXS functions
 fn tagSourceProperties s =
(
	local str = stringstream ""
	format "%: isChildrenTransferPoint = % isSource = % sourceName = %\n" s.name true true s.name
	format "isChildrenTransferPoint = %\r\nisSource = %\r\nsourceName = %\r\n" true true s.name to: str
	setUserPropBuffer s str
-- 	print str
)
-- print "isChildrenTransferPoint = true\nisMaster = false\nmasterName = undefined\n"

fn tagTargetProperties s sourceName =
(
	local str = stringstream ""
	format "%: isChildrenTransferPoint = % isSource = % sourceName = %\n" s.name true false sourceName
	format "isChildrenTransferPoint = %\r\nisSource = %\r\nsourceName = %\n" true false sourceName to: str
	setUserPropBuffer s str
-- 	print str
)

fn findRealSource o = 
(
	-- rendre recursif pour vraiment trouver la source
	local sel = #(o)
	local virtualSource
	local isSource = true
	
	
-- 	format "isSource:%\n" isSource
	i = 1
	for s in sel do
	(
-- 		format "\ns: %\n" s
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
-- 					format "i: %\n" i
-- 					format "sel: %\n" sel
-- 					format "virtualSource: %\n" virtualSource

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
	maxOps.cloneNodes childrenAr cloneType:#copy newNodes:&copyChilds
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

fn getMasters =
(
	local testSource
	local masterAr = #()
	
	for h in helpers do
	(
		testSource = getUserProp h "isSource"
		
		if testSource == undefined then continue 
		else if not testSource then continue
		else if testSource then
		(
			format "master: %\n" h.name
			appendifunique masterAr h
		)
		else()
	)
	masterAr
)

-- getMasters()

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


fn printMaster =
(
	-- publier les masters deleted et manquant
	
	
	local masterNamesAr = #()
	for h in helpers where iskindof h point do
	(
	-- 	format "h: %\n" h.name
		childTransPt = getUserProp h "isChildrenTransferPoint"
	-- 	isSource = getUserProp h "isSource"
-- 		format "childTransPt: %\n" childTransPt
		
		if iskindof childTransPt booleanclass then
		(
	-- 		format "sourceName: %\n" (getUserProp h "sourceName")
			appendifunique masterNamesAr (getUserProp h "sourceName")
		)
	)
	masterNamesAr
	
	for m in masterNamesAr do
	(
		local oneMaster = getnodebyname m
		
-- 		calcul du nombre de tab pour le format
		charNum = 28
		tcount = (ceil (charNum - m.count - 6 + 2)/4.0) as integer
		
		multiT = ""
		for i = 1 to tcount do multiT+= "\t"

		if isvalidnode oneMaster then format "name: % % node: %\n" m multiT oneMaster
		else format "name: % % node: %\n" m multiT undefined
	)
)
-- printMaster()
