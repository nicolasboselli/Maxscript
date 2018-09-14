l = $Line013
r1 = $Rectangle011
r2 = $Rectangle010

murSplineAr = #("- Splines Murs Balcon", "- Splines Murs Ext", "- Splines Murs Fond")
-- recupérer les spline de murs
LayerManager.getLayerFromName "+ Sols"	
-- convertir le repere en spline
-- remonter le repere de 0.5 cm
-- tester l'eintersection des reperes et des murs
intersects l r2

-- trouver les knots à l'interieur du mur et les knot à l'exterieur
-- #(1,2), #(2,3), #(3,4), #(4,1)
kCount = numKnots r2
for i = 1 to kcount do
(
	pos1 = (getKnotPoint r2 1 i) - [0,0,500]
	testRay = (ray pos1 [0,0,1])
	format "i: % ray: %\n" i (intersectRay  l testRay)
)
-- en fonction des knots à l'interieur, trouver l'orientation en x du repère
	-- si 1 et 2 dedans
	


--trouver la position des knots contre les murs
	-- tester les rayons
		-- k1k2 depuis k1
		-- k2k1 depuis k2
		-- k3k4 depuis f4
		-- k4k3 depuis l4
		-- k2k3 depuis k2
		-- k3k2 depuis k3
		-- k4k1 depuis k4
		-- k1k4 depuis k1

--à partir de là on a l'orientation du repère et la bonne posiition des knots, il ne reste plus faire le gabarit à la bonne taille et faire un replace


#{1,2,3,4} -  #{2,3}
getKnotPoint r2 1 1