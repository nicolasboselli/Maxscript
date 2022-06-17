-- pour une selection de spline
-- determiner le vecteur depart et le vecteur fin
-- tester les vecteurs sur les en intersect

-- collecter les objets dans les calques murs
-- quand un objet impacté est sur un calque mur, en partant du dernier impact, faire l'ajustement
/* 
-- collecte des preparations de murs
fn collectLayer pattern: "*" =
(
	local layerFoundAr = #()
	for i = 0 to  (LayerManager.count - 1) do
	(
		l = LayerManager.getLayer i
		
		if  matchpattern l.name pattern: pattern then
		(
			append layerFoundAr l
-- 			"l.name: %\n" l.name
		)
	)
	layerFoundAr
)

fn rafle layerList: #() =
(
	local all = #()
	for l in layerList do
	(
-- 		format "l.name: %\n" l.name
		local tmp
		l.nodes &tmp
-- 		format "tmp: %\n" tmp
		for o in tmp do append all o
	)
	all
) */

-- lAr = collectLayer pattern: "_Splines Murs *"
-- rafle layerList: lAr

-- test d'impact des murs
sel = selection as array
s = sel[1]
t = sel[2]

spCount = numsplines s
numKnots s 
for sp = 1 to ( numsplines s)do
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
	if not impact1 == undefined then
	(	
-- 		format "impact1.pos:%\n" = impact1.count
-- 		format "impact start sp:  % node: % pos: %\n"  sp impact1.pos (impact1[impact1.count][2].pos + [2,2,2] * v1)
		point pos: (impact1.pos) name: "impact start"
	)
	else(format "% no impact1\n" sp)
-- 	
	if not impact2 == undefined then
	(
-- 		format "impact2.count:%\n" = impact2.count
-- 		format "impact end sp: % node: % pos: %\n" sp impact2[impact2.count][1] (impact2[impact2.count][2].pos + [2,2,2] * v2)
		point pos:  (impact2.pos) name: "impact end"
	)
	else(format "% no impact2\n" sp)
)
