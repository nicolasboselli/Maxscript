-- asset
Content_Node_Attr = attributes "Content_Node" 
(
	local catNameList = #()
	local catContentList = #()
	
	parameters main --rollout: allContentRLT
	(	
		allContentList type: #nodeTab tabSizeVariable:true
		startList type: #intTab tabSizeVariable:true
		sizeList type: #intTab tabSizeVariable:true
		nameList type: #stringTab tabSizeVariable:true
	)
	
	fn checkNodeTab =
	(
		format "nameList: %\n"nameList
		format "startList: %\n" startList 
		format "sizeList: %\n" sizeList 
		format "allcontent:%\n" allContentList
	)
	
	
	fn loadNodeTab =
	(
		t1 = timeStamp()

-- 		format "loading start\n"
		catNameList = for nom in this.nameList collect nom
		catContentList = for nom in this.nameList collect #()
		
		if this.nameList.count >= 1 then
		(
-- 				format "check1\n"
			for id = 1 to this.nameList.count do
			(
				start =  this.startList[id] 
				end = this.startList[id] + this.sizeList[id] - 1
				for i = start to end where catContentList[id] != undefined do
				(
					if isvalidnode this.allContentList[i] then
					(
						append catContentList[id] this.allContentList[i]
					)
				)
			)
		)
		t2 = timeStamp()
		format "loading done: % ms\n" ((t2 - t1))
	)
	
	fn writeNodeTab =
	(
-- 		format "writing start\n"
		t1 = timeStamp()
		
		this.allContentList = #()
		this.startList = #()
		this.sizeList = #()
		this.nameList = #()
		
		counter = 1
		
		for i = 1 to catNameList.count do
		(
			sizeCount = 0
			-- name list
			append this.nameList catNameList[i]
			
			-- allcontentList
-- 			format "catContentList[%]: %\n" i catContentList[i]
			for c in catContentList[i] where isvalidnode c do
			(
				sizeCount +=1
				append this.allContentList c
			)
				
			-- size list
			append this.sizeList sizeCount
			
			-- start List
			if sizeCount > 0 then
			(
-- 					counter += 1
				append this.startList counter
				counter += sizeCount
			)else append this.startList 0
		)
		
		t2 = timeStamp()
		format "writing done: % ms\n" ((t2  - t1))
	)
	
	fn addNode2 cat =
	(
		sel = selection as array
		for s in sel do 
		(
			addNode = true
			
			-- empecher l'auto addition
			try
			(
				s.modifiers[#content_node].content_node.allContentList
				addNode = false
				format "self addition fail: %\n" s
			)
			catch()
			
			-- ajout
			if addNode do
			(
				for i = 1 to catContentList.count do
				(
					if cat == i then appendifunique catContentList[i] s
					else
					(
						/*-- supprimer des autres array -*/
						res = finditem catContentList[i] s
						if res > 0 then deleteitem catContentList[i] res
					)
				)
			)		
		)
	)
	
	fn remove cat =
	(
		sel = selection as array
		for s in sel do
		(
			removeNode = true
			
			if removeNode do
			(
				for i = 1 to catContentList.count do
				(
					if cat == i then
					(
						res = finditem catContentList[i] s
						if res > 0 then deleteitem catContentList[i] res
					)
					else()
				)
			)
		)
	)
	
	fn hideCat cat = for o in catContentList[cat] do o.ishidden = true
	fn unhideCat cat = for o in catContentList[cat] do o.ishidden = false
	
	fn selectCat cat clean: true = 
	(
		if clean then clearselection() else()
		for o in  catContentList[cat] do selectmore o
	)
	
	fn addCat newName = 
	(
		append  catNameList newName
		append  catContentList #()
	)

	
	rollout allContentRLT "Asset Nodes List:"
	(
		local menuRC
		local CatRCMenu

-- 		UI
		ListBox CatLB "Categories:"
		ListBox ContentsLB "Contents:"
		group "Import/Export:"
		(
			button expBT "Export" across: 2
			button impBT "Import"
		)

-- 		fn UI relatives
		fn refreshUI =
		(
			try
			(
	-- 			CatLB.items = for o in this.nameList collect o
				CatLB.items = for o in catNameList collect o
				ContentsLB.items = for o in catContentList[CatLB.selection] collect o.name
	-- 			format "members name: %\n" ContentsLB.items
			)catch(format "%\n" (getcurrentexception()))
		)
		
		fn createRCMenu =
		(
			rcmenu menuRC
			(
				menuItem addIT "add selection"
				menuItem remIT "remove selection" 
				
				on addIT picked do	
				(
					loadNodeTab ()
					id = CatLB.selection
-- 					format "id: %\n" id
					
					addNode2 id
					writeNodeTab ()
					
					refreshUI()
				)
				
				on remIT picked do 
				(
					loadNodeTab ()
					Id = CatLB.selection
-- 					objId = ContentsLB.selection
					remove id
					writeNodeTab ()
					
					refreshUI()
					
-- 					format "remove object: %\n" catContentList[catId][objId].name
				)
			)
		)
		
		fn createCatRCMenu =
		(
			rcmenu CatRCMenu
			(
				menuItem hideIT "Hide"
				menuItem unHideIT "Unhide"
				menuItem selectIT "Select"
				separator  sep1
				menuItem createIT "New"
				
				on hideIT picked do
				(
					loadNodeTab ()
					id = CatLB.selection
					hideCat id
				)
				
				on unHideIT picked do
				(
					loadNodeTab ()
					id = CatLB.selection
					unhideCat id
				)
				
				on selectIT picked do
				(
					loadNodeTab ()
					id = CatLB.selection
					selectCat id
				)
				
				on createIT picked do
				(
					loadNodeTab ()
					addCat "ROOT"
					writeNodeTab ()
					refreshUI()
					
				)
			)	
		)
		
		-- actions
		on allContentRLT open do 
		(
			loadNodeTab ()
			
			refreshUI()
			createRCMenu()
			createCatRCMenu()
		)
		
		on allContentRLT close do
		(
			writeNodeTab ()
		)
		
		on CatLB selected obj do
		(
-- 			format "categorie:%\n" catNameList[obj]
-- 			format "members: %\n" catContentList[obj]
			
			refreshUI()
		)
			
		
		on CatLB rightClick do
		(
			popUpMenu CatRCMenu rollout: allContentRLT
		)
		
		on ContentsLB rightClick do
		(
			popUpMenu menuRC rollout: allContentRLT
		)
		
		on expBT pressed do
		(
			global assetNodeData = #(this.allContentList, this.startList, this.sizeList, this.nameList)
			format "data: %\n" assetNodeData
		)
		
		on impBT pressed do
		(
			if not assetNodeData == undefined do
			(
				format "import start\n"
-- 				format "data: %\n" assetNodeData
				this.allContentList = for o in assetNodeData[1] where o != undefined collect o
				this.startList = for o in assetNodeData[2] where o != undefined collect o
				this.sizeList = for o in assetNodeData[3] where o != undefined collect o
				this.nameList = for o in assetNodeData[4] where o != undefined collect o
				format "import done\n"
				
				loadNodeTab ()
				refreshUI()
			)
		)
	)	
	
	on create do
	(
		nameList = #("ROOT","MAIN_CTRL", "RIG", "MDL", "FACIAL", "SECOND_CTRL")
		startList = for c in nameList collect 0
		sizeList = for c in nameList collect 0
	)
	
)


-- Init on creation

-- try(delete assetNode)catch()
-- assetNode = point name: "assetNode" box: true axistripod: false cross: false size: 100 wirecolor: green

Content_Node_Mod = EmptyModifier name: "Content_Node"
custAttributes.add Content_Node_Mod Content_Node_Attr
addmodifier $ Content_Node_Mod

-- cat = #("MAIN_CTRL", "RIG", "MDL", "FACIAL", "SECOND_CTRL")

-- assetNode.modifiers[#Content_Node].nameList = for c in cat collect c
-- assetNode.modifiers[#Content_Node].startList = for c in cat collect 0
-- assetNode.modifiers[#Content_Node].sizeList = for c in cat collect 0

/*
format "nameList: %\n"assetNode.modifiers[#Content_Node].nameList
format "sizeList: %\n" assetNode.modifiers[#Content_Node].sizeList 
format "startList: %\n" assetNode.modifiers[#Content_Node].startList 
format "allcontent:%\n" assetNode.modifiers[#Content_Node].allContentList
*/

-- assetNode.modifiers[#Content_Node].allContentRLT
	
-- $.modifiers[#Content_Node].catNameList
-- $.modifiers[#Content_Node].catContentList
-- $.modifiers[#Content_Node].checkNodeTab()
-- $ assetNode.modifiers[#Content_Node].allContentList 1



