-- name checker
	-- maj:
		-- relever les doublons
		-- relever les suffixes non conformes

fn sortbyname v1 v2 =
(
	-- qsort <array> sortbyname
-- 	vars
	local d
	
	if ( (toLower v1.name) < (toLower v2.name)) then
		d=-1
	else
		d=1
	
--compare les numeros entre eux et les classe	
	case of
	(
		(d < 0.): -1
		(d > 0.): 1
		default: 0
	)
)


try(destroydialog nameCheckerRLT)catch()
rollout nameCheckerRLT "Names Checker:"
(
-- 	vars
	global BaseName
	local objsAr
	
	local UtoDisp = #()
	local DtoDisp = #()
	local GtoDisp = #()
	local MtoDisp = #()
	
-- 	functions
	fn refreshAr search=
	(
		UtoDisp = #()
		DtoDisp = #()
		GtoDisp = #()
		MtoDisp = #()
		
		for o in objects do
		(
			if matchpattern o.name pattern: (search + "_D_*") ignoreCase: false then  append DtoDisp o
			else if matchpattern o.name pattern: (search + "_G_*") ignoreCase: false then  append GtoDisp o
			else if matchpattern o.name pattern: (search + "*") ignoreCase: false then  append MtoDisp o
			else  append UtoDisp o
		)
		
		qsort DtoDisp sortbyname
		qsort GtoDisp sortbyname
		qsort MtoDisp sortbyname
		qsort UtoDisp sortbyname
	)
	
-- 	UI
	editText basenameET "Basename"
	multilistBox undefinedLB "Undefined:" height: 60 across: 4 
	multilistBox DLB "Droit:" height: 60
	multilistBox GLB "Gauche:" height: 60
	multilistBox MLB "Milieu:" height: 60
	editText undefinedCountET "undefined:" readonly: true across:4
	editText DCountET "droit:" readonly: true
	editText GCountET "gauche:" readonly: true
	editText MCountET "Milieu:" readonly: true
	
	button refreshBT "refresh"
	
-- 	functions UI
	fn refreshUI =
	(
		if BaseName != undefined then basenameET.text = BaseName
		undefinedLB.items = for o in UtoDisp collect o.name
		DLB.items = for o in DtoDisp collect o.name
		GLB.items = for o in GtoDisp collect o.name
		MLB.items = for o in MtoDisp collect o.name
		undefinedCountET.text = UtoDisp.count as string
		DCountET.text = DtoDisp.count as string
		GCountET.text = GtoDisp.count as string
		MCountET.text = MtoDisp.count as string
	)
	

-- 	Actions
	on nameCheckerRLT open do
	(
-- 		id = 1
		try(refreshAr BaseName)catch(getCurrentException())
		refreshUI()
	)
	
	on basenameET changed val do
	(
		BaseName = val
		refreshAr BaseName
		refreshUI()
	)
	
	on undefinedLB selected id do select UtoDisp[id]
	on DLB selected id do select DtoDisp[id]
	on GLB selected id do select GtoDisp[id]
	on MLB selected id do select MtoDisp[id]
		
	on undefinedLB selectionEnd do
	(
		clearselection ()
		for i in undefinedLB.selection do  selectmore UtoDisp[i]
	)
	
	on DLB selectionEnd do
	(
		clearselection ()
		for i in DLB.selection do  selectmore DtoDisp[i]
	)
	
	on GLB selectionEnd do
	(
		clearselection ()
		for i in GLB.selection do  selectmore GtoDisp[i]
	)
	
	on MLB selectionEnd do
	(
		clearselection ()
		for i in MLB.selection do  selectmore MtoDisp[i]
	)
		
	on refreshBT pressed do
	(
		refreshAr BaseName
		format "refresh done \n"
		refreshUI()
	)

	
)
createDialog nameCheckerRLT width: 1200 --height: 800
