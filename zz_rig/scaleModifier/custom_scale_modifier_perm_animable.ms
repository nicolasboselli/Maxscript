--Amelioration:
-- synchroniser les clefs d'animation du modificateur avec les clefs de l'objet à la création et pendant l'animation

--création d'un modifier vide

modPanel.addModToSelection (emptymodifier ()) ui:on
(
local s = $

custat_perm = stringstream ""
format "-- definition des custom attributes
(
	def = attributes scale_xyz
	(
	parameters main rollout:test
	(
	parmValue type:#float ui:(mySpinner)
	)

	rollout test \"Scale\" 
		(

			spinner mySpinner \"scale xyz\"  range: [0,100,10]

				on mySpinner changed val do 
			(\n	" to: custat_perm
format "$%.scale.x = val/10\n" s.name to: custat_perm
format "$%.scale.y = val/10\n" s.name to: custat_perm
format "$%.scale.z = val/10\n" s.name to: custat_perm
format ")
		)
		
	)
)	" to: custat_perm

close custat_perm

execute (custat_perm as string )
)
-- ajout des parametres au modifier vide
custAttributes.add $.modifiers[#'Attribute Holder'] def

--ajout des parametres au panel de l'objet
--custAttributes.add $. def

---------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------
