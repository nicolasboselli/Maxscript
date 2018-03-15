-- RESET IN PLACE
-- !!: pour la duplication de la spine il faut placer les helper de la spine et les os avant la line dans l'array de selection et les controlleur de la spline aprés la line
fn resetInPlaceFN sel=
(
	bakPos = sel.position
	bakRot = sel.rotation
	
	sel.rotation = eulerangles 0 0 0
	sel.position = [0,0,0]
	
	resetxform sel 
	ConvertTo sel Editable_Poly
	
	sel.rotation = bakRot
	sel.position = bakPos
)

fn resetXformInPlace3 s =
(
	addmodifier s (xform ())
		
	s.modifiers[#xform].gizmo.rotation = inverse s.objectoffsetrot
	s.objectoffsetrot = (quat 0 0 0 1)

	s.modifiers[#xform].gizmo.position = s.objectoffsetpos
	s.objectoffsetpos = [0,0,0]

	resetscale s
	s.modifiers[#xform].gizmo.scale = s.objectoffsetscale
	s.objectoffsetscale = [1,1,1]
)


try(destroydialog XformRlt) catch()
rollout XformRlt "Xform in place"
(
	-- backup de la rotation
	local s
	local bakRot

	-- backup de la position
	local bakPos

	button disposeBT "dispose"
	radiobuttons upAxisRB labels: #("x","y","z") default: 3
	
	button cancelBT "cancel"
	button applyBT "reset xform"
	
	button xpressXformBT "Xpress Xform!"
	
	fn upDateUpAxisFN =
	(
		try
		(
			/*
			s = $
			-- 			backup
			bakRot = s.rotation
			bakPos = s.position
			*/
			case upAxisRB.state of
			(
				1: (
					s.rotation = eulerAngles 0 90 0
					s.position = [0,0,0]
				)
				2: (
					s.rotation = eulerAngles -90 0 0
					s.position = [0,0,0]
				)
				3: (
					s.rotation = eulerAngles 0 0 0
					s.position = [0,0,0]
				)
			)
		)catch(print "error upDateUpAxisFN ")
	)
	
	fn uiStateOne =
	(
		upAxisRB.enabled = false
		cancelBT.enabled = false
		applyBT.enabled = false
		disposeBT.enabled = true
	)
	
	fn uiStateTwo =
	(
		upAxisRB.enabled = true
		cancelBT.enabled = true
		applyBT.enabled = true
		disposeBT.enabled = false
	)
	
	
	on XformRlt open do uiStateOne ()
	
	-- placement en zero
	on disposeBT pressed do 
	(
		
		try
		(
		s = $
-- 			backup
		bakRot = s.rotation 
		bakPos = s.position
		
		upDateUpAxisFN ()
-- 		s.rotation = eulerAngles 0 0 0
-- 		s.position = [0,0,0]
			
		uiStatetwo ()
			
		)catch(print "error selection")
		
	)
	
	
	on upAxisRB changed state do upDateUpAxisFN ()
	
	on cancelBT pressed do
	(
		-- application de la rotation 
		s.rotation = bakRot

		-- application de la position
		s.position = bakPos
				uiStateOne()
	)
	
	
	
	on applyBT pressed do
	(
		-- reset x forme
		resetxform s

		-- application de la rotation 
		case upAxisRB.state of
		(
			1: s.rotation = bakRot + ((eulerAngles 0 90 0) as quat)
			2:	s.rotation = bakRot + ((eulerAngles -90 0 0) as quat)
			3:	s.rotation = bakRot 
		)
		

		-- application de la position
		s.position = bakPos
		uiStateOne()
	)
	
	on xpressXformBT pressed do
	(
		sel = $selection as array
		for s in sel do
		(
			resetInPlaceFN s
		)
	)
)
createdialog XformRlt
