

surfaces = for i = 1 to $.numfaces collect  (polyop.getFaceArea $ i)

-- sort surfaces

b = box length: 10 width: 10 height:10
for s in surfaces do
(
	format "size: %\n" ((s/1000.0))

	c = copy b
	move b [50,0,0]
	b.height = s/100.0
)

	
