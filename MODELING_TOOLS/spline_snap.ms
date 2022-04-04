
-- test d'impact des murs
sel = selection as array
s = sel[1]
t = sel[2]

spCount = numsplines s
numKnots s 
for sp = 1 to ( numsplines s) do
(
	p1 = getKnotPoint s sp 1
	p2 = getKnotPoint s sp 2

	p3 = getKnotPoint s sp ((numKnots s sp) - 1)
	p4 = getKnotPoint s sp (numKnots s sp)
	
	-- debug: je ne suis pas sur de calculer le rayon dans le bon sens
	v1 = normalize (p1 - p2)
	v2 = normalize (p4 - p3)

	r2 = ray p2 v1
	r1 = ray p3 v2

	impact1 = intersectRay t r1
	impact2 = intersectRay t r2
	-- determiner si l'impact ce fait sur un mur
	
	-- determiner la distance de l'impact
	
	format "sp: % impact1: %\n" sp impact1
	format "sp: % impact2: %\n" sp impact2
	
-- 	point pos: impact1.pos
-- 	point pos: impact2.pos
	setKnotPoint s sp 1 impact2.pos
	setKnotPoint s sp (numKnots s sp) impact1.pos
)

updateShape s