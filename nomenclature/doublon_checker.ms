
	

try(destroydialog doublonsCheckerRLT)catch()
rollout doublonsCheckerRLT "Doublons Checker"
(
	local doublonsAr
	
	multilistbox doublonMLB "doublons:"
	button refrehBT "refresh"
	
	fn initVars =
	(
		doublonsAr = #()
		for i = 1 to objects.count do
		(
			for j = i + 1 to objects.count do
			(
				if objects[i].name == objects[j].name then
				(
					format "name: %,  i: %, j: %\n" objects[i].name i j
					appendifunique doublonsAr objects[i]
					appendifunique doublonsAr objects[j]
				)
			)
		)
	)
	
	fn refrehUI =
	(
		doublonMLB.items = for d in doublonsAr collect d.name
	)
	
	on doublonsCheckerRLT open do
	(
		initVars ()
		refrehUI ()
	)
	
	on doublonMLB selectionEnd do
	(
		clearselection()
		for i in doublonMLB.selection do selectmore doublonsAr[i]
	)
	
	on refrehBT pressed do
	(
		initVars ()
		refrehUI ()
	)
	
)
createdialog doublonsCheckerRLT
