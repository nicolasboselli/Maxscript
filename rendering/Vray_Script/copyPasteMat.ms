


try(destroydialog copyPasteMatRLT )catch()
rollout copyPasteMatRLT "copy/paste mat"
(
	local ref
	button copyBT "copy"
	button pasteBT "paste"
	
	on copyBT pressed do
	(
		ref = meditmaterials[activeMeditSlot]
	)
	
	on pasteBT pressed do
	(
		if ref != undefined then
		(
		replaceInstances meditmaterials[activeMeditSlot] ref
		)
	)
)
createdialog copyPasteMatRLT