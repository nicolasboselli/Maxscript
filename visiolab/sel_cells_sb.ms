cl = LayerManager.getLayerFromName "Cells"

allCells = #()
for i = 1 to cl.getNumChildren() do
(
	ccl = cl.getchild i
	ccl.nodes &cells
	allcells += cells
-- 	format "%\n" cells
)
allCells.count
select allCells

for c in allcells do format "%:%\n" c.name (replace c.name 3 1 "0")


fn sortbyname v1 v2 =
(
	local trueV1
	local trueV2
	
	if v1.name.count == 4 then
	(
		trueV1 = replace v1.name 3 1 "0"
	)
	else if v1.name.count == 5 then
	(
		trueV1 = replace v1.name 3 1 ""
	)
	else()
	
	
	if v2.name.count == 4 then
	(
		trueV2 = replace v2.name 3 1 "0"
	)
	else if v2.name.count == 5 then
	(
		trueV2 = replace v2.name 3 1 ""
	)
	else()
		
	if ( trueV1 < trueV2 ) then -1
	else if ( trueV1 > trueV2 ) then 1
	else 0
)

qsort allCells sortbyname

for c in allcells do format "%:%\n" c.name (replace c.name 3 1 "0")

-- replace "A251" 3 1 "0"

-- test pour comprendre le fonctionnement du qsort: j'ai pas compris
fn sortbymagic a b =
(
	format "test after: %\n" test
	k += 1
	local d
	
	if ( a < b) then d = -1
	else if ( a > b ) then d = 1
	else d = 0
	
	format "k % test before: % compare a: % and b: % result: % "k test a b d 
	d
)

k = 0
test = #(666,1,2,3,4,5,6,7,8)

qsort test sortbymagic