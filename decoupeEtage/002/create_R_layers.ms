try(destroydialog createLayerRLT)catch()
rollout createLayerRLT "create R layers"
(
	spinner startrSP "start:" type: #integer across: 2
	spinner endrSP "end:" type: #integer range: [0,100,5]
	button createBT "create R layers"
	
	on createBT pressed do
	(
		format "% %\n" startrSP.value endrSP.value
		
		for i = startrSP.value to endrSP.value do
		(
			local rName = ("R"+(i as string))
			local rLayer = layermanager.getLayerFromName rName
			if rLayer == undefined then repLayer = layermanager.newLayerFromName  rName
		)

	)
)
createdialog createLayerRLT