vrMtlAr = getclassinstances vraymtl target:  meditmaterials[activeMeditSlot]

for m in vrMtlAr do
(
	local tmpBmp = m.texmap_diffuse
	if tmpBmp != undefined then
	(
		if classof tmpBmp == bitmaptexture then
		(
			format "tmpBmp: %, filename: %, gamma: % \n"tmpBmp tmpBmp.filename tmpBmp.bitmap.gamma
		)
	)
)


bmpAr = getclassinstances bitmapTexture target:  scenematerials

i = 1
for b in bmpAr do
(
	try
	(
		if b.bitmap.gamma != 2.2 then
		(
			format "tmpBmp: %, filename: %, gamma: % \n" b b.filename b.bitmap.gamma
-- 			b.bitmap = openbitmap b.filename gamma: 2.2
		)
-- 		format "tmpBmp: %, filename: %, gamma: % \n" b b.filename b.bitmap.gamma
	)
	catch
	(
		format "fail: %\n" b
		meditmaterials[i] = b
		
		format "refs: %\n" (refs.dependents b)
		local dep = refs.dependents b
		for d in dep do
		(
			if classof d == vraymtl or classof d == standard then
			(
				meditmaterials[i] = d
				i += 1
			)
		)
	)
)

/*
showproperties  meditmaterials[activeMeditSlot]

refs.dependents bmpAr[1]
refs.dependants = 

test = openbitmap meditmaterials[activeMeditSlot].filename --gamma: 2.2
test.gamma

test = openbitmap bmpAr[1].filename
test.gamma

meditmaterials[activeMeditSlot].bitmap = openbitmap meditmaterials[activeMeditSlot].filename gamma: 2.2


bmpAr[1].bitmap.gamma
*/
