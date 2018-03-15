-- bitmap auto fit
-- add uvwmap
sel = $selection
for s in sel do
(	
	print s

	myUV = Uvwmap()

	addmodifier s myUV	 
	
	myBitmap = s.material.diffusemap.bitmap
	
	bitHeight = myBitmap.height
	bitWidth = myBitmap.width

	UVlength = myUV.length

	myUV.width = (UVlength*bitWidth)/bitHeight
)


-- get original file
-- calculate ratio
-- rationalize uvwmap size