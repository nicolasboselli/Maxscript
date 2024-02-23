/*
maj:
/- plus eloigner le premier main des bords
x- rendre les settings Editable
x-- memoriser les settings modifi�s

-- comparer le bounding box de l'objet avec la taille du balcon, s'il ne rentre pas, ne pas le mettre
-- n'utiliser qu'une seule fois chaque objet sur une terrasse

-- ajouter une liste de selection d'objets
	-- remplir automatiquement la liste de selection � l'utilisation du script
-- mettre un pourcentage de distribution par objet au random
-- d�poser des objets par Picker
-- snapper des objets sur des surfaces au deplacement

ref:
M:\Maquette\HAB
HAB_MOBILIER_TERRASSES

-- random replace
*/

-- filein "balcon_sb3.ms"
-- try(destroydialog BalconizerRLT)catch()

try (destroydialog Balconizer2RLT) catch ()
rollout Balconizer2RLT "Objects Balconizer v.alpha"
(
	local Params = #("pos", "ImpactShiftSP", "ImpactZShiftSP", "mainExclusionSP", "borderRadiusSP", "mainRadiusSP", "borderDensitySP" )
	
	group "Impact Settings:" 
	(
		spinner ImpactShiftSP "XY Shift:" type: #worldunits range: [0,500,30] 
		spinner ImpactZShiftSP "Z Shift:" type: #worldunits range: [0,500,30]
	)
	
	group "Main (Table):"
	(
		spinner mainExclusionSP "Exclusion:" type: #worldunits range: [0,500,50]
		spinner mainRadiusSP "Density:" type: #worldunits range: [0,500,150]
		button randomObjBT "Create Main" height: 30 width: 100  tooltip: "1 - Selectionner les objets � dupliquer\n2 - Selectionner les balcons o� dupliquer en dernier\n3 - Appuyer sur le bouton"
	)
	
	group "Border (Pots):"
	(
		spinner borderRadiusSP "Radius:" type: #worldunits range: [0,500,50]
		spinner borderDensitySP "Density:" type: #worldunits range: [0,500,150]
		button borderObjBT "Create Border" height:30 width: 100
	)
	
	group "Tools:"
	(
		button snapObjBT "Snap Objects"
-- 		button gravityBT "Gravity" enabled: false
		button randRotZBT "Random Z"
		button lessRotZBT "-45� Z"  across: 3
		button zeroRotZBT "0� Z"
		button moreRotZBT "+45� Z"
		button getInstancesBT "Get Instance"
		button replaceObjBT "Replace Object" enabled: true
	)
	
		
	on Balconizer2RLT open do
	(
		loadRolloutParams Balconizer2RLT Params
	)
	
	on Balconizer2RLT close do
	(
		writeRolloutParams Balconizer2RLT Params
	)
	
	on randomObjBT pressed do
	(
		sel = selection as array
		selAr = #()

		if sel.count <= 1 then(format "Selectionnez plus de 1 objet.\n")
		else
		(
			ground = sel[sel.count]

			-- dans la selection faire un array par groupe
			for i = 1 to (sel.count - 1) do
			(
				if not isvalidnode sel[i].parent do
				(
					append selAr #(sel[i])
				)
			)

			for oneSet in selAr do
			(
				for o in oneset do
				(
					for c in o.children do append oneset c
				)
			)
			selAr.count

			-- calcul des points
			allImpAr = findImpacts ground shift: ImpactShiftSP.value shiftz: ImpactZShiftSP.value 

			-- tri des impacts entre border et main
			NewtwoArrays = findBorderImpact2 ground allImpAr size: mainExclusionSP.value

			-- mise en groupe guide creation
			MainGrpImpAr = sortByGroup NewtwoArrays[1] shift: 50

			-- test des distances
			perfectForDressingAr = distImpact MainGrpImpAr size2: mainRadiusSP.value

			zMaxAr = #()
			-- pour chaque objet trouver la position la plus basse
			for oneSet in selAr do
			(
				
				-- sur chaque groupe calculer le d�placement en z
				local zmax = point3 0 0 (10^6)
				local zMin = 10^6
				for s in oneSet where iskindof s GeometryClass do
				(
					-- ajouter edit mesh
					addModifier s (edit_mesh name: "tmp_EM" )

					-- compter le nombre Vertex
					vxCount = getnumverts s

					-- collecter la position du Vertex le plus bas
					vxPosAr = for v = 1 to vxCount collect getVert s v

					for v = 1 to vxCount do
					(
						onePos = getVert s v
						
						if onePos.z < zmax.z then
						(
			-- 				format "v: %  zmax.z: % onePos: %\n" v zmax.z onePos
							zmax = onePos
						)
					)
					
					-- suppression du modifier
					deletemodifier s 1
				)	
				append zMaxAr zmax
			)
			zMaxAr.count


			-- calculer la postion de l'objet par rapport � la position de diff�rence
			for oneSet in perfectForDressingAr do
			(
				for p in oneSet do
				(
					local copyHead
					local copyRef
					
					-- l'identit� selectionn�e
					local id = random 1 zMaxAr.count
						
					-- dupliquer l'objet tir� au sort
					format "copy id: % obj: %\n" id selAr[id][1].name
					maxOps.cloneNodes selAr[id][1] cloneType: #instance newNodes:&copyRef
					for o in copyRef where o.parent == undefined do copyHead =  o
						
			-- 		posObj = selAr[id][1].position
					shift = selAr[id][1].position - zMaxAr[id]

					-- � partir de la postion la plus basse de l'objet (zmax) calculer le saut
				-- 	(zMaxAr[id] - p)
					
					-- d�placer l'objet duppliquer
					-- pt = point name: (uniquename ("pt_id" + (id as string) + "_")) --position: zMaxAr[id]
-- 					rotate copyHead (angleaxis (random 0 360) [0,0,1])
					copyHead.position = p + shift
				)
			)
		)
	)
	
	on borderObjBT pressed do
	(
		
		sel = selection as array
		selAr = #()

		if sel.count <= 1 then(format "Selectionnez plus de 1 objet.\n")
		else
		(
			ground = sel[sel.count]

			-- dans la selection faire un array par groupe
			for i = 1 to (sel.count - 1) do
			(
				if not isvalidnode sel[i].parent do
				(
					append selAr #(sel[i])
				)
			)

			for oneSet in selAr do
			(
				for o in oneset do
				(
					for c in o.children do append oneset c
				)
			)
			selAr.count

			-- calcul des points
			allImpAr = findImpacts ground shift: ImpactShiftSP.value shiftz: ImpactZShiftSP.value

			-- tri des impacts entre border et main
			NewtwoArrays = findBorderImpact2 ground allImpAr size: borderRadiusSP.value

			-- mise en groupe guide creation
			MainGrpImpAr = sortByGroup NewtwoArrays[2] shift: 50

			-- test des distances
			perfectForDressingAr = distImpact MainGrpImpAr size2: borderDensitySP.value

			zMaxAr = #()
			-- pour chaque objet trouver la position la plus basse
			for oneSet in selAr do
			(
				
				-- sur chaque groupe calculer le d�placement en z
				local zmax = point3 0 0 (10^6)
				local zMin = 10^6
				for s in oneSet where iskindof s GeometryClass do
				(
					-- ajouter edit mesh
					addModifier s (edit_mesh name: "tmp_EM" )

					-- compter le nombre Vertex
					vxCount = getnumverts s

					-- collecter la position du Vertex le plus bas
					vxPosAr = for v = 1 to vxCount collect getVert s v

					for v = 1 to vxCount do
					(
						onePos = getVert s v
						
						if onePos.z < zmax.z then
						(
			-- 				format "v: %  zmax.z: % onePos: %\n" v zmax.z onePos
							zmax = onePos
						)
					)
					
					-- suppression du modifier
					deletemodifier s 1
				)	
				append zMaxAr zmax
			)
			zMaxAr.count


			-- calculer la postion de l'objet par rapport � la position de diff�rence
			for oneSet in perfectForDressingAr do
			(
				for p in oneSet do
				(
					local copyHead
					local copyRef
					
					-- l'identit� selectionn�e
					local id = random 1 zMaxAr.count
						
					-- dupliquer l'objet tir� au sort
					format "copy id: % obj: %\n" id selAr[id][1].name
					maxOps.cloneNodes selAr[id][1] cloneType: #instance newNodes:&copyRef
					for o in copyRef where o.parent == undefined do copyHead =  o
						
			-- 		posObj = selAr[id][1].position
					shift = selAr[id][1].position - zMaxAr[id]

					-- � partir de la postion la plus basse de l'objet (zmax) calculer le saut
				-- 	(zMaxAr[id] - p)
					
					-- d�placer l'objet duppliquer
					-- pt = point name: (uniquename ("pt_id" + (id as string) + "_")) --position: zMaxAr[id]
-- 					rotate copyHead (angleaxis (random 0 360) [0,0,1])
					copyHead.position = p + shift
				)
			)
		)
	)
	
	on snapObjBT pressed do
	(
		sel = selection as array
		selAr = #()

		ground = sel[sel.count]

		-- s = $
		-- for c in $.children.count

		-- dans la selection faire un array par groupe
		for i = 1 to (sel.count - 1) do
		(
			if not isvalidnode sel[i].parent do
			(
				append selAr #(sel[i])
			)
		)

		for oneSet in selAr do
		(
			for o in oneset do
			(
				for c in o.children do append oneset c
			)
		)
		selAr

		-- appliquer le deplacement sur chaque tete de groupe

		for oneSet in selAr do
		(
			
			-- sur chaque groupe calculer le d�placement en z
			local zmax = point3 0 0 (10^6)
			local zMin = 10^6
			for s in oneSet where iskindof s GeometryClass do
			(
				-- ajouter edit mesh
				addModifier s (edit_mesh name: "tmp_EM" )

				-- compter le nombre Vertex
				vxCount = getnumverts s

				-- collecter la position du Vertex le plus bas
				vxPosAr = for v = 1 to vxCount collect getVert s v

				for v = 1 to vxCount do
				(
					onePos = getVert s v
					
					if onePos.z < zmax.z then
					(
		-- 				format "v: %  zmax.z: % onePos: %\n" v zmax.z onePos
						zmax = onePos
					)
				)
				
		-- 		point position: zmax

				-- suppression du modifier
				deletemodifier s 1

				-- tirer un rayon depuis le z le plus bas
				zMinRay = ray (zmax + (point3 0 0 2000)) (point3 0 0 -1)
-- 				zMinRay = ray zmax (point3 0 0 -1)

		-- 		format "ground: % zMinRay: %\n" ground.name zMinRay
				impacted = intersectRay ground zMinRay
		-- 		format "zmax: % impacted: % distance: % \n" zmax impacted.position (distance zmax impacted.position)
-- 				if distance zmax impacted.position < zMin then zmin = distance zmax impacted.position
				if distance zmax impacted.position < zMin then zmin = zmax.z - impacted.position.z
			)	
			-- move object
			move oneSet[1] (point3 0 0 -zMin)

		)	
	)
	
	on randRotZBT pressed do
	(
		local sel = selection as array
		
		local selAr = #()
		format "sel: %\n" sel

		-- dans la selection faire un array par groupe
		for i = 1 to (sel.count) do
		(
			if not isvalidnode sel[i].parent do
			(
				append selAr #(sel[i])
			)
		)

		for oneSet in selAr do
		(
			for o in oneset do
			(
				for c in o.children do append oneset c
			)
		)
		format "selAr: %\n" selAr
		
		undo on
		(
			for oneSet in SelAr do
			(
				local copyHead
				for o in oneSet where o.parent == undefined do copyHead =  o
				rotate copyHead (angleaxis (random 0 360) [0,0,1])
			)
		)
	)
	
	on lessRotZBT pressed do
	(
		local sel = selection as array
		
		local selAr = #()
		format "sel: %\n" sel

		-- dans la selection faire un array par groupe
		for i = 1 to (sel.count) do
		(
			if not isvalidnode sel[i].parent do
			(
				append selAr #(sel[i])
			)
		)

		for oneSet in selAr do
		(
			for o in oneset do
			(
				for c in o.children do append oneset c
			)
		)
		format "selAr: %\n" selAr
		
		for oneSet in SelAr do
		(
			local copyHead
			for o in oneSet where o.parent == undefined do copyHead =  o
			rotate copyHead (angleaxis 45 [0,0,1])
		)
	)
	
	on zeroRotZBT pressed do
	(
		local sel = selection as array
		
		local selAr = #()
-- 		format "sel: %\n" sel

		-- dans la selection faire un array par groupe
		for i = 1 to (sel.count) do
		(
			if not isvalidnode sel[i].parent do
			(
				append selAr #(sel[i])
			)
		)

		for oneSet in selAr do
		(
			for o in oneset do
			(
				for c in o.children do append oneset c
			)
		)
-- 		format "selAr: %\n" selAr
		
		for oneSet in SelAr do
		(
			local copyHead
			for o in oneSet where o.parent == undefined do copyHead =  o
			bakpos =  copyHead.position
			copyHead.rotation.z = 0
			copyHead.position = bakpos
		)
	)
	
	on moreRotZBT pressed do
	(
		local sel = selection as array
		
		local selAr = #()
		format "sel: %\n" sel

		-- dans la selection faire un array par groupe
		for i = 1 to (sel.count) do
		(
			if not isvalidnode sel[i].parent do
			(
				append selAr #(sel[i])
			)
		)

		for oneSet in selAr do
		(
			for o in oneset do
			(
				for c in o.children do append oneset c
			)
		)
		format "selAr: %\n" selAr
		
		for oneSet in SelAr do
		(
			local copyHead
			for o in oneSet where o.parent == undefined do copyHead =  o
			rotate copyHead (angleaxis -45 [0,0,1])
		)
	)
	
	on getInstancesBT pressed do
	(
		local instances = #()
		local sel = selection as array
		local selAr = #()
		
		-- dans la selection faire un array par groupe
		for i = 1 to (sel.count) do
		(
			if not isvalidnode sel[i].parent do
			(
				append selAr #(sel[i])
			)
		)

		for oneSet in selAr do
		(
			for o in oneset do
			(
				for c in o.children do append oneset c
			)
		)
		
		format "selAr: %\n" selAr
		for oneSet in SelAr do
		(
			local copyHead
			for o in oneSet where o.parent == undefined do copyHead =  o
			InstanceMgr.GetInstances copyHead &instances
			if instances.count == 0 do format "no instances: % \n" sel
			selectmore instances
		)
	)
	
	on replaceObjBT pressed do
	(
		local SelArId
		local copyHead 
		
		sel = selection as array
		source = sel[1]
		
-- 		format "source: % \n" source
		
		selAr = #()
		
		-- dans la selection faire un array par groupe
		for i = 1 to (sel.count) do
		(
			if not isvalidnode sel[i].parent do
			(
				append selAr #(sel[i])
			)
		)

		for oneSet in selAr do
		(
			for o in oneset do
			(
				for c in o.children do append oneset c
			)
		)
		selAr
		
		-- trouver le numero de groupe de la source � duppliquer
		for i = 1 to selAr.count do
		(
			res = finditem selAr[i] source
			if res > 0 then 
			(
				SelArId = i
				for o in selAr[i] where o.parent == undefined do copyHead =  o
-- 				format "copyHead: %\n" copyHead
			)
		)
		
		-- pour chaque autre GroupE
		for i = 1 to selAr.count do
		(
			-- �viter de duppliquer le groupe source sur luim�me
			if i == SelArId then continue
				
			-- trouver la t�te de groupe
			local groupHead
			for o in selAr[i] where o.parent == undefined do groupHead =  o
-- 			format "groupHead: %\n" groupHead
			
			-- duppliquer la source
			maxOps.cloneNodes copyHead cloneType: #instance newNodes:&copyRef
-- 			format "copyRef: %\n" copyRef
			
			local copycopyHead
			for o in copyRef where o.parent == undefined do copycopyHead =  o
-- 			format "copycopyHead: %\n" copycopyHead
			
			-- transposer la source
			copycopyHead.position = groupHead.position
			
			-- supprimer la cible
			format "deletion group %\n" i
			for o in selAr[i] do
			(
				format "o: %\n" o
				if isvalidnode o then delete o
			)
		)		
-- 		format "source: selAr[%]: %\n" SelArId   selAr[SelArId]
	)
	
)
CreateDialog Balconizer2RLT

