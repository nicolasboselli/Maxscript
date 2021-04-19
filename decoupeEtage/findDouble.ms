allCellNames = #()

lCount = LayerManager.count
for i = 0 to (lCount - 1)  do
(
	l = LayerManager.getLayer i
	res = matchpattern l.name pattern: "Cells_*"
	if res then
	(
		format "%\n" l.name
		 l.nodes &nodes
		format "nodes: %\n" nodes
		for n in nodes do append allCellNames n
	)
)

qsort allCellNames sortbyname

-- for c in allCellNames do print c.name
doubleAr = #()
for i = 1 to (allCellNames.count - 1) do
(
	if allCellNames[i].name == allCellNames[i+1].name then
	(
		format "i: % i+1: %\n" allCellNames[i].name allCellNames[i+1].name
		append doubleAr allCellNames[i]
		append doubleAr allCellNames[i + 1]
	)
)
select doubleAr