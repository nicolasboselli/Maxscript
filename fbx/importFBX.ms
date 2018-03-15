findString "._test" "._"



-- importFile fbxList[15]


rollout fbxImport "fbx import"
(
-- 	vars
	local thePath = "W:\CocaCola_0315\MoCap\03arrivee terrain"
	local fbxList
	
-- 	functions
	fn collectFBX onePath =
	(
		local goodFbx = #()
		local tmpfbxList = getFiles (onePath + "\*.fbx")
		for fbx in tmpfbxList do
		(
			if (findString  (getFilenameFile fbx) "._") != 1 do
			(
				append  goodFbx fbx
			)
		)
		return goodFbx
	)
	
-- 	UI
	listbox fbxLB "FBX List:" height: 50
	button importFBXBT "import FBX"
	
-- 	actions
	
	on fbxImport open do
	(
		fbxList = collectFBX thePath
		fbxLB.items = for fbx in fbxList collect fbx
	)
	
	on importFBXBT pressed do
	(
		importFile fbxList[fbxLB.selection]
	)
)
createdialog fbxImport width: 500