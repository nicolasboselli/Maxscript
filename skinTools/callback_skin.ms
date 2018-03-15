show $.modifiers[#skin]

skinOps.GetSelectedBone $.modifiers[#skin]

fn printBnSel ev nd = print(skinOps.GetSelectedBone $.modifiers[#skin])
printBnSel()

callbacks.addScript #selectionSetChanged "printBnSel()" id: #bnSelChange

callbacks.removeScripts id: #bnSelChange


necTest = NodeEventCallback  subobjectSelectionChanged: printBnSel

-- deletion
necTest = undefined
gc light:true