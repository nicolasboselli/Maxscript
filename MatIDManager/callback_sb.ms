

fn returnSel =
(
	local sel = selection as array
	format "sel: %\n" sel
)
printSel()

fn returnVisSel =
(
)

callbacks.addScript #selectionSetChanged "returnSel()" id: #printSelTest
callbacks.removeScripts #selectedNodesPreDelete
callbacks.removeScripts id:#printSelTest