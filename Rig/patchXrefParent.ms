global patchXrefParent

fn exportPatchXrefParent =
(
	patchXrefParent = #()
	
	local assetNodesAr = for o in objects where o.modifiers[#Content_Node] != undefined collect o
		
	for a in assetNodesAr do
	(
		objs = for o in a.modifiers[#Content_Node].allcontentlist collect o.name
		parents = #()
		for o in a.modifiers[#Content_Node].allcontentlist do
		(
			if isvalidnode o.parent do append parents o.parent.name
			else append parents "NONE"
		)
		append patchXrefParent  #(a.name, objs, parents)
	)
	patchXrefParent
)
exportPatchXrefParent()



fn importPatchXrefParent =
(
	local assetNodesAr = for o in objects where o.modifiers[#Content_Node] != undefined collect o	
	
	for i = 1 to assetNodesAr.count do
	(
		for j = i to  patchXrefParent.count do
		(

			if assetNodesAr[i].name == patchXrefParent[j][1] then
			(
				format "a: %, p:%\n" assetNodesAr[i].name patchXrefParent[j][1]
				for a in patchXrefParent[j][2] do 
				(
					for b in patchXrefParent[j][3] do
						getnodebyname a
						getnodebyname b
						format "%.parent = %\n" a b
				)
			)
			else
			(
			)
		)
	)	
)
importPatchXrefParent()