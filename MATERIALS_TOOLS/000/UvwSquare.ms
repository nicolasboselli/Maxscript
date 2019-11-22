-- squareSize = 200

-- rollout
try(destroyDialog UVSquareRLT)catch()

rollout UVSquareRLT "UVWmap Square"
(
-- 	edittext sizeET "Taille du cube :" text: "100"
	button bt100 "100" across: 3
	button bt200 "250"
	button bt500 "500"
	
	spinner sizeSp "taille du cube: " range: [0,10000,100] type:  #worldunits 
-- 	radiobuttons axisRB labels: #("x","y","z")
-- 	button checkBT "check"
	button gogoUVWMapBT "Go Go Uvwmap!"
	
-- UI functions
-- 	fn 
	
-- actions
	on bt100 pressed do
	(
		sizeSp.value = 100
		gogoUVWMapBT.pressed()
	)
	
	on bt200 pressed do 
	(
		sizeSp.value = 250
		gogoUVWMapBT.pressed()
	)
		
	on bt500 pressed do
	(
		sizeSp.value = 500
		gogoUVWMapBT.pressed()
	)
	
	on gogoUVWMapBT pressed do
	(
		local sel = selection as array
		local uvwMissingAr = #()
		
		-- 
		for s in sel do
		(
			try
			(
				-- traite les objets avec modifiers
				s.uvwmap.maptype = 4
				s.uvwmap.length = sizeSp.value
				s.uvwmap.width = sizeSp.value
				s.uvwmap.height = sizeSp.value
			)
			catch
			(
				-- collecte les objets sans modifiers 
				append uvwMissingAr s
			)
		)
		
		format "uvwMissingAr : %\n" uvwMissingAr
		-- traite les objets sans modifiers
		if uvwMissingAr.count > 0 then
		(
			local UvwSquare = Uvwmap  maptype: 4 length: sizeSp.value width: sizeSp.value  height: sizeSp.value  -- axis: axis
			select uvwMissingAr 
			modPanel.addModToSelection UvwSquare ui:on
			select sel
		)
			
		
		
	)
)
-- createdialog UVSquareRLT

-- bb = #($Box001, $Box002)
-- addmodifier bb (uvwmap())
	 
