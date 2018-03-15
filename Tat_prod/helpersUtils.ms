fn firstToAllPointSize =
(
	sel = selection as array
	ref = sel[1].size
	for s in sel where classof s == point do s.size = ref
)
firstToAllPointSize ()

try( destroydialog helpersUtilsRLT)catch()
rollout helpersUtilsRLT "Helpers Utils"
(
	button resizeBT "first size to all"
	on resizeBT pressed do firstToAllPointSize()
)
createdialog helpersUtilsRLT

$.wirecolor = green