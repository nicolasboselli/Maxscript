
-- $.numFaces
fn clusterAttach objArr =
(
	j = 1
	k = 1
	count = objArr.count

	undo off
	(
		while objArr.count > 1 do
		(
			
-- 			format "numFaces %: %  numFaces %: % leftover: % \n" j objArr[j].numFaces (j+1) objArr[j+1].numFaces objArr.count
			
			if classof objArr[j].baseobject != editable_Mesh then converttoMesh objArr[j]
				
			-- DESINSTANCE
			
			if (InstanceMgr.CanMakeObjectsUnique objArr[j]) then
			(
				format "desinstance: %\n" objArr[j].name
				InstanceMgr.MakeObjectsUnique objArr[j] #prompt
			)
			
			if (InstanceMgr.CanMakeObjectsUnique objArr[j+1]) then
			(
				format "desinstance: %\n" objArr[j+1].name
				InstanceMgr.MakeObjectsUnique objArr[j+1] #prompt
			)
			
			-- ATTACH
			attach objArr[j] objArr[j+1]
			
			deleteItem objArr (j+1)
-- 			format "numFaces %: %  numFaces %: % last: %\n" j objArr[j].numFaces (j+1) objArr[j+1].numFaces objArr.count
			j += 1
			k += 1
			
			-- reveiller le script
			if k == 100 then 
			(
				format "\nobjects to attach left: %\n" objArr.count
				windows.ProcessPostedMessages()
				gc()
				k = 1
			)
			
			-- 
			if (j + 1) > objArr.count and  objArr.count > 1 then
			(
				format "\nj: % j+1: % objectTosattachCount: %\n" j (j+1) objArr.count
				j = 1
				format "numFaces %: %  numFaces %: % last: %\n" j objArr[j].numFaces (j+1) objArr[j+1].numFaces objArr.count
				
				windows.ProcessPostedMessages()
				gc()
			)
-- 			format "numFaces: %\n" objArr[j].numFaces
		)
	)
	objArr[1]
)

bef = timestamp()

clusterAttach (selection as array)
			
format "attach done: % s\n" (((timestamp()) - bef) / 1000 as float)

