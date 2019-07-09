-- getclassinstances vrayMtl 
-- getclassinstances CoronaNormal
-- getclassinstances colorcorrect
-- getclassinstances CoronaNormal
-- getclassinstances CoronaNormal

-- str = stringstream ""
-- showClass "CoronaNormal" to: str


-- get list of missing plugin classes
str = stringStream ""
apropos "*missing*" to:str
seek str 0
cls = #()
while not (eof str) do (
	ln = readLine str
	tk = filterString ln " "
	if tk.count == 4 then (
		clsName = tk[1]
		try (
			val = (execute clsName)
			sc = superClassOf val
			-- Alternative: check for .classID == #(-1,0)
			if sc==MAXWrapper or sc==node or sc==material or sc==MAXWrapperNonRefTarg then (
				append cls val
				format "%: %\n" c val
			) else (
				format "Skipping % (%)\n" val sc
			)
		) catch (
			format "Cannot use % for searching missing plugins.\n" clsName
		)
	) 
	else
	(
		format "Incorrect string found in missing plugin name list: %\n" tk
	)
)


-- now search for instances of those missing plugins
c = 0
k = 0
missingClasses = #()
foundMissing = #()
for j = 1 to cls.count do
(
	cc = cls[j]
	ci = getClassInstances cc
	if ci.count > 0 then 
	(
		format "%: Found % instances of %: %\n" j ci.count cc ci
		for c in ci do 
		(
			format "%\n" (classof c)
			reff = refs.dependents c
			format "reff: %\n" reff
			for r in reff where superclassof r == material do
			(
				k += 1
				meditmaterials [k] = r
				format "k: % mat: %\n"k r
			)
		)
	) 
	
	if k == 24 then exit
) 

-- mat = refs.dependents missingClasses[2] immediateOnly: false
-- meditmaterials[1] = mat[2]


-- edit material avec du raytrace
rayTraceAr = getclassinstances raytrace 
for r in rayTraceAr do
(
	maps = refs.dependents r
	i = 0
	if maps != undefined and maps.count>0 then
	(
		for m in maps where superclassof m == material do
		(
			i += 1
			meditmaterials [i] = m
	-- 		print m
		)
	)
	else(format "no raytrace\n")
)

