-- memoriser les reglages avec la selection dans le multibox, structure
-- memoriser les reglages dans un fichier ini
	-- manager les sauvegardes de fichier ini globales et locales
-- créer les calques en fonction du nom du percement
-- 

global splinesPerceAr = #("Fenetres", "PFenetres", "Portes", "Placard", "Porte_entree")

struct spPerceSet (name, hauteur, allege, debordAv, debordAr, filemane)

fn collectLayer pattern: "*" =
(
	local layerFoundAr = #()
	for i = 0 to  (LayerManager.count - 1) do
	(
		l = LayerManager.getLayer i
		
		if  matchpattern l.name pattern: pattern then
		(
			append layerFoundAr l
-- 			"l.name: %\n" l.name
		)
	)
	layerFoundAr
)

fn rafle layerList: #() =
(
	local all = #()
	for l in layerList do
	(
-- 		format "l.name: %\n" l.name
		local tmp
		l.nodes &tmp
-- 		format "tmp: %\n" tmp
		for o in tmp do append all o
	)
	all
)
-- layers = collectLayer pattern: "_*"
-- obj = rafle layerList: layers

-- layers[1].nodes &tmp

try(destroydialog prepaPercementRLT)catch()
rollout prepaPercementRLT "preparation percement v2"
(
	local layerStructAr = #()
	
	local prepaSuf = "__Splines "
	local gabSuf = "___Gabarits "
	-- UI
	group "configuration"
	(
		dropdownlist  configDDL "config:"
		button saveBT "save" across: 3
		button saveAsBT "saveAs"
		button loadBT "load"
	)
	
	multilistbox drillingMLB "percements:"
	
	group "parametres:"
	(
		spinner heightSP "hauteur:"  type: #worldunits range: [0,500, 215]
		spinner allegeSP "allege:" type: #worldunits range: [0,500, 0]
		spinner innerSP "debord avant:" type: #worldunits range: [0,500, 0]
		spinner outerSP "debord arriere:" type: #worldunits range: [0,500, 0]
		edittext mergeET readonly: false text: "toto"
		button pathBT "..."
	)
	
	group "actions:"
	(
		button addToLayerBT "add to layer"
		button adjustBT "adjust gabarits"
	)

	button createGabaritsBT "create gabarits"
	
	-- actions
	on prepaPercementRLT open do
	(
		drillingMLB.items = for p in splinesPerceAr collect p
			
		for p in splinesPerceAr do
		(
			local one = spPerceSet name:  (prepaSuf + p) hauteur: heightSP.value allege: allegeSP.value \
			debordAv: innerSP.value debordAr: outerSP.value filemane: "c:"
			
			append layerStructAr one
		)
	)
	
	on drillingMLB selectionend do
	(
		-- todo chager les parametres d'une structure
-- 		format "sel: %\n" drillingMLB.selection
	)
	
	on addToLayerBT pressed do
	(
		local id
		local sel = drillingMLB.selection as array
		if sel.count == 0 or sel.count > 1 then()
		else
		(
			local n = splinesPerceAr[sel[1]]
			local layername = prepaSuf + n

-- 			format "layername: %\n" layername
			-- creation du layer
			l = LayerManager.getLayerFromName layername
			if l == undefined then l = LayerManager.newLayerFromName layername
		)
	)
	
	on adjustBT pressed do
	(
-- 		collecter tous les calques de reperes
		local layerList = collectLayer pattern: "__Splines *"
		local objs = rafle layerList: layers
		-- pour chaque calque
			-- trouver les reglages correspondants
		format "objs: %\n" objs
		for o in objs do
		(
			for oneStruct in layerStructAr do
			(
-- 				format " o.layer: % oneStruct.name: %\n" o.layer.name  oneStruct.name
				if o.layer.name == oneStruct.name then
				(
					format "adjust % settings on %\n" oneStruct.name o.name
				)
				else()
			)
		)
			-- collecter les objets du calque
			-- appliquer les reglages
	)
)
createdialog prepaPercementRLT


