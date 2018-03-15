-- maj: prévoir le switch des influences
-- 	local stack_relais = $.modifiers["Attribute Holder"].stack_relais
-- faire un retour d'état sur le slider ik/fk
-- rajouter un snap ik>fk

	
-- getThisScriptFilename() 

	def = attributes transfertMod
	(
		parameters one 
		(
			stack_relais type:#nodetab tabSizeVariable:true 
			stack_ikfk type:#nodetab tabSizeVariable: true
		)

		rollout tranfertFKIK "Transfert" 
		(
			
		-- 	UI
			
			slider transfertSL "Transfert FK/IK"  type:#float  ticks:5 range: [0,100,10]
			button selBT "Show Keys"
			/*
			group "Gestion Liste"
			(
				listbox objToTransLB "Objets a transférer"
				pickbutton addObjBT "add" across: 3
				button delObjBT "del"
	-- 			button printValBT "print value"
				button selObjBT "Sel"
			)
			pickbutton recupStackPB "récupérer un stack_relais"
			
			button switchRotBT "switcher rotation influence"
			button switchPosBT "switcher position influence"
			*/

		-- 	events
			on tranfertFKIK open do
			(
				if stack_relais.count > 0 then
				(
-- 					stack_relais = $.modifiers["Attribute Holder"].stack_relais
-- 					objToTransLB.items = for o in stack_relais collect o.name
					transfertSL.value = stack_relais[1].position.controller.weight[1]
				)
			)
			
			on transfertSL changed val do
			(
				for o in stack_relais do
				(
					o.position.controller.weight[1]  = val
					o.position.controller.weight[2]  = 100 - val
					
					o.rotation.controller.weight[1]  = val
					o.rotation.controller.weight[2]  = 100 - val
					
					if o.position.controller.weight[1] == 0 then  (o.position.controller.getnode 1).parent.ishidden = false  else  (o.position.controller.getnode 1).parent.ishidden = false
					if o.position.controller.weight[2] == 0 then  (o.position.controller.getnode 2).parent.ishidden = false else   (o.position.controller.getnode 2).parent.ishidden = false 
				)
			)
			
			/*
			on addObjBT picked obj do
			(
				append stack_relais obj
				objToTransLB.items = for o in stack_relais collect o.name
			)
			
			on delObjBT pressed do
			(
				
				deleteitem stack_relais objToTransLB.selection
				objToTransLB.items = for o in stack_relais collect o.name
			)
			
			on printValBT pressed do
			(
				if stack_relais.count > 0 then
				(
					print stack_relais[1].position.controller.weight[1]
					transfertSL.value = stack_relais[1].position.controller.weight[1]
				)
			)		
			
			on recupStackPB picked obj do
			(
				stack_relais = obj.modifiers[1].stack_relais
				objToTransLB.items = for o in stack_relais collect o.name
			)
			
			on switchPosBT pressed do
			(
				sel = stack_relais[objToTransLB.selection]
				nodeOne = sel.position.controller.getnode 1

				sel.position.controller.deleteTarget 1

				sel.position.controller.appendTarget  nodeOne 50
			)
			
			on switchRotBT pressed do
			(
				sel = stack_relais[objToTransLB.selection]
				nodeOne = sel.rotation.controller.getnode 1

				sel.rotation.controller.deleteTarget 1

				sel.rotation.controller.appendTarget  nodeOne 50
			)
			*/
			on selBT  pressed do
			(
				selAr = for o in  $.modifiers[1].stack_relais collect o
				select selAr
			)

		)
		rollout manageFKIK "Manage FKIK"
		(
			group "Gestion Liste"
			(
				listbox objToTransLB "Objets a transférer"
				pickbutton addObjBT "add" across: 3
				button delObjBT "del"
	-- 			button printValBT "print value"
				button selObjBT "Sel"
			)
			pickbutton recupStackPB "récupérer un stack_relais"
			
			button switchRotBT "switcher rotation influence"
			button switchPosBT "switcher position influence"
			
	-- 	events
			on manageFKIK open do
			(
				if stack_relais.count > 0 then
				(
-- 					stack_relais = $.modifiers["Attribute Holder"].stack_relais
					objToTransLB.items = for o in stack_relais collect o.name
-- 					transfertSL.value = stack_relais[1].position.controller.weight[1]
				)
			)
			
			
			on addObjBT picked obj do
			(
				append stack_relais obj
				objToTransLB.items = for o in stack_relais collect o.name
			)
			
			on delObjBT pressed do
			(
				
				deleteitem stack_relais objToTransLB.selection
				objToTransLB.items = for o in stack_relais collect o.name
			)
			
			on printValBT pressed do
			(
				if stack_relais.count > 0 then
				(
					print stack_relais[1].position.controller.weight[1]
					transfertSL.value = stack_relais[1].position.controller.weight[1]
				)
			)		
			
			on recupStackPB picked obj do
			(
				stack_relais = obj.modifiers[1].stack_relais
				objToTransLB.items = for o in stack_relais collect o.name
			)
			
			on switchPosBT pressed do
			(
				sel = stack_relais[objToTransLB.selection]
				nodeOne = sel.position.controller.getnode 1

				sel.position.controller.deleteTarget 1

				sel.position.controller.appendTarget  nodeOne 50
			)
			
			on switchRotBT pressed do
			(
				sel = stack_relais[objToTransLB.selection]
				nodeOne = sel.rotation.controller.getnode 1

				sel.rotation.controller.deleteTarget 1

				sel.rotation.controller.appendTarget  nodeOne 50
			)
			
			on selBT  pressed do
			(
				selAr = for o in  $.modifiers[1].stack_relais collect o
				select selAr
			)

		)
		
		rollout manageRIG "Manage Rig"
		(
			button selEntityBT "Select"
			
			on selEntityBT pressed do
			(
				selAr = for o in  stack_relais collect o
				select selAr
			)
		)
	)

myMod = emptymodifier name: "ikfk_transfert_bak"
custAttributes.add myMod def


try	
(
	try
	(
		bakStack = $.modifiers[1].stack_relais
		addmodifier $ myMod
		$.modifiers[1].stack_relais = bakStack
	)
	catch
	(
		addmodifier $ myMod
	)
)catch("erreur de selection")

-- ajout des parametres au modifier vide
-- select ctrPoint




-- $.modifiers["Attribute Holder"].stack_relais
