emptyObjAr = #()
ignored = #()
objectCount = 0
ignoredCount = 0
i = 0
for o in geometry do
(
	i += 1 
	try
	(
		
		if o.numfaces == 0 then
		(
			objectCount += 1
			format "i:% o.name: % classof:% numfaces: % \n" i o.name (classof o) o.numfaces
			append emptyObjAr o
		)
	)
	catch
	(
		ignoredCount += 1
-- 		format "IGNORE i:% o.name: % classof:%  \n" i o.name (classof o) --o.numfaces
		append ignored o
	)
)

format "empty Objects count: %\n" emptyObjAr.count
format "ignored Count: %\n" ignored.count
select emptyObjAr
select ignored


i = 0
for o in ignored do
(
	i += 1
	try
	(
		addmodifier o (EmptyModifier name: "debug_numfaces")
		if o.numfaces == 0 then
		(
			format "i:% o.name: % classof:% numfaces: % \n" i o.name (classof o) o.numfaces
		)
		for m in o.modifiers do
		(
			if iskindof m EmptyModifier and  m.name == "debug_numfaces" then deletemodifier o m
		-- 	format "%\n" m.name
		)
	)
	catch
	(
		for m in o.modifiers do
		(
			if iskindof m EmptyModifier and  m.name == "debug_numfaces" then deletemodifier o m
		-- 	format "%\n" m.name
			format "IGNORE i:% o.name: % classof:%  \n" i o.name (classof o) --o.numfaces
		)
	)
)


/*
addmodifier o (EmptyModifier name: "debug_numfaces")
for m in o.modifiers do
(
	if iskindof m EmptyModifier and  m.name == "debug_numfaces" then deletemodifier o m
-- 	format "%\n" m.name
)
*/

-- $.modifiers[1]

-- iskindof $ AvizstudioToolsATiles

-- $.numfaces
	
-- 	select $Colore005

-- $.numfaces