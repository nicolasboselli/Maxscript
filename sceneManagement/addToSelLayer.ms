sel = selection as array

dest = sel[sel.count]
pack = for i = 1 to (sel.count - 1) collect sel[i]

fn addtolayer pack dest =
(
	l = dest.layer
	for i = 1 to sel.count do l.addNode sel[i]
)

addtolayer pack dest