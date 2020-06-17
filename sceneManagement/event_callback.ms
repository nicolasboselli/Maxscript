411/*
maj: select the root of the hierarchy
*/

-- relative to action scene
fn testDef =
(
	selection as array
)

rollout testRLT "test callback"
(
	function selectHierarchy =
	(
		for p in selection do
		(
			if p.children != undefined do
			(
			selectmore p.children
			)
		)
	)
-- 	selectHierarchy()
	
	fn colorHierarchy =
	(
		sel = selection as array
		for s in sel do
		(
			print s.children
		)
	)
	
	editText selET "selection: "
	checkbutton colorBT "colorHierarchy"
	
	fn updateUIDef =
	(
		local sel = #()
		sel = testDef()
		if sel.count >= 1 then
		(
			selET.text = sel[1].name
		)
		else
		(
			selET.text = "?"
		)
	)
	

	
	on testRLT open do
	(
		callbacks.addScript #selectionSetChanged "testRLT.updateUIDef()" id: #updateUI
	)
	
	on testRLT close do
	(
		callbacks.removeScripts id: #updateUI
	)
	
	on colorBT changed state do
	(
		if state == true then
		(
			callbacks.addScript #selectionSetChanged "testRLT.selectHierarchy()" id: #colorHierarchy
		)
		else
		(
			callbacks.removeScripts id: #colorHierarchy
		)
	)
	
)
createdialog testRLT

/*
struct toto
(
	fn sayHello s =
	(
		print ("i want you " + s)
	)		
)

toto.sayHello "tata"
*/
-- test  = $.children 



