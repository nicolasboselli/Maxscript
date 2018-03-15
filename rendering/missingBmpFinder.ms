sceneMatAr = scenematerials

badMatAr = #()

for mat in sceneMatAr do
(
	bitmapAr = getClassInstances  bitmaptex   target: mat

	for f in bitmapAr where f.filename != undefined do
	(
		
		if doesfileexist f.filename != true then
		(
			bmpTmp = openBitmap ((getFilenameFile f.filename) + (getFilenameType f.filename))
			if bmpTmp != undefined then
			(
				format "founded: %\n"  bmpTmp.filename
				f.filename = bmpTmp.filename
-- 				print bmpTmp.filename
			)
			else 
			(
				format "really missing: %\n"  f.filename
				appendifunique badMatAr mat
-- 				appendifunique badMatAr mat
			)
		)
	)		
)



-- bmpTmp = openbitmap "mpm_vol.06_p04_01_diff.JPG"

if badMatAr.count == 0 then print "scene clean"
else
(
	for i = 1 to badMatAr.count do
	(
		meditmaterials[i] = badMatAr[i]
	)
)



sceneMaps = usedMaps()
for b in sceneMaps do print b
sceneMaps.count
retest = makeuniquearray sceneMaps
retest.count

-- list scene map
objs = objects as array
for o in objs do
(
	maps =usedmaps o
	(
		for m in maps do print m
	)
)



allBmps = #()
for o in objs do
(
-- 	print (classof o)
	if o.material != undefined then
	(
		maps =usedmaps o
		for m in maps do
		(
			if findString m "S:" == 1 do print o
-- 			print m
			appendifunique allBmps m
		)
	)
)
allBmps.count

mBitmaps = getClassInstances BitmapTexture target: scenematerials
mBitmaps.count

-- f = @"S:\Groupe Carrere\2015\Visite Oculus_0315\Appartement_Crealys\Modelisation\Textures\KnittedFabric_displace.jpg"
-- findString f "S:" 

select (getnodebyname "Chaise Jardin 006")

maps =usedmaps $
for m in maps do print m


for m in sceneMaps do
(	
	index = findItem allBmps m
	if index >0 then 
	(
		print ("used map : " + m)
	)
	 else
	(	
-- 		result=1
		print ("garbage map : " + m)
-- 			replaceInstances m  tmpTex
		
	)

)



/*

test = meditMaterials[activeMeditSlot]
bitmapAr = getClassInstances  bitmaptex   target: test

for f in bitmapAr do print  f.filename 
	
enumerateFiles print #missing

enumerateFiles()
*/