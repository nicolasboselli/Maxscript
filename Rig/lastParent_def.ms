
fn lastParent sel =
(
	undo on
	(
		format "parenting start\n" -- to: log
		local daddy = sel[sel.count]
		
		for i = 1 to (sel.count - 1) do
		(
			
			local parentable = true
			local parentInSel = false
			-- test parent dans la selection
			for j = 1 to (sel.count - 1) do
			(
-- 				tmpParent = sel[j].parent
				if isvalidnode  sel[i].parent and i != j then
				(
					format "i: %, parent: % ,j: %\n" sel[i].name sel[i].parent.name sel[j].name
					if sel[i].parent == sel[j] then 
					(
						
						parentable = false
						parentInSel = true
						exit
					)
				)
				else if  i != j then 
				(
-- 					format "i: %, parent: % ,j: %\n" sel[i].name sel[i].parent sel[j].name
					exit
				)
				
-- 				if parentable ==  false then 
			)
			
			-- exclusion des railclone
-- 			if classof sel[i] == RailClone_Pro then  parentable = false
			
			if not parentInSel then
			(
				-- test appartenance à un groupe 
				if isGroupMember sel[i] and not isGroupHead sel[i]  then parentable = false
			)
			
			-- prent
			try
			(
				if parentable then 
				(
-- 					format "i: %, groupHead: %, groupmember: %, parent: %, parentable:%, parentinsel: % \n" sel[i].name (isGroupHead sel[i])  (isGroupMember sel[i]) sel[i].parent parentable parentInSel
					sel[i].parent = daddy
				)
			)
			catch(format "FAIL: % , ERROR: %\n"  sel[i].name (getcurrentexception()))
		)
	)
)