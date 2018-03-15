-- collecter les nom des layer
/*
maj:
	-- add recrod et rename
*/

/*
start = 1
end = 8
stateAr = for i = end to start by - 1 collect i
	
for r in stateAr do
(
	for i = 0 to (LayerManager.count - 1) do
	(
		local l = LayerManager.getLayer i
		if match
		format "i:% name: %\n" i l.name
	)
)
*/
struct etageState
(
	state,
	layHidden =#(),
	layUnHidden = #()
)

fn sortLayerByName v1 v2 =
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


try(destroydialog sceneStateEtageRLT)catch()
rollout sceneStateEtageRLT "Scene State Etage Assitant"
(
	-- vars
	global stateAr
	local layHiddenAr = #()
	local layUnHiddenAr = #()
	
	-- functions vars dependants
	fn collectLayers =
	(
		layHiddenAr = #()
		layUnHiddenAr = #()
		
		for i = 0 to (LayerManager.count - 1) do
		(
			local l = LayerManager.getLayer i
			if l.ishidden then append layHiddenAr l else append layUnHiddenAr l
		)
		
		qsort layHiddenAr sortLayerByName
		qsort layUnHiddenAr sortLayerByName
	)
	
	-- UI
	groupBox statesGB "states:" pos:[5, 5]  width:200 height:350 

	button initStateBT "reset states array" pos:[10, 20] width: 100
	edittext stateET "name:" pos:[10, 50] width: 180
	button newBT "new" pos:[10, 70] width: 100
	multilistbox stateMLB "states:"pos:[10, 100] width: 180 height:17
	button activeBT "active sel state" pos:[10, 350]  width: 100
	
	groupBox selGB "selection:" pos:[220, 5]  width:350 height:350

	multilistbox layerHiddenMLB "hidden layers" pos:[230, 20] width: 130 height: 22
	button hideLayBT "<<" pos:[370, 80] 
	button unhideLayBT ">>" pos:[370, 120] 
	multilistbox layerVisibleMLB "visibles layers" pos:[410, 20] width: 130 height: 22
	
	-- Functions ui dependant
	fn refreshUI =
	(
		layerHiddenMLB.items = for o in layHiddenAr collect o.name
		layerVisibleMLB.items = for o in layUnHiddenAr collect o.name
		stateMLB.items =  for o in stateAr collect o.state
	)
	
	-- actions
	on sceneStateEtageRLT open do
	(
		if stateAr == undefined then  stateAr =#()
		
		collectLayers()
		refreshUI()
	)
	
	on initStateBT pressed do
	(
		stateAr =#()
		refreshUI()
	)
	
	on newBT pressed do
	( 
-- 		print "youpi"
		
		local tmpState
		
		if stateET.text.count > 0 then 
		(
-- 			print "youpi"
			tmpState = etageState state: stateET.text layHidden: layHiddenAr  layUnHidden: layUnHiddenAr
-- 			tmpState.layHiddenAr = for l in layHiddenAr collect l
-- 			tmpState.layUnHidden = for l in layUnHiddenAr collect l
			
			format "%\n" tmpState
			append stateAr tmpState
		)
		else(print "bou")
		
		refreshUI()
	)
	
	on hideLayBT pressed do
	(
-- 		format "sel:%\n" layerVisibleMLB.selection
		for id in layerVisibleMLB.selection do
		(
			layUnHiddenAr[id].ishidden = true
		)
		
		collectLayers()
		refreshUI()
	)
	
	on unhideLayBT pressed do
	(
		for id in layerHiddenMLB.selection do
		(
			layHiddenAr[id].ishidden = false
		)
		
		collectLayers()
		refreshUI()
	)
	
	on activeBT pressed do
	(
		local ids = stateMLB.selection as array
		
	
-- 		for id in ids do format "%\n" stateAr[id]
		if ids.count == 1 then
		(
			for id in ids do
			(
				for l in stateAr[id].layHidden do l.ishidden = true
				for l in stateAr[id].layUnHidden do l.ishidden = false
			)
		)
	)
	
	
)
createdialog sceneStateEtageRLT width: 580 height: 400


-- sceneStateEtageRLTstateET.text
