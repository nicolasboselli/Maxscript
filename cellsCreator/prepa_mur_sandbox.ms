/*
maj:
	- ajouter les boutons pour monter ou descendre le mur
	

*/

global splinesWallAr = #("Ext", "Terrasses", "Fond", "Interieurs")

struct spMurSet (name, wirecolor, hauteur, epaisseur)

global cellSetIni = "N:/Ressources_Nico/github/00_wip/Maxscript/cellsCreator/cellSettings.ini"

totalMurs = #()
mursSettingsAr = getINISetting cellSetIni "mursSettings"
for o in  mursSettingsAr do
(
-- 	format "%\n" (getINISetting cellSetIni "mursSettings" o) 
	append totalMurs (execute(getINISetting cellSetIni "mursSettings" o))
)
totalMurs

for j = 1 to totalMurs[1].count do
(
	for k = 1 to totalMurs.count do
	(
		format "% ;" totalMurs[k][j]
		tmp = spMurSet name:   wirecolor: hauteur: epaisseur:
	)
	format "\n" 
)

-- local oneMur =  spMurSet name:  wirecolor: hauteur: epaisseur:
testSet = getINISetting cellSetIni "mursSettings2" "tmp"
one = execute testSet
one = spMurSet name: "ploufe" wirecolor: red hauteur: 50 epaisseur: 20
one as string
setINISetting cellSetIni "mursSettings2" "one" (one as string)


try(destroydialog prepaMursRLT)catch()
rollout prepaMursRLT "preparation murs v2"
(
	local layerStructAr = #()
	
	local mursPref = "_Splines Murs "
	
	group "configuration:"
	(
		dropdownlist  configDDL "select:"
		button saveBT "save" across: 3
		button saveAsBT "saveAs"
		button loadBT "load"
	)
	
	multilistbox mursMLB "Murs:"
	
	group "paramètres:"
	(
		spinner heightSP "hauteur:"  type: #worldunits range: [0,500, 215]
		spinner epaisseurSP "epaisseur:" type: #worldunits range: [0,500, 20]
-- 		spinner innerSP "debord avant:" type: #worldunits range: [0,500, 0]
-- 		spinner outerSP "debord arriere:" type: #worldunits range: [0,500, 0]
	)
	
	group "actions:"
	(
		button addToLayerBT "add to layer"
		button createNewBT "create new"
-- 		button adjustBT "adjust gabarits"
	)
	
	group "tools:"
	(
		button extwallInverser "Inverser sens spline"  --across: 2
		button delAllModBT "Supprimer Modifiers"
		button createSelectionBT "Créer murs sur Selection"
	)
	
	button cerateWallBT "creation des murs"
	
	on prepaMursRLT open do
	(
		-- charger le fichier ini
		mursMLB.items = for p in splinesWallAr collect p
			
		for p in splinesWallAr do
		(
			local one = spMurSet name:  (mursPref + p) hauteur: 230 epaisseur: 20
			append layerStructAr one
		)
	)
	
	on addToLayerBT pressed do
	(
		local id
		local sel = mursMLB.selection as array
		local objs = selection as array
		
		if sel.count == 0 or sel.count > 1 then()
		else if objs.count > 0 then
		(
			format "objs: %\n" objs
			local n = splinesWallAr[sel[1]]
			local layername = mursPref + n

-- 			format "layername: %\n" layername
			-- creation du layer
			l = LayerManager.getLayerFromName layername
			if l == undefined then l = LayerManager.newLayerFromName layername
				
			--  ajouter la selection d'objets au calque selectionné
			for o in objs do
			(
				l.addnode o
				o.wirecolor = brown
				-- appliquer le traitement
			)
		)
		else()
	)
)
createdialog prepaMursRLT