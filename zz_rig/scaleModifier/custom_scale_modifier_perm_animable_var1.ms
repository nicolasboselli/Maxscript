--Amelioration:
-- synchroniser les clefs d'animation du modificateur avec les clefs de l'objet à la création et pendant l'animation

--création d'un modifier vide

modPanel.addModToSelection (emptymodifier ()) ui:on
(

-- definition des custom attributes

	def = attributes scale_xyz
	(
	parameters main rollout:test
		(
			parmValue type:#float ui:(mySpinner)
			s type:#node subanim: true
		)

	rollout test "Scale" 
		(

			spinner mySpinner "scale xyz"  range: [0,100,10]

			
			
			on mySpinner changed val do 
			(
					scale.x = val/10
					scale.y = val/10
					scale.z = val/10
			)
		)
		
	)
	

)
-- ajout des parametres au modifier vide
custAttributes.add $.modifiers[#'Attribute Holder'] def

--ajout des parametres au panel de l'objet
--custAttributes.add $. def

---------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------
