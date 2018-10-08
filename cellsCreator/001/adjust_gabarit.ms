-- recupérer les spline des fenetres, porte ... etc...
/*
 debug: le sript ne fonctionne pas sur des repères déja réorientés
	-- c'est l'ordre horaire des points qui pose problème
	-- le reverse de spline focntionne mais pas le script  reverse spline
*/


-- teste si le repère est dans un mur
fn testImpactID l id =
(
	-- return boolean
	
	layerList = #("- Splines Murs Ext", 
		"- Splines Murs Balcon",
		"- Splines Murs Fond",
		"- Splines Murs Int")
	
	theZ = [0,0,1]
	impact = false
	
	posI = (getKnotPoint l 1 id) - [0,0,500]
	testRay = (ray posI theZ)
	intersectTestI = intersectRayScene testRay
	format "intersectTestI: %\n" intersectTestI
	if intersectTestI.count > 0 then 
	(
		-- blinder le test des murs
-- 		format "intersectTestI: %\n" intersectTestI[1][1].layer.name
		res = finditem layerList intersectTestI[1][1].layer.name
-- 		format "res: %\n" res
		if res > 0 then impact = true 
	)
		
	impact
)
testImpactID $ 4


-- si un repère est dans un mur retourne un nouvel ordre des points du repère
fn collectNewOrder s =
(
	newOrder = #(0,0,0,0)
	for i = 1 to (numKnots s) do 
	(
		local order
		local h, j
		local resH, resI, resJ
		
		if i == 4 then h = 1 else h = ( i + 1)
		if i == 1 then j = 4 else j = (i - 1)
	-- 		
		resH = testImpactID s h
		resI = testImpactID s i
		resJ = testImpactID s j
	-- 	
-- 		format "resH:% resI:% resJ:%\n"  resH resI resJ
		if resH and resI and not resJ then order = 2
		else if not resH and resI and resJ then order = 1
		else if not resH and not resI and resJ then order = 4
		else if resH and not resI and not resJ then order = 3
		else (order = 0)

	-- 		
		-- debug: verifier que les coordonnées du point sont dans le systeme local de la spline ou du mone à la creation
		--  la creation des points se fait dans le coordsys world
		if order > 0 then newOrder[order] = (getKnotPoint s 1 i) else
		(
-- 			format "i fail= %\n" i
		)
	)
	format "s: % newOrder: %\n" s.name newOrder 
	newOrder
)


-- retourne le mur dans lequel se trouve un repère
	-- fonctionne à partir du premier point du repère calculer (newOrder[1])
fn getMurImpacted rayStart =
(
	layerList = #("- Splines Murs Ext", 
	"- Splines Murs Balcon",
	"- Splines Murs Fond",
	"- Splines Murs Int")
	
	local theMur
	theZ = [0,0,1]
	posI = rayStart - [0,0,500]
	
	testRay = (ray posI theZ)
	intersectTestI = intersectRayScene testRay
	format "intersectTestI: %\n" intersectTestI
	if intersectTestI.count > 0 then
	(
-- 		format "layer name: %\n" intersectTestI[1][1].layer.name		
		res = finditem layerList intersectTestI[1][1].layer.name
-- 		format "res: %\n" res
		if res > 0 then theMur = intersectTestI[1][1]
	)
	
	theMur
)

-- var
-- s = $

fn adjustGabaritSpline s shift1: 3 shift2: 3 =
(
	converttosplineshape s

	theX
	theY
	theZ = [0,0,1]

	local oneMur 
	local murTM2
	local rayOrient 
	local impactAr = #()

	-- ################ calcul de la bonne orientation par rapport au mur
	local newOrder = collectNewOrder s

	if not newOrder[1] == 0 then
	(
		-- determination de Y
		theY = newOrder[2] -  newOrder[1]

		-- determination de X
		theX = cross   (normalize theY)  theZ 
		-- murTM  =  (matrix3 theX (normalize theY) theZ copyS.pos)

		-- donner l'orientation à une copy de la spline 
		murTM2  =  (matrix3 theX (normalize theY) theZ s.pos)
		
		-- orientation du repère par rapport au mur
		rayOrient = murTM2.row1
		
		-- retrouver le mur impacter par le repere
		oneMur = getMurImpacted  newOrder[1]
	)
	else(format "essayer de décaler le repère: %\n" s.name)

	-- liste des rayon à tester sur le mur
		-- de k1 selon x
	if oneMur != undefined then
	(

		-- de k2 selon x
		testRay1 = (ray (newOrder[1] + [- 50, - 50, - 50] * rayOrient) rayOrient)
		impact1 = intersectRay oneMur testRay1
		
		-- de k2 selon x
		testRay2 = (ray (newOrder[2] + [- 50, - 50, - 50] * rayOrient) rayOrient)
		impact2 = intersectRay oneMur testRay2
		
		-- de k3 selon - x
		testRay3 = (ray newOrder[3] -rayOrient)
		impact3 = intersectRay oneMur testRay3
		
		-- de k4 selon - x
		testRay4 = (ray newOrder[4] -rayOrient)
		impact4 = intersectRay oneMur testRay4
		
		tripleShift1 = [shift1, shift1, shift1] * -rayOrient
		tripleShift2 = [shift2, shift2, shift2] * rayOrient
		
		if impact1 == undefined or   impact2 == undefined or  impact3 == undefined or  impact4 == undefined then
		(
			format "pas assez d'impact sur le mur\n"
		)
		else
		(
			impactAr = #((impact1.pos + tripleShift1), (impact2.pos + tripleShift1), (impact3.pos + tripleShift2), (impact4.pos + tripleShift2))
		)
		
	)else(format "pas de mur!\n")
	
	if impactAr.count == 4 and not oneMur == undefined then
	(
		-- copie du repère
-- 		copyS = copy s
-- 		copyS.wirecolor = s.wirecolor
-- 		s.layer.Addnode copyS
		
		-- application du transform
-- 		copyS.transform = murTM2
		s.transform = murTM2

		-- appliquer les impact à la position de la spline
		for i = 1 to (numKnots s) do
		(
-- 			setKnotPoint copys 1 i impactAr[i]
-- 			setKnotType  copys  1 i #corner
			setKnotPoint s 1 i impactAr[i]
			setKnotType  s  1 i #corner
		)
		updateShape s
	)
	else(format "quelque chose a foiré\n")

)

try(destroydialog adjustGabaritRLT)catch()
rollout adjustGabaritRLT "Ajuster les gabarit de porte et fenêtre"
(
	spinner shift1SP "decalage -x:" type: #worldunits range: [0,500, 3] across: 2
	spinner shift2SP "decalage +x:" type: #worldunits range: [0,500, 30]
	button adjustBT "ajuster les gabarits selectionnés"
	
	on adjustBT pressed do
	(
		sel  = selection as array
		
		for s in sel do
		(
			copyS = copy s
			copyS.wirecolor = s.wirecolor
			s.layer.Addnode copyS
			adjustGabaritSpline copyS shift1: shift1SP.value shift2: shift2SP.value
			 
		)
-- 		select sel
	)
)


createdialog adjustGabaritRLT width: 300

