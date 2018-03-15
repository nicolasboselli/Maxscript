collection = #()

fn collectObject objToCollect = 
(
	for obj in objToCollect.children do
	(
		append collection obj
		if obj.children.count > 0 then
		(
			collectObject obj
		)
	)
)

collectObject rootScene.world
collection.count


test = makeuniquearray  collection

test.count