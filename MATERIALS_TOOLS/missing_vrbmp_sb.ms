-- collecte de tous les asset exterieurs manquants

ATSOP_paths 
-- ATSOps.GetDependentFiles (maxfilepath + maxFileName) false &ATSOP_paths IncludeOutputFiles: false
ATSOps.GetDependentFiles (maxfilepath + maxFileName) false &ATSOP_paths IncludeOutputFiles: false

for  i = 1 to ATSOP_paths.count do
(
	if not doesFileExist ATSOP_paths[i] then
	(
		format "i: % p: %\n" i  ATSOP_paths[i]
	)
)


-- collecte des vraybitmap manquant
vrbmpAr = getclassinstances VRayBitmap target: scenematerials
vrbmpAr.count
vrbmpAr[1].filename

i = 1
for b in vrbmpAr do
(
	
	if not doesfileexist b.Bitmap then
	(
		format "missing filename: %\n" b.filename
-- 		refdep = refs.dependents b  -- immediateOnly: true
-- 				meditmaterials[i] = b
		
		i +=1
		
/* 		for d in refdep do
		(
-- 					format "d: % classof: %, i:%\n" d (classof d) i
			if classof d == vraymtl then 
			(
				format "d: % classof: %, i:%\n" d (classof d) i
				if i < 24 then
				(
					meditmaterials[i] = d
					i += 1
				)
			)
		) */
	)
	else
	(
		--format "filename: %\n" b.Bitmap
	)
)



-- collecte des bitmap manquants 
bmpAr = getclassinstances Bitmaptexture target: scenematerials
bmpAr.count
missingBmpMAtAr = #()
-- bmpAr[1].filename
for i = 1 to bmpAr.count do
(
	if not doesfileexist bmpAr[i].filename then
	(
		format "i: % missing filename: % bmpAr[i]: % \n" i bmpAr[i].filename bmpAr[i]
		depAr = refs.dependents bmpAr[i] -- immediateOnly: true
		for d in depAr do
		(
			if iskindof d vraymtl then
			(
				format "	d: % d.class: %\n" d (classof d)
				append missingBmpMAtAr d
			)
		)
		format "\n\n"
	)
)
missingBmpMAtAr.count

for i =  1 to missingBmpMAtAr.count do
(
	if i > 24 then exit
	meditMaterials[i] = missingBmpMAtAr[i]
)

-- collecte des autodesk map manquants 
autoBmpAr = getclassinstances Autodesk_Map target: scenematerials
autoBmpAr.count
missingAutoBmpMAtAr = #()

-- bmpAr[1].filename
for i = 1 to autoBmpAr.count do
(
	bmpExist = true
	try(format "%\n" autoBmpAr[i].Parameters_Source)catch(bmpExist = false)
	if not bmpExist then
	(
		format "i: % missing filename: % \n" i autoBmpAr[i] 
		depAr = refs.dependents autoBmpAr[i] -- immediateOnly: true
		for d in depAr do
		(
			if iskindof d vraymtl then
			(
				format "	d: % d.class: %\n" d (classof d)
				append missingAutoBmpMAtAr d
			)
		)
		format "\n\n"
	)
)
missingAutoBmpMAtAr.count

for i =  1 to missingAutoBmpMAtAr.count do
(
	if i > 24 then exit
	meditMaterials[i] = missingAutoBmpMAtAr[i]
)

-- convertir les autodesk map en vrbitmap
autoBmpAr = getclassinstances Autodesk_Map target: scenematerials
autoBmpAr.count
missingAutoBmpMAtAr = #()
-- autoBmpAr[1].Parameters_Source.filename

-- bmpAr[1].filename
for i = 1 to autoBmpAr.count do
(
	bmpExist = true
	try(format "%\n" autoBmpAr[i].Parameters_Source)catch(bmpExist = false)
	if  bmpExist then
	(
-- 		bmpFile = autoBmpAr[i].Parameters_Source
		vrBmp = VRayBitmap HDRIMapName: autoBmpAr[i].Parameters_Source.filename
		
		replaceinstances autoBmpAr[i] vrBmp
	)
)
-- missingAutoBmpMAtAr.count



-- collecte des proxys manquants
vrProxAr = getclassinstances VRayProxy --target: scenematerials
missingVrProxyAr = #()
for i = 1 to vrProxAr.count do
(
	if not doesfileexist vrProxAr[i].filename then
	(
		format "i: % missing filename: % vrProxAr[i]: % \n" i vrProxAr[i].filename vrProxAr[i]
		depAr = refs.dependents vrProxAr[i] -- immediateOnly: true
		for d in depAr do
		(
			if iskindof d VRayProxy then
			(
				format "	d: % d.class: %\n" d (classof d)
				append missingVrProxyAr d
			)
		)
		format "\n\n"
	)
)
select missingVrProxyAr



