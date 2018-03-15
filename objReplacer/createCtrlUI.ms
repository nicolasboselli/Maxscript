/*
maj:
-- add spline box as option
-- add dummy as option
bug:
-- find parent of the selection before 
*/

filein "createCtrlDef.ms"

try(destroydialog addCtrlRLT)catch()
rollout addCtrlRLT "Add Controller Utility"
(

	
-- 	UI
	checkbox useOrientationCB "keep selection orientation"
	spinner ctrlSizeSP "control size:" range: [0.1,100000,40] type: #worldunits 
	group "add controller"
	(
		button addZplusCtrl "+z" across: 2
		button addZminusCtrl "-z"
		button addYplusCtrl "+y" across: 2
		button addYminusCtrl "-y"
		button addXplusCtrl "+x" across: 2
		button addXminusCtrl "-x"
	)
	button publishCtrlsBT "publish"
	
-- 	actions
	on addZplusCtrl pressed do
	(
		-- create group on selection
		sel = selection as array
-- 		print sel
		ctrl = createOneCtrl 26 sel useOrientationCB.state hlpsize: ctrlSizeSP.value
	)
	
	on addZminusCtrl pressed do
	(
		-- create group on selection
		sel = selection as array
		ctrl = createOneCtrl 25 sel useOrientationCB.state hlpsize: ctrlSizeSP.value
		
	)
	
	on addYplusCtrl pressed do
	(
		sel = selection as array
		ctrl = createOneCtrl 24 sel useOrientationCB.state hlpsize: ctrlSizeSP.value
	)
	
	on addYminusCtrl pressed do
	(
		sel = selection as array 
		ctrl = createOneCtrl 21 sel useOrientationCB.state hlpsize: ctrlSizeSP.value
	)
	
	on addXplusCtrl pressed do
	(
		sel = selection as array
		ctrl = createOneCtrl 18 sel useOrientationCB.state hlpsize: ctrlSizeSP.value
	)
	
	on addXminusCtrl pressed do
	(
		sel = selection as array
		ctrl = createOneCtrl 9 sel useOrientationCB.state hlpsize: ctrlSizeSP.value
	)
	
	on publishCtrlsBT pressed do
	(
		sel = selection as array
		undo on 
		(
			for i = 1 to 27 do
			(
				createOneCtrl i sel useOrientationCB.state hlpsize: ctrlSizeSP.value
				for s in sel do s.parent = undefined
			)
		)
	)
	
)

createdialog addCtrlRLT

