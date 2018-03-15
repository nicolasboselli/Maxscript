
try(destroydialog renameRLT)catch()
rollout renameRLT "Renamer" width: 400
(
	-- vars
	local s
	local callSel
	
	-- function

			
	-- UI
	edittext nameET "name:"
	
	-- functions ui dependant
	fn updateUI =
	(
		sel = selection as array
		if sel.count == 1 then
		(
			s= sel[1]
		)
		else if sel.count == 1 or sel.count> 1 then
		(
			s = undefined 
		)
		
		if s != undefined then nameET.text = s.name
	)
	
	fn refreshUI_NEC ev nd = updateUI ()
	
	-- Actions
	on nameET changed val do
	(
		s.name =  val
	)
	
	on renameRLT open do 
	(
		callSel = NodeEventCallback  selectionChanged: refreshUI_NEC
		print "youpi"
	)
	
	on renameRLT close do
	(
		callSel = undefined
		print "ploufe"
	)
)
createdialog(renameRLT)

--  printName = undefined 