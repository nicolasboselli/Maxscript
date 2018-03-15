-- ############ delock scale bouche ctrls



-- trouver bouche rig dans la scene
fn delockBoucheScaleCtrls =
(
	nameAr = filterString  maxFileName "_"
	basename = nameAr[1] + "_" + nameAr[2]
	print basename
	
	objs = objects as array

	searchName = #( \
		"D_Bouche_Haut", "D_Bouche_Haut_01", "D_Bouche_Haut_02", "Bouche_Haut", "G_Bouche_Haut", "G_Bouche_Haut_01", "G_Bouche_Haut_02", \
		"D_Bouche_Com", "G_Bouche_Com", \
		"D_Bouche_Bas", "D_Bouche_Bas_01", "D_Bouche_Bas_02", "Bouche_Bas",  "G_Bouche_Bas", "G_Bouche_Bas_02", "G_Bouche_Bas_01" \
		)

	for s in searchName do
	(
		ctrl = undefined
		rig = undefined
		
		format  "\n ###### recherche: % ###### \n "s
		
		-- trouver bouche ctrl dans la scene
		for o in objs where  findString o.name (basename + "_" + s + "_CTRL") != undefined do ctrl = o
		
		for o in objs do
		(
			if  findString o.name (basename + "_"  + s + "_RIG") != undefined then rig = o
			else if findString o.name (basename + "_" + s + "_Local_RIG") != undefined then rig = o
		)
		
		-- matcher rig et ctrls
		if ctrl != undefined and rig != undefined then
		(
			format "% controle % \n" ctrl.name rig.name
			
			-- delocker les ctrls et les rig
			setTransformLockFlags  ctrl #none
			setTransformLockFlags  rig #all
			
			-- instancier controllers ctrls et rigs
			format "ctrl: ¨%, rig: % \n" ctrl.scale.controller rig.scale.controller
			rig.scale.controller = ctrl.scale.controller
			
		)
		else format "pas de correspondance\n"
	)
)

delockBoucheScaleCtrls ()







