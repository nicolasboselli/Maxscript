-- $.isselected
-- $.ishidden



fn isolateSelectionCustom isolation=
(
	if not isolation then
	(
		for s in $* do
		(
			if not s.ishidden and not s.isselected then
			(
				s.ishidden = true
				append isolatedList s
			)
		)
		format "isolation done\n"
	)
	else if isolation then
	(		
		for i=isolatedList.count to 1 by - 1 do
		(
			if isvalidnode isolatedList[i] then 
			(
				isolatedList[i].ishidden = false
				deleteitem isolatedList i
			)
		)
		format "isolation end\n"
	)
	
	not isolation
)


-- isolate = isolateSelectionCustom isolate