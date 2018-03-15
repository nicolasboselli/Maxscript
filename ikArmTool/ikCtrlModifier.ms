


-- global IKFKDataTmp
attr = attributes "ikCtrl"
(
	
	parameters main rollout: actions
	(		
		ikStretch type:#float  ui:ikStretchSP default:0
		ikSquash type:#float ui: ikSquashSP default:0 
		lock type:#float ui: lockSP default:0
		
		resize1 type:#float  ui:cuisseSizeSP default:0
		resize2 type:#float  ui:tibiaSizeSP default:0
	)
	
	rollout actions "IK/FK:"
	(
		group "ik:"
		(
			spinner ikStretchSP "Ik Stretch:" type: #float range: [0,1,0]
			spinner ikSquashSP "Ik Squash:" type: #float range: [0,1,0]
			spinner cuisseSizeSP "Resize 1:" type: #float  range:  [-100,100,0]
			spinner tibiaSizeSP "Resize 2:" type: #float  range:  [-100,100,0]
			spinner lockSP "Lock:" type: #float  range:  [0,1,0]
		)
				
		on ikToFkBT pressed do this.ikToFk = not this.ikToFk
		on fkToIkBT pressed do this.fkToIk = not this.fkToIk
	)	

	on create do
	(
		resize1.controller = bezier_float()
		resize2.controller = bezier_float()
		
		ikStretch.controller = bezier_float()
		ikSquash.controller = bezier_float()
		lock.controller = bezier_float()
	)
	
	
	-- connection
		-- stretch 
	
)
ikMod = EmptyModifier name: "IK_CTRL"
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