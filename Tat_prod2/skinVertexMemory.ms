

-- todo:
	-- creer structure pour nommer set de selection
	-- delete set de selection
	-- fusionner set selection

try(destroydialog SkinVertSelRLT )catch()
rollout SkinVertSelRLT "vertex selection"
(
-- 	local selAr =#()
	global selAr
		
	button saveBT"save sel"
	listbox selLB "selections:"
	button loadBT "load sel"
	
	fn initSelAr =
	(
		if selAr == undefined then selAr = #()
	)
	
	fn refreshUI =
	(
		selLB.items = for i = 1 to selAr.count collect (selAr[i] as string)
	)
	
	on  SkinVertSelRLT open do
	(
		initSelAr()
		refreshUI()
		
	)
	
	on saveBT pressed do
	(
		m = modPanel.getCurrentObject() 
		if classof m == skin then
		(
			vxCount = $.editablepoly.GetNumVertices ()
			
			vxSelAr = #()
			for i = 1 to vxCount do
			(
				if (skinOps.IsVertexSelected  m i) == 1 then append vxSelAr i
			)
			append selAr vxSelAr
			refreshUI ()
		)else(print "select skin")
	)
	
	on loadBT pressed do
	(
		format "selnum: %\n"selLB.selection
		skinOps.SelectVertices m selAr[selLB.selection]
		redrawviews()
	)
	
)
createdialog SkinVertSelRLT