
rollout rotUtilRLT "Rotation Utilities"
(
-- 	vars
	local bakSel
-- 	UI
	button SelTgtOneBT "Select Target 1"
	button SelTgtTwoBT "Select Target 2"
	
	button SelPickUpBT "Select PickUp Node"
	
	Button SelPrecBT "Selection Précédente"
	
-- events
	on SelTgtOneBT pressed do
	(
		try
		(
			bakSel = $
			select (bakSel.rotation.controller.getNode 1)
		)catch(print "error")
	)
	
	on SelTgtTwoBT pressed do
	(
		try
		(
		bakSel = $
		select (bakSel.rotation.controller.getNode 2)
		)catch()
	)
	
	on SelPickUpBT pressed do
	(
		try
		(
		bakSel = $
		select (bakSel.rotation.controller.pickUpNode)
		)catch()
	)
	
	on SelPrecBT pressed do
	(
		try
		(
		select bakSel
		)catch()
	)

)

createdialog rotUtilRLT