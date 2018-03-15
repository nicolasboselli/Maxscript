sel = selection as array
ref = sel[1].wirecolor

for i = 2 to sel.count do
(
	sel[i].wirecolor = ref
)
	