
callbacks.removeScripts id:#printSelTest
fn returnSel =
(
	local sel = selection as array
	format "sel: %\n" sel
-- 	mouse.mode 
	format "mouse.mode : %\n" mouse.mode 
	format "mouse: %\n" mouse.buttonStates 
)
-- printSel()

fn returnVisSel =
(
)

callbacks.addScript #selectionSetChanged "returnSel()" id: #printSelTest
-- callbacks.removeScripts #selectedNodesPreDelete
