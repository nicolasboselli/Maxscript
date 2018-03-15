geom = geometry as array
bsAr = #()

for g in geom do
(
	res = findstring g.name "_BIPSKIN"
	if res != undefined then append bsAr g
		
	
)
select bsAr


for s in bsAr do
(
-- s = $
skinAr = #(s, s.parent)
fn_changeBoneToBoneInfluence nodelist: skinAr
redrawviews ()

-- replace skinbip parent
dad = s.parent
childs = for c in s.children collect c
for c in childs do c.parent = dad

s.wirecolor = green 

setTransformLockFlags s #{}
)
select bsAr

