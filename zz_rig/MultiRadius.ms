rollout multiRadUI "multiradius"
(
	local blc =  bitmap 10 10 color: black
	local rge = bitmap 10 10 color: red filename:"redicon"
	local jau = bitmap 10 10 color: yellow
	local ble = bitmap 10 10 color: blue
-- 	display rge
	group "radius"
	(
		spinner radiusSp "radius:" range: [-100, 100, 0] scale: 0.001
	)
	
	group "color"
	(
		button rgeDrtBT "rge" across: 3 images: #(rge,  blc, 1, 1, 1, 1, 1)
		button jauMidBT "jau"  images: #(jau,  blc, 1, 1, 1, 1, 1)
		button bleGcheBT "bleu" images: #(ble,  blc, 1, 1, 1, 1, 1)
	)
	
	on radiusSp changed val do
	(
		for o in ($selection as array) do
		(
			try
			(
			o.radius = o.radius + (val*0.1)
			)catch(print "error")
		)		
	)
	
	on radiusSp buttonup  do
	(
		radiusSp.value = 0
	)
	
	on rgeDrtBT pressed do
	(
		try
		(
			for o in $selection do o.wirecolor = red
		)catch("error")
	)
	
	on jauMidBT pressed do
	(
		try
		(
			for o in $selection do o.wirecolor = yellow
		)catch("error")
	)
	
	on bleGcheBT pressed do
	(
		try
		(
			for o in $selection do o.wirecolor = blue
		)catch("error")
	)
	
)

createdialog multiRadUI