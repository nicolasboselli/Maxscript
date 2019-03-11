getclassinstances vrayMtl 
getclassinstances CoronaNormal
getclassinstances colorcorrect
getclassinstances CoronaNormal
getclassinstances CoronaNormal

str = stringstream ""
showClass "CoronaNormal" to: str


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
	) else (
		format "Incorrect string found in missing plugin name list: %\n" tk
	)
)


-- now search for instances of those missing plugins
c = 0
missingClasses = #()
foundMissing = #()
for j = 1 to cls.count do (
	cc = cls[j]
	ci = getClassInstances cc
	if ci.count > 0 then (
		format "%: Found % instances of %: %\n" j ci.count cc ci
		for c in ci do append missingClasses c
		for i = 1 to ci.count do (
			-- get current class
			myClass = classOf cc
			append foundMissing myClass
			-- get list of all subclasses
			allClasses = myClass.classes
			for k = 1 to allClasses.count do (
				-- search for useful replacement
				if allClasses[k].creatable then (
					-- create new instance of default (first) class
-- 						newInst = createInstance allClasses[k]
					try (
						-- replace all instances (requires 3ds Max 2008+ or AVG extensions)
-- 							q = replaceInstances ci[i] newInst
						c += 1
						-- and exit for k loop
						exit
					) catch (
						format "Error replacing %\n" ci[i]
						format "Exception: %\n" (getCurrentException())
					)
				)
			) -- end: for k
			-- todo: what happens if NO useful replacement was found?
		) -- end: for i
	) -- end: if
) -- end: for j


-- mat = refs.dependents missingClasses[2] immediateOnly: false
-- meditmaterials[1] = mat[2]

refss = refs.dependents missingClasses[1] -- immediateOnly: true

-- edit material avec du raytrace
maps = getclassinstances raytrace 
maps = refs.dependents maps[1]
i = 0
for m in maps where superclassof m == material do
(
	i += 1
	meditmaterials [i] = m
	print m
)

