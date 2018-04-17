/*
-- maj:
	x- freezer les axe de scale
		-- aligner sur le fonde la box
	-- faire fonctionner sur une selection d'objet en respectant la hierarchie
	
	--  replace sur bounding box:
		-- revoir le systeme pour ne plus avoir a creer de groupe dans le processus
		-- ne plus se caler sur le pivot ou le centre des selection  mais recalculer le placement du pivot de la copy dans la bounding
		
	-- replace sur pivot
	
	-- mettre en place une collecte multiple de reference
	-- faire fonctionner le replace sur la selection la le multilistbox

-- bug:
	-- l'asset panneau solaire ne supporte pas le replac et je ne sais pas pourquoi
*/

filein "objReplacerDef2.ms"

try(destroydialog objReplacerRLT)catch()
rollout objReplacerRLT "objects replacer "
(
	local params = #("pos","rescaleXCB", "rescaleYCB", "rescaleZCB", "randomCB")
	--vars
	local modFFD
	local refObj = undefined
	local targetArr = undefined
	-- function
	local RLTvers = getScriptVersion (getThisScriptFilename())
		
	local refAr = #()
		
	-- ui
	/*
	group "Mono-Selection:"
	(
		button addRefBT "ref>>"
		edittext refnameET readonly: true
	)
	*/
	
	-- 	button replaceBT "replace!"

	
	group "Muli-Selections:"
	(
		multiListBox refArMLB "selection:"
		button addSelBT "add" across: 2
		button removeBT "remove"
	)
	checkbox randomCB "random" across: 2
	button replaceV3BT "replace on pivot"
-- 	button replaceV3BT "replace! v3" enabled: false
	
	group "re-scale:"
	(
	checkbox rescaleXCB "x"  checked: true across: 3 
	checkbox rescaleYCB "y"  checked: true
	checkbox rescaleZCB "z"  checked: true
	)
	
	button replaceV2BT "replace on bounding box" -- across: 2
	
	
	fn refreshUI =
	(		
		/*
		if isvalidnode refObj then refnameET.text = refObj.name else 
		(
			refnameET.text = "NONE"
-- 			format "refaites votre selection"
		)
		*/
		refArMLB.items = for o in refAr collect o.name
	)
	
-- 	actions
	
	on objReplacerRLT open do
	(
		loadRolloutParams objReplacerRLT Params
		if RLTvers != undefined then objReplacerRLT.title = objReplacerRLT.title + " v." + (RLTvers as string)
		refreshUI()
	)
	
	on objReplacerRLT close do
	(
		writeRolloutParams objReplacerRLT Params
	)
	
	-- connections
	on addRefBT pressed do
	(
		sel = selection as array
		refObj = checkReference sel
		refreshUI()
	)
	
	on addSelBT pressed do
	(
		local refObjTmp = checkReference2 (selection as array)
		
		for r in refObjTmp do appendifunique refAr r
		
		refreshUI()
	)
	
	on removeBT pressed do
	(
		refSelIdAr = refArMLB.selection as array
		
		for i = refSelIdAr.count to 1 by - 1  do
		(
			deleteitem refAr refSelIdAr[i]
		)
		refreshUI()
	)
	
	/*
	on replaceV2BT pressed do
	(
		targetArr = checkTargetSelectionFN()
		
		if refObj !=undefined and targetArr != undefined then
		(
			undo on
			(
				for s in targetArr do
				(
					if (s != refObj) then
					(
						if isvalidnode refObj then
						(
							local res = replaceObject2 refObj s  rescaleX: rescaleXCB.state rescaleY: rescaleYCB.state rescaleZ: rescaleZCB.state
		-- 					res = replaceRefDef refObj s
							format  "result: %\n" res
						)else(format "not valid node: %\n" refObj)
					)
					else
					(
						format "reference et target sont un même objet\n"
					)
				)
			)
		)
		else
		(
			format "check your selections.\n"
		)
	)
	*/
	
	
	on replaceV2BT pressed do
	(
		
		local refSelAr = for i in refArMLB.selection collect refAr[i]
		format "refSelAr: %\n" refSelAr
		
		local targetArr = selection as array
		format "targetArr: %\n" targetArr
		
		if refSelAr.count >= 1 and targetArr.count >= 1 then
		(
			undo on
			(
				jmax = refSelAr.count
				j = 0
				
				for s in targetArr do
				(
					-- calcul de j
					if randomCB.state then
					(
						-- suite
						j = random 1 jmax
					)
					else
					(
						-- random
						if j >= jmax then j = 0
						j += 1
					)
					
					-- replace
					if (s != refSelAr[j]) then
					(
						if isvalidnode refSelAr[j] then
						(

							-- definir id de ref objet à utiliser pour le replace
							local res = replaceObject2 refSelAr[j] s  rescaleX: rescaleXCB.state rescaleY: rescaleYCB.state rescaleZ: rescaleZCB.state
-- 							local res = replaceObjectOnPivot refSelAr[j] s 
							format  "result: %\n" res
							
						)else(format "not valid node: %\n" refObj)
					)
					else
					(
						format "reference et target sont un même objet\n"
					)
				)
			)
		)
		else
		(
			format "check your selections\n"
		)
		
	)
	
	
	on replaceV3BT pressed do
	(
		
		local refSelAr = for i in refArMLB.selection collect refAr[i]
		format "refSelAr: %\n" refSelAr
		
		local targetArr = selection as array
		format "targetArr: %\n" targetArr
		
		if refSelAr.count >= 1 and targetArr.count >= 1 then
		(
			undo on
			(
				jmax = refSelAr.count
				j = 0
				
				for s in targetArr do
				(
					-- calcul de j
					if randomCB.state then
					(
						-- suite
						j = random 1 jmax
					)
					else
					(
						-- random
						if j >= jmax then j = 0
						j += 1
					)
					
					-- replace
					if (s != refSelAr[j]) then
					(
						if isvalidnode refSelAr[j] then
						(
							-- definir id de ref objet à utiliser pour le replace
							local res = replaceObjectOnPivot refSelAr[j] s 
							format  "result: %\n" res
							
						)else(format "not valid node: %\n" refObj)
					)
					else
					(
						format "reference et target sont un même objet\n"
					)
				)
			)
		)
		else
		(
			format "check your selections\n"
		)
		
	)
	
)
createdialog objReplacerRLT width: 400


-- objReplacerRLT.randomCB.state
-- for i in objReplacerRLT.refArMLB.selection do print i
-- format "%\n" refArMLB.selection

/*
jmax = 27
j = 0
for i = 1 to 100 do
(	
	if j >= jmax then
	(
		j = 0
	)
	j += 1
	format "i : % , turn: % , treshold: % j: %\n" i turn treshold j
)
*/
