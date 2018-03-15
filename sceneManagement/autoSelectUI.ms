

fn findRoot sel =
(
	local selList = for o in sel collect o
	local rootList = #()
	for s in selList do
	(
		if s.parent == undefined then
		(
			appendifunique rootList s
		)
		else
		(
			appendifunique selList s.parent
		)
	)
	rootList
)


fn doesArraysEqual ar1 ar2 =
(
	res = false
	-- compare number of elements
	if ar1.count == ar2.count then sizeOk = true
		
	-- compare each element
	if sizeOk == true do
	(
		i = 0
		for a in ar1 do
		(
			for b in ar2 do
			(
				if a == b then
				(
					i += 1
				)
			)
		)
		if i == ar1.count do res = true
	)
	
	res
)





try(destroyDialog superSelectorRLT)catch()

rollout superSelectorRLT "super select"
(
	checkbutton selRootCB "auto-select root"
	
	fn selectRoot =
	(
		sel = selection as array
		rootAr = findRoot sel
		if doesArraysEqual sel rootAr == false then select rootAr else print "nothing"		
	)
	
	on selRootCB changed state do
	(
		if state == true then
		(
			print "true"
			callbacks.addScript #selectionSetChanged "superSelectorRLT.selectRoot()" id: #autoselect
		)
		else if state == false then
		(
			callbacks.removeScripts id: #autoselect
		)

	)
)
createdialog superSelectorRLT