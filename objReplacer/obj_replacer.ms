-- maj:
	-- freezer les axe de scale
	-- faire fonctionner sur une selection d'objet en respectant la hierarchie

-- bug:
	-- l'asset panneau solaire ne supporte pas le replac et je ne sais pas pourquoi


filein "objReplacerDef2.ms"

try(destroydialog objReplacerRLT)catch()

rollout objReplacerRLT "objects replacer"
(
	--vars
	local modFFD
	local refObj = undefined
	local targetArr = undefined
	-- function
	
	-- ui
	button addRefBT "ref>>"
	edittext refnameET readonly: true
-- 	button replaceBT "replace!"

-- 	button centerBT "center selection"
	
	button replaceV2BT "replace!"
-- 	button replaceV3BT "replace! v3" enabled: false
	
	-- connections
	on addRefBT pressed do
	(
		sel = selection as array
		refObj = checkReference sel
		
		if refObj != undefined then 
		(
			format "reference selected : %\n"  refObj
			refnameET.text = refObj.name
		)
		else 
		(
			print "correct your selection"
		)
	)
	
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
						res = replaceObject refObj s
	-- 					res = replaceRefDef refObj s
						format  "result: %\n" res
						)else(format "not valid node: %\n" refObj)
					)
					else
					(
						print "reference and target are the same object"
					)
				)
			)
		)
		else
		(
			print "check your selections."
		)
	)
	
	
	on replaceV3BT pressed do
	(
-- 		create group on selection
	)
)
createdialog objReplacerRLT
