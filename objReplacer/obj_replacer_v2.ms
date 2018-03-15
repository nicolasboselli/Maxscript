/*
-- maj:
	/- freezer les axe de scale
		-- aligner sur le fonde la box
	-- faire fonctionner sur une selection d'objet en respectant la hierarchie

-- bug:
	-- l'asset panneau solaire ne supporte pas le replac et je ne sais pas pourquoi
*/

filein "objReplacerDef2.ms"

try(destroydialog objReplacerRLT)catch()
rollout objReplacerRLT "objects replacer v.2"
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
	group "re-scale:"
	(
	checkbox rescaleXCB "x"  checked: true across: 3 
	checkbox rescaleYCB "y"  checked: true
	checkbox rescaleZCB "z"  checked: true
	)
	
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
			format "corrigez votre selection"
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
						local res = replaceObject2 refObj s  rescaleX: rescaleXCB.state rescaleY: rescaleYCB.state rescaleZ: rescaleZCB.state
	-- 					res = replaceRefDef refObj s
						format  "result: %\n" res
						)else(format "not valid node: %\n" refObj)
					)
					else
					(
						format "reference et target sont un même objet"
					)
				)
			)
		)
		else
		(
			format "check your selections."
		)
	)
	
)
createdialog objReplacerRLT
