ikMod = EmptyModifier name: "IKFK_Leg_CTRL"


-- global IKFKDataTmp
attr = attributes "ikfktool"
(
	
	parameters main rollout: actions
	(
		ikChain type: #node 
		
		ptDist1 type: #node 
		ptDist2 type: #node
		
		ikList type: #nodeTab tabSizeVariable:true
		ikCtrlList type: #nodeTab tabSizeVariable:true
		fkList type: #nodeTab tabSizeVariable:true
		switchList type: #nodeTab tabSizeVariable:true
		
		ikfkVal type:#float ui: ikFkSp default:0
		stretchNsquash type: #point3 
		
		ikStretch type:#float  ui:ikStretchSP default:0
		ikSquash type:#float ui: ikSquashSP default:0 
		tension type:#float ui: tensionSP default:1
		
		cuisseSize type:#float  ui:cuisseSizeSP default:0
		tibiaSize type:#float  ui:tibiaSizeSP default:0
		
		ikToFk type: #boolean default: false
		fkToIk type: #boolean default: false
		
-- 		snaps ik/fk
		on ikToFk set val do
		(
			format "ikTofk done: %\n" val
		)
		
		on fkToIk set val do
		(
			format "fkToik done: %\n" val
		)
		
-- 		resize
		on cuisseSize set val do
		(
			try(ptDist1.pos.controller[2].controller.z_position = val)catch(format "cuisse resize fail:%\n" ptDist1)
		)
		
		on tibiaSize set val do
		(
			try(ptDist2.pos.controller[2].controller.z_position = val)catch(format "cuisse resize fail:%\n" ptDist1)
		)
		
-- 		switch ik/fk
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
	)
	
	struct IKFKData 
	(
		ikList,
		ikCtrlList,
		fkList,
		switchList,
		ikChain,
		ptDist1,
		ptDist2
	)
	
	fn exportData =
	(
		IKFKDataTmp = IKFKData ikList: this.ikList ikCtrlList: this.ikCtrlList fkList: this.fkList switchList: this.switchList ikChain: this.ikChain ptDist1: this.ptDist1 ptDist2: this.ptDist2
		IKFKDataTmp
	)
	
	fn importData =
	(
		for p in getPropNames IKFKDataTmp do 
		(
			try(setproperty this p (getProperty IKFKDataTmp p))catch()
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
			spinner cuisseSizeSP "Cuisse Size:" type: #float  range:  [-100,100,0]
			spinner tibiaSizeSP "Tibia Size:" type: #float  range:  [-100,100,0]
			spinner tensionSP "Tension:" type: #float  range:  [-100,100,0]
		)
		
		group "snaps:"
		(
			button ikToFkBT "IK => FK"
			button fkToIkBT "FK => IK"
			
			button maxIkBT "IKmax"
		)
		
		on ikToFkBT pressed do this.ikToFk = not this.ikToFk
		on fkToIkBT pressed do this.fkToIk = not this.fkToIk

		on maxIkBT pressed do
		(
			-- calcul longueur optimale
			/*
			v1 = jambeRoot.pos - jambeTarget.pos
			v2 = piedTalon.pos - piedCheville.pos 

			v3 = v1 + v2

			(v3.x^2 +v3.y^2 + v3.z^2 )^0.5
			*/
			-- changer scale et changer longueur bone

		)
		/*
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
		*/
	)	
	
	rollout paramRLT "parameters:"
	(
		group "distance:"
		(
			button addptDist1BT ">>"
			edittext ptDist1ET "cuisse:" readonly: true
			button addptDist2BT ">>"
			edittext ptDist2ET "tibia:" readonly: true
			
-- 			button initBT "init"
-- 			button destroyBT "detroy paramRLT"
		)
		
		
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
			if this.ptDist1 != undefined then ptDist1ET.text = this.ptDist1.name
			if this.ptDist2 != undefined then ptDist2ET.text = this.ptDist2.name
			
			
			try (ikChainET.text = this.ikChain.name) catch()
			try(IKList.items = for o in this.ikList collect o.name)catch()
			try(IKCtrlList.items = for o in this.ikCtrlList collect o.name)catch()
			try(FKList.items = for o in this.FKList collect o.name)catch()
			try(SwitchList.items = for o in this.SwitchList collect o.name)catch()
		)
		
-- 		actions
		on addptDist1BT pressed do
		(
			this.ptDist1 = $
			refreshUI()
		)
		
		on addptDist2BT pressed do
		(
			this.ptDist2 = $
			refreshUI()
		)
		
		on paramRLT open do
		(
			refreshUI()
		)
		
		on params open do refreshui()
		
		on ExpBT pressed do
		(
-- 			IKFKDataTmp = IKFKData ikList: this.ikList ikCtrlList: this.ikCtrlList fkList: this.fkList switchList: this.switchList ikChain: this.ikChain ptDist1: this.ptDist1 ptDist2: this.ptDist2
			this.exportData()
		)
		
		on ImpBT pressed do
		(
			/*
			for p in getPropNames IKFKDataTmp do 
			(
				setproperty this p (getProperty IKFKDataTmp p)
			)
			*/
			this.importData()
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
		/*
		on initBT pressed do
		(
			if this.ptDist1 != undefined and this.ptDist2 != undefined do
			(
				this.stretchNsquash.controller = bezier_point3 ()
				this.stretchNsquash.controller = point3_script ()
				this.stretchNsquash.controller.AddNode  "dist1" this.ptDist1
				this.stretchNsquash.controller.AddNode  "dist2" this.ptDist2
-- 				this.stretchNsquash.controller.AddNode  "cuisseSize" this.ikList[2]
-- 				this.stretchNsquash.controller.AddNode  "tibiaSize" this.ikList[3]
				
				this.stretchNsquash.controller.script = @"varSize = distance dist1 dist2
varSize = distance dist1 dist2
[0,0,0]"
			)
		)
		*/
	)
		
	/*
	fn testFn =
	(
		if ptDist1 != undefined do
		(
			when transform ptDist1 change id: #testHandler do
			(
				format "transform: %\n" ptDist1.pos
			)
		)
		
		-- calculer les stretch à partir de la distance variable entre les deux points des taille fixes et des tailles variables
	)
	
	
	*/
	on load do 
	(
		global IKFKDataTmp
	)
	
	on create do
	(
		cuisseSize.controller = bezier_float()
		tibiaSize.controller = bezier_float()
		
		ikStretch.controller = bezier_float()
		ikSquash.controller = bezier_float()
		tension.controller = bezier_float()
	)
	
)
custAttributes.add ikMod attr
addmodifier $ ikMod

-- $.modifiers[#IKFK_Leg_CTRL].testFn()

/*
obj =  $Box003
when transform obj change id: #testHandler do
(
	format "transform: %\n" obj.pos
)

deleteAllChangeHandlers id: #testHandler
*/

-- deleteAllChangeHandlers