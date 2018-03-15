rollout switchAiletteRLT "Switch Ailette"
(
	local thestate = false
	local state = 1
	local gap = -1

	button switchAiletteBT "Switch Ailette"
	spinner sideFinsSP "size" range: [0,10,1]
	
	on switchAiletteBT pressed do
	(
		state = (state + gap)^2

		if state == 1 then thestate = true else thestate = false 

		for o in ($selection as array) do 
		(				
			if classof o == BoneGeometry then
			(
				o.sidefinssize = sideFinsSP.value
				o.frontfinsize =  sideFinsSP.value
				o.sidefins = thestate
				o.frontfin = thestate
			)
		)
	)
)

createdialog switchAiletteRLT

