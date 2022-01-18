
for o in objects do 
(
	
-- 	o.controller=prs() 	
	if classof o.parent == LinkComposite do
	(
		format "o.name = %\n" o.name
		o.controller=prs() 	
		o.parent = undefined 
	)
)

toDel = #()
for o in objects do
(
	if iskindof o linkComposite then
	(
		format "delete o.name = %\n" o.name
		append toDel o 
	)
	else
	(
		format "not delete o.name = % class = %\n" o.name (classof o)
	)
)
	
delete toDel

