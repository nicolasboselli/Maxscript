select sel

def = attributes multi_parent_on_fly
(
	
	parameters main rollout:multi_parent (
		-- ajouter la nouvelle cible dans les constraint controller et dans le rollout
		-- création de parameter nodetab
		relaisLocked type:#node
		stack_relais type:#nodetab tabSizeVariable:true 
		)
	
	rollout multi_parent "Multi Constraints v.0.03" 
	( 
-- 		vars
		global bakSel = 1
	
-- 		UI
		pickbutton pickRelaisPB "choisir le relais"
		group "constraints"
		(
			listbox constraintListLB "liste des contraintes"
			pickbutton  pickCtrPB "add" across: 2
			button delCtrBT "dell"
			spinner ctrWeightSP "weight"
		)
		
		on multi_parent open do
		(
			print baksel
			constraintListLB.selection = bakSel
			if relaisLocked != undefined then
			(
			pickRelaisPB.text =  relaisLocked.name
			
			tgtNum = relaisLocked.rotation.controller.getNumTargets ()
			constraintListLB.items = for i = 1 to tgtNum collect (relaisLocked.rotation.controller.getnode i).parent.name
			)
		)
		
		on constraintListLB selected elt do
		(
			ctrWeightSP.value = relaisLocked.position.controller.weight[constraintListLB.selection]
		)
		
		on constraintListLB doubleClicked  elt do
		(
			bakSel = constraintListLB.selection
			weightNumMax = relaisLocked.position.controller.weight.count
			for i = 1 to weightNumMax do 
			(
					relaisLocked.position.controller.weight[i] = 0
					relaisLocked.rotation.controller.weight[i] = 0
			)
			relaisLocked.position.controller.weight[constraintListLB.selection] = 100
			relaisLocked.rotation.controller.weight[constraintListLB.selection] = 100
			
			select (relaisLocked.position.controller.getNode constraintListLB.selection).parent
-- 			constraintListLB.selection = bakSel
		)

		on pickRelaisPB picked obj do
		(
			relaisLocked = obj
			pickRelaisPB.text =  obj.name
			
			tgtNum = relaisLocked.rotation.controller.getNumTargets ()
			constraintListLB.items = for i = 1 to tgtNum collect (relaisLocked.rotation.controller.getnode i).parent.name
		)
		
		on pickCtrPB picked obj do
		(
			oneCirc = circle radius: 5 rotation: obj.rotation position: obj.position parent: obj name: obj.name
			oneCircHlp = point rotation: obj.rotation position: obj.position parent: oneCirc
			
			relaisLocked.position.controller.appendtarget oneCircHlp 100
			relaisLocked.rotation.controller.appendtarget oneCircHlp 100
			
			targetMax = relaisLocked.rotation.controller.getNumTargets ()
			
			targetMax = relaisLocked.position.controller.weight.count
			relaisLocked.position.controller.weight[targetMax].controller = bezier_float ()
			relaisLocked.rotation.controller.weight[targetMax].controller = bezier_float ()
			
			tgtNum = relaisLocked.rotation.controller.getNumTargets ()
			constraintListLB.items = for i = 1 to tgtNum collect (relaisLocked.rotation.controller.getnode i).parent.name
		)
		
		on delCtrBT pressed do
		(
			
			relaisLocked.position.controller.deleteTarget constraintListLB.selection
			relaisLocked.rotation.controller.deleteTarget constraintListLB.selection
			
			tgtNum = relaisLocked.rotation.controller.getNumTargets ()
			constraintListLB.items = for i = 1 to tgtNum collect (relaisLocked.rotation.controller.getnode i).parent.name
		)
		
		on ctrWeightSP changed val do
		(
			relaisLocked.position.controller.weight[constraintListLB.selection] = ctrWeightSP.value
			relaisLocked.rotation.controller.weight[constraintListLB.selection] = ctrWeightSP.value
		)
		
		
	)
		
	
)

modPanel.addModToSelection (emptymodifier ()) ui:on
custAttributes.add $.modifiers[#'Attribute Holder'] def