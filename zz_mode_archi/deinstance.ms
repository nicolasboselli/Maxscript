macroScript DeInstance
category:"emrahgunduz.com"
tooltip:"DeInstance Objects"
buttontext:"DeInstance"

(
	sel = selection as array
	count = 1

	if sel.count > 0 then
	(
		undo on
		(
			while count <= sel.count do
			(
				select sel[count]
				
				--Find if any instance is there for this object
				InstanceMgr.GetInstances $ &instances
				
				--For each instance, make it unique
				if instances.count > 0 do
					InstanceMgr.MakeObjectsUnique &instances #individual
				
				deselect $
				count += 1
			)
		)
		select sel
	)
	else
	(
		messageBox "You must select at least one or more objects" title:"MatID Random Material Assigner"
	)
)