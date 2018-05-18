/*
function clusterAttach objArr =
(
	j = 1
	count = objArr.count

	undo off
	(
		while objArr.count > 1 do
		(
			if classof objArr[j] != Editable_Poly then converttopoly objArr[j]

			polyop.attach objArr[j] objArr[j+1]
			deleteItem objArr (j+1)

			j += 1

			if (j + 1) > objArr.count then j = 1

		)
	)
	objArr[1]
)
*/

fn clusterAttach objArr =
(
	j = 1
	count = objArr.count

	undo off
	(
		while objArr.count > 1 do
		(
			if classof objArr[j] != editable_Mesh then converttoMesh objArr[j]

			attach objArr[j] objArr[j+1]
			deleteItem objArr (j+1)

			j += 1

			if (j + 1) > objArr.count then j = 1

		)
	)
	objArr[1]
)


fn combineMesh sel =
(
	
	if sel.count < 1000 and sel.count > 1 then
	(
		format "attach count: %\n"  sel.count
		for i = 2 to sel.count do
		(
			if classof sel[1].baseobject  == editable_Mesh and  classof sel[i].baseobject  == editable_Mesh then attach sel[1] sel[i] else (format "mesh error: %, %\n" sel[1].name sel[i].name)
		)
		format "attach done\n" 
	)
	else if sel.count == 1 or sel.count == 0 then
	(
		format "pas assez d'objets: % \n" sel.count
	)
	else
	(
		format "trop d'objets: % \n" sel.count
		format "attach fail\n"
		select sel
	)
)


sel = selection as array
bef = timeStamp()
clusterAttach sel 
format "cluster time: % ms\n" (timestamp() - bef)

sel = selection as array
bef = timeStamp()
combineMesh sel 
format "combine time: % ms\n" (timestamp() - bef)

