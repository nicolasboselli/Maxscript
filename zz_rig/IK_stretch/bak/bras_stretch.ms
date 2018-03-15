-- taille bras maxi 
taille_bras_stretch = distance $point003 $point002

-- taille os biceps
taille_biceps = $Bone002.transform.controller.FK_sub_control.controller.position.controller.x_position.controller.bezier_float.controller

--taille os avant bras
taille_av_bras = $Bone003.transform.controller.FK_sub_control.controller.position.controller.x_position.controller.bezier_float.controller

--taille bras fixe
taille_bras_fix = taille_biceps.value + taille_av_bras.value

-- rapport bras fixe/bras elastique
coef = taille_bras_stretch/taille_bras_fix

--taille os biceps étiré
taille_biceps*coef

--taille avant bras étiré
taille_av_bras*coef

-- condition à l'étirement
if taille_bras_stretch > taille_bras_fix then 
	taille_biceps*coef
else
	taille_biceps 