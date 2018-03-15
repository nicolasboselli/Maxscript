
--######################################## IK CHAIN MODIFIER
-- IK
-- / ajout de stretch
-- / ajout de squash
	-- le squash ne fonctionne plus quand l'influence du skin est dépoée sur les ctls secondaire
-- resize biceps
-- resize avBras

-- / snap ik > fk
	-- resize des bones 
-- / snap fk > ik
	-- x orienter le controller hand sur le ctrl ik hand et pas sur le bone
	
-- hide/unhide ik/fk
-- faire une chaine fk qui prenne le scale plus intelligemment

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
-- 				this.ikCtrlList[i].transform = this.fkList[i].transform
				this.ikCtrlList[i].rotation = this.fkList[i].rotation
				this.ikCtrlList[i].position = this.fkList[i].position
			)
		)
		
		on fkToIkBT pressed do
		(
			for i = 1 to (this.ikList.count - 1) do
			(
				format "ik: % <= fk: %\n" this.ikList[i] this.fkList[i] 
-- 				this.fkList[i].transform = this.ikList[i].transform
				this.fkList[i].rotation = this.ikList[i].rotation
				this.fkList[i].position = this.ikList[i].position
			)
			
			this.fkList[3].rotation = this.ikCtrlList[3].rotation
			this.fkList[3].position = this.ikList[3].position
		)
	)	
	
	
	rollout params "Parameters:"
	( 
		struct IKFKData 
		(
			ikList,
			ikCtrlList,
			fkList,
			switchList,
			ikChain
		)
		
		global IKFKDataTmp
		
-- 		button addModBT ">>"
-- 		edittext ikModET "ik mod" readonly: true
		
		group "Import /Export"
		(
			button ImpBT "Import" across:2
			button ExpBT "Export"
		)
		
		button addIkChainBT ">>"
		edittext ikChainET "ik chain:" readonly: true
			
		listBox FKList "FK:"
		button addFkBT "add" 
		
		listBox IKList "IK Bones:"
		button addIkBT "add" 
		
		listBox IKCtrlList "IK CTRL:"
		button addIkCtrlBT "add" 

		listBox SwitchList "Switch:"
		button addSwBT "add" 
		
		fn refreshui =
		(
			ikMod = this
-- 			ikModET.text = ikMod.name
			
			try (ikChainET.text = this.ikChain.name) catch()
			IKList.items = for o in this.ikList collect o.name
			IKCtrlList.items = for o in this.ikCtrlList collect o.name
			FKList.items = for o in this.FKList collect o.name
			SwitchList.items = for o in this.SwitchList collect o.name
		)
		
		on params open do refreshui()
		
		on ExpBT pressed do
		(
			IKFKDataTmp = IKFKData ikList: this.ikList ikCtrlList: this.ikCtrlList fkList: this.fkList switchList: this.switchList ikChain: this.ikChain
		)
		
		on ImpBT pressed do
		(			
			for p in getPropNames IKFKDataTmp do 
			(
				setproperty this p (getProperty IKFKDataTmp p)
			)
			refreshui()
			
		)
		
		on addIkChainBT pressed do
		(
			s = selection as array
			if s.count == 1 and classof s[1] == IK_Chain_Object then ikMod.ikChain = $
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


-- transfer value
	-- prevoir methode export/import par structure
/*
src = $.modifiers[#IKFK_CTRL].ikfktool
for p in getPropNames src do 
(
	setproperty ikMod.ikfktool p (getProperty src p)
	format "%: %\n" p (getProperty src p)
)
*/

