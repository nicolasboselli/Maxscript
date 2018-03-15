rollout testEventRLT "test name"
(
	edittext nameSelET "name: " readonly: true
	button refreshBT "refresh"
	
	on refreshBT pressed do
	(
		sel = selection as array
		nameSelET.text = sel[1].name
	)
)
createdialog testEventRLT

  (
  global OpenDialogOnMoveCtrl_Rollout --this will hold the rollout for the dialog
global OpenDialogOnMoveCtrl_Function --this will hold the function
	  
  rollout OpenDialogOnMoveCtrl_Rollout "Assign Random Color" --this is the rollout
  (
  	button btn_randomColor "Generate Random Object Color!" width:200 height:30
  	button btn_closeDialog "Cancel" width:200
  	
  	on btn_randomColor pressed do --if the first button is pressed,
  	(
  		selection.wirecolor = random black white --assign a random color to all selected objects
  		destroyDialog OpenDialogOnMoveCtrl_Rollout --and close the dialog
  	)--end on
  	on btn_closeDialog pressed do --of the second button is pressed,
  	(
  		destroyDialog OpenDialogOnMoveCtrl_Rollout --just close the dialog without doing anything
  	)
  )
  
  fn OpenDialogOnMoveCtrl_Function = --this function is called by general event callback and registers a transform handle
  (
  	deleteAllChangeHandlers id:#OpenDialogOnMoveCtrl --remove previous handlers
  	if selection.count > 0 do --if the selection is not empty,
  	(--then register event handler to open dialog if the selection was transformed and control key was pressed
  		when transform selection change id:#OpenDialogOnMoveCtrl handleAt:#redrawViews do  
  		(
  			--only open dialog if Control key is down and Left mouse button is up:
  			if keyboard.controlPressed and not mouse.buttonStates[1] do 
  			(
  				createDialog OpenDialogOnMoveCtrl_Rollout 210 70 modal:true --open dialog as modal, blocking main thread
  			)--end if control pressed
  		)--end when
  	)--end if
  )
  
  callbacks.removeScripts id:#OpenDialogOnMoveCtrl --remove general callbacks with this ID
  --call function to register transform event handle for the current selection:
  callbacks.addScript #selectionSetChanged "OpenDialogOnMoveCtrl_Function()" id:#OpenDialogOnMoveCtrl 
  )

  
when name selection change do print "youhou"