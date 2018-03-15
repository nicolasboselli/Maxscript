	global OccExcludeList = # ()
	global OccluMap
		
		CountElts = re.NumRenderElements ()

		CurrentElts = for i = 0 to (CountElts - 1) collect re.getRenderElement i

		For o in CurrentElts do print o.elementname
			
		OccluElt

		For o in CurrentElts do 
		(
			if (o.elementname == ("occlu")) then 
			(
				print "ok"
				OccluElt = o
				print OccluElt
			)		
			else
			(
				print "raté" 
			)
		)

		OccluMap = OccluElt.texture

	

		
	for o in ($selection as array) do append OccExcludeList o
	OccluMap.resultAffectExcludeList = OccExcludeList
