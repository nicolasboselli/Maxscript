fn numStringToChar num =
(
	local str = num as string
	local alphabet = "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
	local res = ""
	
	for i = 1 to str.count do
	(
		val =  str[i] as integer + 1
-- 		print alphabet[val]
		res = res + alphabet[val]
	)
	res
)


for i = 1 to scenematerials.count do  meditmaterials[i] = scenematerials[i]

-- publish not standard material
j = 0
for i = 1 to scenematerials.count where classof scenematerials[i] != standard and classof scenematerials[i] != multimaterial do
(
	j += 1
	meditmaterials[j] = scenematerials[i]
)

-- publish multimat and rename
j = 0
nameAr = filterString  maxFileName "_"
basename = nameAr[1] + "_" + nameAr[2]
alphabet = "ABCDEFGHIJKLMNOPQRSTUVWXYZ"

for i = 1 to scenematerials.count where classof scenematerials[i] == multimaterial do
(
	if j < 24 then
	(
		j += 1
		meditmaterials[j] = scenematerials[i]
		m = scenematerials[i]
		m.name = basename + "_Multi" + (numStringToChar j) + "_LD"
	)
	else (print "materials editor full")
)


for m in scenematerials do
(
	resMat = matchPattern m.name pattern: (basename + "_*_LD")
	if resMat == false then
	(
		m.name = substitutestring m.name (basename + "_") ""
		m.name = substitutestring m.name "_LD" ""
		m.name = substitutestring m.name "_ANM" ""
		m.name = basename  + "_" +  m.name + "_LD"
	)		
-- 	print m.name
)

-- collect bad materials
badMatAr = #()
for m in scenematerials do
(
	res = matchpattern m.name pattern: "A_EchafaudageElephant_*LD"
	if res != true then append badMatAr m
		
)
print badMatAr
for i = 1 to badMatAr.count do  meditmaterials[i] = badMatAr[i]

$.material = undefined

-- replace materials
fn replaceMat mat =
(
	bakMap = mat.texmap_diffuse 
	bakColor = mat.Diffuse
	bakName = mat.name
	
	replaceinstances mat (standard diffuseMap:bakMap name: bakName  diffuse: bakColor)
)
replaceMat meditmaterials[activeMeditSlot ]

-- replace vray material
mat = meditmaterials[activeMeditSlot ]
if classof mat == vraymtl then
(
	replaceMat mat
)
else if classof mat == multimaterial then
(
	
	for i = 1 to mat.count where classof mat[i] == vraymtl do
	(
		print "youpi"
		local newname
		bakMap = mat[i].texmap_diffuse 
		bakColor = mat[i].Diffuse
		bakName = mat[i].name
		aliasName = mat.names[i]
		format "bakMap: %, bakName: %, aliasName: % , calor: % \n" bakMap bakName aliasName bakColor
		if aliasName.count > 0 then newname = aliasName else newname = bakName
		
		replaceinstances mat[i] (standard diffuseMap:bakMap name: newname  diffuse: bakColor)
		
	)
)
else (format "material non traité: %\n" mat)


-- collect non conform name material
nameAr = filterString  maxFileName "_"
basename = nameAr[1] + "_" + nameAr[2]

j = 0
for i = 1 to scenematerials.count do
(
	m = scenematerials[i]
	res = matchpattern m.name pattern: ((basename) + "_*_LD" )
	if res == false then 
	(
		j += 1
		meditmaterials[j] = scenematerials[i]
	)
)