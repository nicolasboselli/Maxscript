

-- create params
the_attr = attributes  attr
(
	parameters main rollout:params
	(
	worldWt type: #float ui:worldWt default:100
	valveWt type: #float ui:valveWt default:0 readonly: true
	)
	
	rollout params "Weapon Parameters"
	( 
	group "influences:"
		(
		spinner worldWt "world:" type: #float
		spinner valveWt "valve: " type: #float 
		)
	 )
)


struct trio 
(
	freeCtrl,
	machineCtrl,
	splineHlp,
	fn isOk =
	(
		res = false
		try
		(
			if freeCtrl.pos.y == machineCtrl.pos.y and freeCtrl.pos.y == splineHlp.pos.y then res = true
		)catch()
		res
	),
	fn constrain =
	(
		-- add position constraint
		splineHlp.position.controller = Position_XYZ ()
		splineHlp.position.controller = position_list ()
		splineHlp.position.controller.available.controller = position_constraint ()
		splineHlp.position.controller.position_constraint.controller.appendTarget freeCtrl 100
		splineHlp.position.controller.position_constraint.controller.appendTarget machineCtrl 100
	),
	fn clearConstrain = 
	(
		splineHlp.position.controller = Position_XYZ ()
	)
)

fn sortHlps =
(
	-- collect free control
	free_ctrl = for c in $tuyau_ctrl_hlp.children collect c
	-- collect machine control
	machine_ctrl = for c in  $tuyau_to_machine_ctrl_hlp.children collect c
	-- collect helper
	spline_hlp = for c in $tuyau_spline_ctrl.children collect c

	trioAr = #()
	-- make trio 
	if free_ctrl.count == machine_ctrl.count and  free_ctrl.count == spline_hlp.count then
	(
		print "good count"
		for i = 1 to free_ctrl.count do
		(
			oneTrio = trio()
			oneTrio.freeCtrl = free_ctrl[i]
			
			-- find first position value in free_ctrl
			refPosY = free_ctrl[i].pos.y

			-- look for value in machine_ctrl
			for mc in machine_ctrl where mc.pos.y == refPosY do
			(
				oneTrio.machineCtrl = mc
			)

			-- look for value in spline_hlp
			for sh in spline_hlp where sh.pos.y == refPosY do
			(
				oneTrio.splineHlp = sh
			)
			
			if oneTrio.isOk()== true then
			(
				append trioAr oneTrio
			)
		)
	)
	else (print "bad count")
	
	trioAr
)

trioAr = sortHlps()
trioAr[1].constrain()
trioAr[1].clearConstrain()

-- on each trio find controls and helper
for trio in trioAr do
(
	format "trio: %\n" trio
	-- on helper add position control list and orienattion control list
	trio.constrain()
	-- on helper add parameters free/machine
-- 	trio.clearConstrain()
	-- conect free parameter to machine parameter
	-- connect parameters to constraint weight	
)

-- toto = $toto
-- tata1 = $tata1
-- tata2 = $tata2

-- add position constraint
-- toto.position.controller = Position_XYZ ()
-- toto.position.controller = position_list ()
-- toto.position.controller.available.controller = position_constraint ()
-- toto.position.controller.position_constraint.controller.appendTarget tata1 100
-- toto.position.controller.position_constraint.controller.appendTarget tata2 100

/*
-- add params on controller
custAttributes.add toto the_attr

-- connect params
paramWire.connect  toto.attr[#worldWt] toto.attr[#valveWt] "100 - worldWt"

-- toto.position.controller.position_constraint.controller.weight.controller = bezier_float ()
-- toto.position.controller.position_constraint.controller.position_weight[1].controller

paramWire.connect  toto.attr[#worldWt] toto.position.controller.position_constraint.controller[#Position_Weight_0] "worldWt"
paramWire.connect  toto.attr[#valveWt] toto.position.controller.position_constraint.controller[#Position_Weight_1] "valveWt"

toto.position.controller.position_constraint.getNumTargets ()
toto.position.controller.position_constraint.getNode 1

toto.position.controller.position_constraint.controller.position_weight[2]

-- delete params
custAttributes.delete toto 1
toto.position.controller.position_constraint.controller.weight[1].controller = bezier_float()
toto.position.controller.position_constraint.controller.weight[2].controller = bezier_float()
*/