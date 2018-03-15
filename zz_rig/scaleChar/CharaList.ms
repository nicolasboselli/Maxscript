-- maj: xx gérer les parentées
-- xx gérer les objets à scaler
-- xx  gérer le scale

--xx  gérer la suppression d'objets de la scene ou de node undefined dans le set de character
-- gérer la duplication du personnage
-- gérer l'application de l'animation d'un autre personnage, avec le mapping des objets
-- gérer l'importation d'un personnage dans une scène à partir de son helper

-- relever tous les objets avec des pistes d'animations
-- relever tous les objets avec le même nom

-- maxOps.CloneNodes ($ as array) expandHierarchy: true

rollout charNodesRLT "Character Explorer"
(
	local s = sGlob
	
	local parentObj
	
	local tempAr = #()
	local parentAr = #()
	local twistAr = #()
	
	local AllAr = #()
	local bonesAr = #()
	local shapeAr = #()
	local meshAr = #()
	local hlpAr = #()
	
	local selID = #()

-- 	label nodeLB "node:"

	group "helper"
	(
		editText helperET "name :" readonly: true
	)
	
	group "character objets:"
	(
		radiobuttons typesRB "types:" labels:#("all", "bones", "splines", "meshes", "helpers")
		multilistbox charaListLB height: 35
		edittext nameET "num: " readonly: true
		
		button addBT "add" across: 5
		button delBT "exclude"
		button selBT "Sel"
		button showbt "Select All"
		button sortBT "sort"
-- 		button classBT "clear"
		
		button upBT "^"across: 2
		button dwBT "v"
	)
	
	group "Actions"
	(
		button delCharBT "delete" across: 3
		button cloneBT "duplicate" 
		button exportBT "export"
	)
	
	group "character scale: "
	(
		spinner scaleSP "scale: " range: [1,200,1]
		
	)
	
	group "manage character scale: "
	(
		pickbutton rootPB "pick"
		multilistbox parentMB "root list: "
		button scanParentBT "scan"  across:5
		button addParentBT "add"
		button delParentBT "del"
		button showParentBT "show"
		button parentBT "link"
		
		/*
		multilistbox controllersMB "list to scale: "
		button scanTargBT "scan" across:4
		button addTargetBT "add" 
		button delTargetBT "del"
		button showTargetBT "show"
		*/
	)

	
-- 	functions
	fn refreshFN =
	(
		tempAr = #()
		for o in  s.charNodes do if o != undefined then append tempAr o
		tempAr = makeuniquearray tempAr
		 s.charNodes = for o in tempAr collect o
	)
	
	fn findTypeArFN =
	(
		AllAr = #()
		bonesAr = #()
		shapeAr = #()
		meshAr = #()
		hlpAr = #()
		
		for o in s.charNodes do
		( if o != undefined then
			(
				append AllAr o
				if classof o == bonegeometry then append bonesAr o
				if superclassof o == shape then append shapeAr o
				if  superclassof o == geometryclass and classof o != bonegeometry then append meshAr o
				if superclassof o == helper then append hlpAr o
			)
		)
	)

	fn compareNameFN v1 v2 =
	(
	-- 		local d = (length v1)-(length v2)
		d = case of
		(
			(v1.name < v2.name): -1
			(v1.name > v2.name): 1
			
			default: 0
		)
		return d
	)
	
	fn updateListFN =
	(
		case typesRB.state of
		(
			1: (
				charaListLB.items = for o in AllAr  collect o.name
				nameET.text = (AllAr.count as string)
				print AllAr.count
				)
			2: (
				charaListLB.items = for o in bonesAr  collect o.name
				nameET.text = (bonesAr.count as string)
				)
			3: (
				charaListLB.items = for o in shapeAr  collect o.name
				nameET.text = (shapeAr.count as string)
				)
			4: charaListLB.items = for o in meshAr  collect o.name 
			5: charaListLB.items = for o in hlpAr  collect o.name 
		)
	)
	
	
	
	fn excludeFN oneAr =
	(
		nameAr = for o in selID collect oneAr[o].name
-- 		
		idToDel = #()
		for a in nameAr do
		(
			
			for i = 1 to AllAr.count do if 	(a == AllAr[i].name) then append  idToDel i
-- 			
		)
-- 		print (idToDel as string)
		for i = idToDel.count to 1 by -1 do print s.charNodes[idToDel[i]]
		for i = idToDel.count to 1 by -1 do deleteitem s.charNodes idToDel[i]
	)
	

-- 	Events List
	on charNodesRLT open do
	(
		findTypeArFN ()
-- 		charaListLB.items = for o in AllAr  collect o.name
		updateListFN ()
		helperET.text = s.name
	)
	
	on typesRB changed state do
	(
		updateListFN ()
	)
	
	on addBT pressed do
	(
		
		for o in ($selection as array) do
		(
			append s.charNodes o
			tempAr = for o in s.charNodes collect o
		)
-- 		cleanArrayFN()
		refreshFN ()
		findTypeArFN ()
-- 		charaListLB.items = for o in AllAr collect o.name
		updateListFN ()
		
		
	)
	
	on upBT pressed do
	(
		newSel = #()
		for o in selID do
		(	
			if o <= 1 then exit

			bak = s.charnodes[o]
			
			-- supprimer l'objet 
			deleteitem  s.charNodes o
			
			-- insérer l'objet à une valeur -1 dans l'array
			insertitem  bak  s.charNodes (o-1)
			
			append newSel (o - 1)				
			
			selID = newSel
			
		)

		charaListLB.selection = selID as bitArray
		
		findTypeArFN ()
		updateListFN ()
	)
	
	on dwBT pressed do
	(
		newSel = #()
		
		for i = selID.count to 1 by -1 do
		(
-- 			print selID
			print selID[i]
			print (selID[i] >= s.charnodes.count)
			
			if (selID[i] >= s.charnodes.count) then exit

			bak = s.charnodes[selID[i]]
			
			-- supprimer l'objet 
			deleteitem  s.charNodes selID[i]
			
			-- insérer l'objet à une valeur +1 dans l'array
			if (selID[i]+1) > s.charnodes.count then
			append    s.charNodes bak
			else
			insertitem  bak  s.charNodes (selID[i]+1)
			
			append newSel (selID[i] + 1)				
			
		)
		
		if newsel.count == selID.count then
		(
		selID = sort newSel
		charaListLB.selection = selID as bitArray
		)
		
		findTypeArFN ()
		updateListFN ()
	)
	
	on delBT pressed do
	(
		findTypeArFN ()
-- 		exclude
		case typesRB.state of 
		(
			1: (
-- 				select(for o in selID collect AllAr[o])
-- 					findTypeArFN ()
					excludeFN AllAr
					refreshFN ()
					findTypeArFN ()
					updateListFN	()	
				)	
			2: ( 
-- 					findTypeArFN ()
					excludeFN bonesAr
					refreshFN ()
					findTypeArFN ()
					updateListFN	()				
				)
				
			3:(
-- 					findTypeArFN ()
					excludeFN shapeAr
					refreshFN ()
					findTypeArFN ()
					updateListFN ()
				)
			4:(
-- 					findTypeArFN ()
					excludeFN meshAr
					refreshFN ()
					findTypeArFN ()
					updateListFN ()
			)
			5:(
-- 					findTypeArFN ()
					excludeFN hlpAr
					refreshFN ()
					findTypeArFN ()
					updateListFN ()
			)
		)		
	)
	
	on showBT pressed do
	(
		findTypeArFN ()
		case typesRB.state of
		(
			1: select AllAr
			2: select bonesAr
			3: select shapeAr
			4: select meshAr
			5: select hlpAr
		)
	)
	
	on selBT pressed do
	(
		findTypeArFN ()
		case typesRB.state of
		(
			1: select(for o in selID collect AllAr[o])
			2: select(for o in selID collect bonesAr[o])
			3: select(for o in selID collect shapeAr[o]) 
			4: select(for o in selID collect meshAr[o])  
			5: select(for o in selID collect hlpAr[o])  
		)
	)
	
	on sortBT pressed do
	(
		findTypeArFN ()
		refreshFN ()
		brutAr = #()
		brutAr = for o in s.charNodes collect o
		qsort brutAr compareNameFN
		s.charNodes = for o in brutAr collect o
		findTypeArFN ()
		updateListFN ()
	)
	
	on exportBT pressed do
	(
-- 		print s
-- 		print AllAr
-- 		select ((#(s)) + AllAr)
		saveNodes ((#(s)) + AllAr) (maxFilePath + s.name)
	)
	
	on delCharBT pressed do
	(
		delete AllAr
		destroyDialog charNodesRLT
		delete s
	)
	
	on cloneBT pressed do
	(
		maxOps.CloneNodes s.charnodes expandHierarchy: true
	)

	on charaListLB selectionEnd  do
	(
		selID = charaListLB.selection as array
		print (selID as String)
	)
	
	/*
	on classBT pressed do
	(
		 s.charNodes = #()
		updateListFN ()
	)
	*/
	
-- 	EVENTS parents
	on scaleSP changed val do
	(
		try
		(
		parentObj.scale.x = val/100
		parentObj.scale.y = val/100
		parentObj.scale.z = val/100
		)catch(print "error2")
	)
	
	on rootPB picked obj do
	(
		rootPB.text = obj.name
		parentObj = obj
	)
	
	on scanParentBT pressed do
	(
		parentAr = #()

		for o in s.charNodes do 
		(
			if classof o == bonegeometry or superclassof o == shape  then
			(				
					local oLast
					while(o!= undefined) do 
					(
						oLast = o
						o = o.parent
					)
					if classof(oLast.scale.controller) != ScaleXYZ then append parentAr oLast
				
			)
		)
		parentAr = makeuniqueArray parentAr
		parentMB.items = for o in  parentAr  collect o.name
	)
	
	on showParentBT pressed do
	(
		select parentAr
	)
	
	on parentBT pressed do
	(
		for o in parentAr do o.parent = parentObj
	)
	
	/*
	on scanTargBT pressed do
	(
		twistAr = #()
		for o in s.charNodes do if classof(o.scale.controller) == ScaleXYZ then append twistAr o
		controllersMB.items = for o in twistAr collect o.name
	)
	
	on showTargetBT pressed do
	(
		select twistAr
	)
	*/
	
)


