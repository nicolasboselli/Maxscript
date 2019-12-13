-- transfer children
/*
maj:
	-x faire apparaitre les target depuis le point source
	-x un bouton pour forcer le passage d'une target en master
	-x un bouton pour updater les children sur la selection
	x- un bouton pour updater toutes les target de la scene
	
	-- dupliquer et renommer les calques en fonction de la target
	-- proposer le choix entre copy ou instance(forcement la copy remplacerait tous les enfants)
	-- rescale en fonction d'un gabarit (object replacer)
	
	x- remonter à la source/master lorsqu'on transfere une instance/target sur un nouveau point
	
	/- developper un explorer de la scene qui fasse ressortir les master et les targets
		-- permettrait de renommer les master 
	
	
debug:
	-- ne copie pas les objet en instance dans les enfants(? ça semble fonctionner, peut etre que je n'avais pas bien parenter les objets)

rebuild:
	-- s'appuyer sur un modifier et pas les propriétés d'objets
*/


filein "transferPoint_lib.ms"

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
	group "updates:"
	(
		button updateTargetsBT "Update Targets" tooltip: "update targets of master selected"
		button updateSelBT "Update Sel" enabled: true
		button updateAllBT "Update All" enabled: true
	)
	
	group "display"
	(
		button changeWireColorBT "change wirecolor"
		button conformBT "conform to master"
		button conformAllBT "conform all to masters"
	)
	
		
	group "selections"
	(
		
		button selectTargetsBT "select Targets from Master"
		button selectMasterBT "select Master from Target"
		button selectAllMastersBT "select all Masters"
		
	)
	
	group "infos"
	(
		button getTargetsBT "print Targets"
		button publishMasterBT "print Masters"
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
		format "######## transfert start\n"
		local correctSel = true
		sel = selection as array
		
		for s in sel do
		(			
			if not classof s == point then  correctSel = false
		)
-- 		format "sel.count: % \n"  sel.count
		if correctSel then 
		(
			local oneMaster = findRealSource  sel[1]
			tagSourceProperties oneMaster
-- 			format "oneMaster: % \n" oneMaster
-- 			format "sel.count: % \n"  sel.count
			for i = 2 to sel.count do
			(
-- 				format "oneMaster: % onetarget: %\n" oneMaster.name sel[i].name
				transferChildren oneMaster sel[i] checkSource: true presName: presNameCB.state presMat:  presMatCB.state presLayer: presLayerCB.state
			)
		)
		else
		(
			format "selection non conforme\n"
		)
		format "######## transfert done\n"
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
			if getUserProp s "isSource" then setUserProp s "isSource" false
			local src = findRealSource s
			format "s: %, src: %\n" s.name src.name
			transferChildren src s checkSource: true presName:  presNameCB.state presMat:  presMatCB.state
		)
	)
	
	on updateAllBT pressed do
	(
		selectAllMastersBT.pressed()
		updateSelBT.pressed()
		
	)
	
	on changeWireColorBT pressed do
	(
		local randomColor = color (random 0 255) (random 0 255) (random 0 255)
		for s in selection do s.wirecolor = randomColor
	)	
	
	on conformBT pressed do
	(
		
		local sel  = selection as array
		(
			for s in sel do
			(
				-- check: fonctionne que sur master
				if not iskindof s point then continue

				local isMaster = (getUserProp s "isSource")
				if isMaster == undefined or not isMaster then
				(
					format "selectionnez un master"
					continue
				)
					
				-- activer le center marker sur le master
				s.centermarker = on
				s.box = on
				s.size = 400
				
				-- selectionner tous les enfants du mastere 
				local tmpSel = #(s) 
				for ts in tmpSel do for c in ts.children do append tmpSel c
				-- et  appliquer au enfant du master le même wirecolor que le master
				for ts in tmpSel do ts.wirecolor = s.wirecolor
					
				-- recupere toutes les targets
				local targetsAr = getTargets s		
				-- appliquer le meme wirecolor que le master
				for t in targetsAr do
				(
					t.size = s.size*0.25
					t.centermarker = off
					t.box = off
					
					local tmpTgt = #(t) 
					for tt in tmpTgt do for c in tt.children do append tmpTgt c
					for tt in tmpTgt do tt.wirecolor = s.wirecolor
				)
					-- mettre une size à 70% du master

				-- selectionner tous les enfants du master et leur appliquer le même wirecolor que le master
			)
		)
	)
	
	on conformAllBT pressed do
	(
		selectAllMastersBT.pressed()
		conformBT.pressed()
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
		if sel.count > 0 then
		(
			src = findRealSource sel[1]
			for s in src do format "%\n" s.name
			select src
		)
	)
	
	on selectAllMastersBT pressed do
	(
		select (getMasters())
	)
	
	on publishMasterBT pressed do
	(
		printMaster()
	)
)
createDialog transferChildrenRLT


