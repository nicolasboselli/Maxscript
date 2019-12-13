filein "transferPoint_lib.ms"

try(destroydialog transferPointMangerRLT)catch()
rollout transferPointMangerRLT "transfer points manager"
(
	-- VArs
	local masterAr = #()
	local selIDS
	local mastersSel
	
	-- UI
	group "Masters"
	(
		multilistbox mastersMTL "masters list:" height: 15
		checkbox selInSceneCB "selection auto"
	)
	
	group "Targets:"
	(
		multilistbox targetsMTL "targets list:" height: 15
	)
	
	-- UI functions
	fn refreshUI =
	(
		mastersMTL.items = for m in masterAr collect m.name
	)
	
	-- actions
	on transferPointMangerRLT open do
	(
		masterAr = getMasters()
		refreshUI()
	)
	
	on mastersMTL selectionEnd do
	(
		selIDs =  (mastersMTL.selection as array)
		mastersSel = (for id in selIDs collect masterAr[id])
		
		if selInSceneCB.state then select mastersSel
	)
)
createdialog transferPointMangerRLT