for m in scenematerials where m.override_effect_id == on do
(
	if  m.effect_id == 2 then
	(
		m.name = "vitrage"
		format "vitrage m:% id:%\n" m m.effect_id
	)
	else if  m.effect_id == 4 then
	(
		m.name = "Huisserie"
		format "huisserie m:% id:%\n" m m.effect_id
	)
	else()
)


-- showproperties scenematerials[1]