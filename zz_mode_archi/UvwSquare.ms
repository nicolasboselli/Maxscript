-- squareSize = 200

-- rollout
try(destroyDialog UVSquareRLT)catch()

rollout UVSquareRLT "UVWmap Square"
(
-- 	edittext sizeET "Taille du cube :" text: "100"
	button bt100 "100" across: 3
	button bt200 "200"
	button bt500 "500"
	
	spinner sizeSp "taille du cube: " range: [0,10000,100] type:  #worldunits 
	radiobuttons axisRB labels: #("x","y","z")
	button gogoUVWMapBT "Go Go Uvwmap!"
	
	on bt100 pressed do sizeSp.value = 100
	on bt200 pressed do sizeSp.value = 200
	on bt500 pressed do sizeSp.value = 500
	
	on gogoUVWMapBT pressed do
	(
		for o in (selection as array) do
		(
			select o
			axis = case axisRB.state of (
			1: 0	
			2: 1
			3: 2)
			
			UvwSquare = Uvwmap  maptype: 4 length: sizeSp.value width: sizeSp.value  height: sizeSp.value  axis: axis
			modPanel.addModToSelection (UvwSquare) ui:on
		)
	)
)
createdialog UVSquareRLT


	 
