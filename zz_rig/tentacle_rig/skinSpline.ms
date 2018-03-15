fn skinSpline ligne =
(
-- 	ligne = $
	-- recuperation des numeros de knots important
	local knotsCount = numKnots ligne

	local helpAr = #()
	-- create controls on knots
	for i = 1 to knotsCount do
	(
		newPos = getKnotPoint ligne 1 i
		format "point % : % \n" i newpos
		newHlp = point rotation: ligne.rotation pos: newPos cross: false box: true axis_tripod: true size: 10
		append helpAr newHlp
	)

	select helpAr
	-- add skin on spline 
	select ligne
	modPanel.addModToSelection (skin()) ui:on
		
	-- add control on skin
	for i = 1 to helpAr.count  do
	(
		if i == helpAr.count then	skinOps.addbone ligne.skin helpAr[i] 0
		else skinOps.addbone ligne.skin helpAr[i] -1
	)
	
	helpAr
)

skinSpline $