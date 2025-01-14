
fn scanSceneObjects oneId =
(
	local objsById = for o in geometry where o.gbufferChannel == oneId collect o
	objsById
)	
-- scanSceneObjects 1

try(destroydialog gbufferChannelRLT)catch()
rollout gbufferChannelRLT "G buffer Objetc ID Tools"
(
	local idsAr = #(0,2,4,6,8,10,45,50,55)
	local labelsAr = #("none", "Vitres", "Menuiserie" , "Cloture", "GC", "Haies", "Habillage", "Herbe", "Arbres")
	local objsById = #()
	-- UI
	group "Objects IDs:"
	(
		radiobuttons sortSelBT "sort: " labels:#("by name", "by id") default: 1 -- enabled: false
		listbox idObjectsLB "objects IDs:"
		button selectBT "select  by ID"
		editText objectCountET "count:" readonly: true
		button applyBT "apply objects ID to selection"
	)
	
	group "render elements:"
	(
		button addMultiMatByObjBT "add Object IDs passes"
		button removeMultiMatByObjBT "remove Object IDs passes"
	)
	
	-- functions
	fn refreshUIList =
	(
		-- collecte des noms
-- 		format "collect materials start\n"
-- 		t1 = timestamp()
		labelsToDisp = #()
		
-- 		local collectMax = 100
		for i = 1 to labelsAr.count do
		(
			
			if sortSelBT.state == 1 then
			(
				append labelsToDisp ( labelsAr[i] + "  [" +  (idsAr[i] as string) + "]")
			)
			else if sortSelBT.state == 2 then
			(
				append labelsToDisp ( "[" +  (idsAr[i] as string) + "]  " + labelsAr[i] )
			)			
		)	
		
		idObjectsLB.items = labelsToDisp
	)
	
	-- actions
	on gbufferChannelRLT open do
	(
		refreshUIList()
	)
	
	on sortSelBT changed val do
	(
		refreshUIList()
	)
	
	on idObjectsLB selected val do
	(
-- 		format "id: %\n" idsAr[idObjectsLB.selection]
		objsById = for o in geometry where o.gbufferChannel == idsAr[idObjectsLB.selection] collect o
		objectCountET.text = objsById.count as string
-- 		objectCountET.text = ""
	)
	
	on selectBT pressed do
	(
-- 		objsById = for o in geometry where o.gbufferChannel == idsAr[idObjectsLB.selection] collect o
-- 		format "id % : %\n" idsAr[idObjectsLB.selection] objsById
		select objsById
-- 		objectCountET.text = objsById.count as string
	)
	
	on applyBT pressed do
	(
		sel = selection as Array
-- 		format "id: %\n" idsAr[idObjectsLB.selection]
		for s in sel do s.gbufferChannel = idsAr[idObjectsLB.selection]
	)
	
	on addMultiMatByObjBT pressed do
	(
		rem =MaxOps.GetCurRenderElementMgr ()

		for i = 1 to idsAr.count do
		(
			objsById = for o in geometry where o.gbufferChannel == idsAr[i] collect o
			if objsById.count == 0 then continue
			else
			(
				local superName = "objId_" + (idsAr[i] as string) +  "_" + labelsAr[i]
				local matSel = multimatteElement elementName: superName R_gbufID: idsAr[i] G_gbufID: idsAr[i] B_gbufID: idsAr[i] MatID: false
				rem.AddRenderElement matSel
			)
		)		
	)
	
	on removeMultiMatByObjBT pressed do
	(
		rem =MaxOps.GetCurRenderElementMgr ()
		
		-- suppression des passes multimat
		eltsNum = rem.NumRenderElements()
		for i = (eltsNum - 1) to 0 by -1 do
		(
			elt = rem.GetRenderElement i
			if iskindof elt multimatteElement then 
			(
				if not elt.MatID then rem.RemoveRenderElement elt
			)
		)
	)
	
	
)
createdialog gbufferChannelRLT