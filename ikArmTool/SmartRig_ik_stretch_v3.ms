
-- CREER UNE IK CHAIN


--à partir de trois bones
os = selection as array
if os.count == 3 do print "ok! good selection."
ik_chain = IKSys.ikChain os[1] os[3] "IKHISolver"

select ik_chain

IK_CTRL = point transform: os[3].transform axistripod: off cross: off Box: on wirecolor: green
ik_chain.parent = IK_CTRL

shoulder = point transform: os[2].transform axistripod: off cross: on Box: off parent: os[2] wirecolor: green
shoulder.position.controller.value.y = 2
shoulder.parent = undefined
--faire du point du milieu le controleur de la rotation de l'ik
ik_chain.transform.controller.VHTarget = shoulder


--######################################## IK CHAIN MODIFIER
-- IK
-- ajout de stretch
-- ajout de squash
	-- le squash ne fonctionne plus quand l'influence du skin est dépoée sur les ctls secondaire
-- resize biceps
-- resize avBras

-- snap ik > fk
-- snap fk > ik
	-- orienter le controller hand sur le ctrl ik hand et pas sur le bone

--##############################################     UI

ikMod = EmptyModifier name: "IKFK_CTRL"
toto = attributes "ikfktool" 
(
	parameters main rollout: actions
	(
		ikfkVal type:#float ui:ikFkSp default:0
		
		ikStretch type:#float ui:ikStretchSP default:0
		ikSquash type:#float ui:ikSquashSP default:0
		
		ikList type: #nodeTab tabSizeVariable:true
		ikCtrlList type: #nodeTab tabSizeVariable:true
		fkList type: #nodeTab tabSizeVariable:true
		switchList type: #nodeTab tabSizeVariable:true
		
		ikChain type: #node 
		
		on ikfkVal set val do
		(
			for o in switchList do
			(
				try
				(
					o.position.controller.position_constraint.controller.Position_Weight_0 = val
					o.position.controller.position_constraint.controller.Position_Weight_1 = 1 - val
						
					o.rotation.controller.orientation_constraint.controller.orientation_Weight_0 = val
					o.rotation.controller.orientation_constraint.controller.orientation_Weight_1 = 1 - val
					
					o.scale.controller.weight[1] = val*100
					o.scale.controller.weight[2] = (1 - val)*100
				)
				catch(format "exception: %\n" o)
			)
		)
		
		on ikStretch set val do
		(
			try(ikChain.modifiers[1].ikstretch = val)catch()
		)
		
		on ikSquash set val do
		(
			try(ikChain.modifiers[1].iksquash = val)catch()
		)
	)
	
	rollout actions "IK/FK:"
	(
		group "change:"
		(
			spinner ikFkSp "IK/FK:" type: #float range: [0,1,0]
		)
		
		group "ik:"
		(
			spinner ikStretchSP "Ik Stretch:" type: #float range: [0,1,0]
			spinner ikSquashSP "Ik Squash:" type: #float range: [0,1,0]
			spinner avBrasSizeSP "Av Bras Size:" type: #float 
			spinner bicepsSizeSP "Bicep Size:" type: #float 
		)
		
		group "snaps:"
		(
			button ikToFkBT "IK => FK"
			button fkToIkBT "FK => IK"
		)
		
		on ikToFkBT pressed do
		(
			for i = 1 to this.ikList.count do
			(
				format "ik: % => fk: %\n" this.ikList[i] this.fkList[i] 
				this.ikCtrlList[i].transform = this.fkList[i].transform
			)
		)
		
		on fkToIkBT pressed do
		(
			for i = 1 to this.ikList.count do
			(
-- 				format "ik: % => fk: %\n" this.ikList[i] this.fkList[i] 
				this.fkList[i].transform = this.ikList[i].transform
			)
		)
	)	
	
	
	rollout params "Parameters:"
	(
		
		button addModBT ">>"
		edittext ikModET "ik mod" readonly: true
		
		button addIkChainBT ">>"
		edittext ikChainET "ik chain:" readonly: true
			
		listBox FKList "FK:"
		button addFkBT "add" across: 4
		button delFkBT "del"
		button upFkBT "^"
		button dwFkBT "v"
		
		listBox IKList "IK Bones:"
		button addIkBT "add" across: 4
		button delIkBT "del"
		button upIkBT "^"
		button dwIkBT "v"
		
		listBox IKCtrlList "IK CTRL:"
		button addIkCtrlBT "add" across: 4
		button delIkCtrlBT "del"
		button upIkCtrlBT "^"
		button dwIkCtrlBT "v"
		
		listBox SwitchList "Switch:"
		button addSwBT "add" across: 4
		button delSwkBT "del"
		button upISwBT "^"
		button dwSwBT "v"
		
		fn refreshui =
		(
			try (ikChainET.text = this.ikChain.name) catch()
			IKList.items = for o in this.ikList collect o.name
			IKCtrlList.items = for o in this.ikCtrlList collect o.name
			FKList.items = for o in this.FKList collect o.name
			SwitchList.items = for o in this.SwitchList collect o.name
		)
		
		on params open do refreshui()
		
		on addIkChainBT pressed do
		(
			s = selection as array
			if s.count == 1 and classof s[1] == IK_Chain_Object then ikMod.ikChain = $
			refreshui()
		)
			
		on addModBT pressed do
		(
-- 			ikMod = $.modifiers[1]
			ikMod = this
			ikModET.text = ikMod.name
			refreshui()
		)
		
		on addFkBT pressed do
		(
			ikMod.fkList  = #()
			sel = selection as array
			for s in sel do append ikMod.fkList s
			refreshui()
		)
		
		on addIkBT pressed do
		(
			ikMod.ikList  = #()
			sel = selection as array
			for s in sel do append ikMod.ikList s
			refreshui()
		)
		
		on addIkCtrlBT pressed do
		(
			ikMod.ikCtrlList  = #()
			sel = selection as array
			for s in sel do append ikMod.ikCtrlList s
			refreshui()
		)
		
		on addSwBT pressed do
		(
			ikMod.switchList  = #()
			sel = selection as array
			for s in sel do append ikMod.switchList s
			refreshui()
		)
	)
)
custAttributes.add ikMod toto
addmodifier $ ikMod
