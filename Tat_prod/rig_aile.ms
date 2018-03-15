
-- switch plume
plumeFlexAr  = #( $P_CacatoesKiki_G_Dep_Plume_016_RIG, 
$P_CacatoesKiki_G_Dep_Plume_015_RIG,
$P_CacatoesKiki_G_Dep_Plume_014_RIG,
$P_CacatoesKiki_G_Dep_Plume_013_RIG,
$P_CacatoesKiki_G_Flex_Plume_Flex_013_RIG,
$P_CacatoesKiki_G_Flex_Plume_Flex_014_RIG,
$P_CacatoesKiki_G_Flex_Plume_Flex_015_RIG,
$P_CacatoesKiki_G_Flex_Plume_Flex_016_RIG)

plumeFlexAr  = #( $P_CacatoesKiki_D_Dep_Plume_012_RIG,
$P_CacatoesKiki_D_Dep_Plume_016_RIG, 
$P_CacatoesKiki_D_Dep_Plume_015_RIG,
$P_CacatoesKiki_D_Dep_Plume_014_RIG,
$P_CacatoesKiki_D_Dep_Plume_013_RIG,
$P_CacatoesKiki_D_Flex_Plume_Flex_012_RIG,
$P_CacatoesKiki_D_Flex_Plume_Flex_013_RIG,
$P_CacatoesKiki_D_Flex_Plume_Flex_014_RIG,
$P_CacatoesKiki_D_Flex_Plume_Flex_015_RIG,
$P_CacatoesKiki_D_Flex_Plume_Flex_016_RIG)

-- doigts: 8 helpers x 2 cote x 2 poids
--  amorti ailes: 2 box x 2 cote x 2 poids

h = plumeFlexAr[8]
select h

-- active euler
for h in plumeFlexAr do
(
-- 	if classof h.rotation.controller != lookat_constraint do select h
-- 	format "%: %\n" h.name h.rotation.controller
	if  classof h.rotation.controller[1].controller == Euler_XYZ do
	(
		print "yo"
		h.controller.rotation.controller.active = 1
		h.rotation.controller.weight[1] = 100
		h.rotation.controller.weight[2] = 0
	)
	
	if  classof h.rotation.controller[2].controller == Euler_XYZ do
	(
		print "ya"
		h.controller.rotation.controller.active = 2
		h.rotation.controller.weight[1] = 0
		h.rotation.controller.weight[2] = 100
	)
)

-- active lookat


-- delivrer plume
	-- nettoyage des départs de plumes
	-- collecter les départs de plume
	depPlumAr = #()
	hlpsAr = helpers as array
	for h in hlpsAr do
	(
		res = findString h.name "_Dep_Plume_"
		if res != undefined then
		(
			append depPlumAr h
		)
	)
	select depPlumAr
	
-- trouver les flex
plumFlexAr = #()
hlpsAr = helpers as array
for h in hlpsAr do
(
	res = findString h.name "_Plume_Flex_"
	if res != undefined then
	(
		h.cross = on
		h.Box = on
		append plumFlexAr h
	)
)
select plumFlexAr


	-- enlever le follow sur le path constraint de depart de plume
for s in depPlumAr do
(
	try
	(
		
		s.pos.controller.Path_Constraint.controller.follow = off
		-- retablir le scale apres le quit follow
			-- retablir le scale à 1
		s.scale = [1,1,1]
	)
	catch()
)
	

	--	reparent depart de plume au bone de la main
-- for p in depPlumAr do
-- (
-- 	resNum = findString h.name "_"
-- 	resSide = findString h.name "_G_"
-- 	print p.name
-- )	


	-- parenter au plan du poignet
	
-- creation des controller rotation_list
for p in depPlumAr do
(
	-- ajouter rotationlist sur lookat depart plume
	p.rotation.controller = rotation_list ()
	-- mettre euler_xyz au dessus du lookat
	p.rotation.controller.available.controller = euler_xyz ()
	p.rotation.controller.cut 1
	p.rotation.controller.paste 2
)


	-- scripter le controle du poids de la contrainte lookat des départ de plume et des flex
	plumeFlexAr[2].rotation.controller.weights[2].controller = copy plumeFlexAr[1].rotation.controller.weights[2].controller

	-- realigner depart de plume
	in coordsys world $.rotation as eulerangles
	
	-- parentflex directement au premier bone de chaque doigts?

-- rig bras/moignon
	-- séparer la mesh
	-- injecter un moignon skinné
	-- injecter un moignon deformé