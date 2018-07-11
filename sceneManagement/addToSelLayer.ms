sel = selection as array

l = sel[sel.count].layer

for i = 1 to (sel.count - 1) do
(
	l.addnode sel[i]
)