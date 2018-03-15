--Amelioration:
-- synchroniser les clefs d'animation du modificateur avec les clefs de l'objet à la création et pendant l'animation

--création d'un modifier vide


-- definition des custom attributes

	def = attributes scale_xyz
	(

	rollout scaleCharRLT "Scale" 
		(

			spinner mySpinner "scale xyz"  range: [0,1000,100]
			button resetBT "R"

			on scaleCharRLT open do
			(
				print ($.scale.x * 100)
				mySpinner.value = ($.scale.x * 100)
			)
			
			on mySpinner changed val do 
			(
				$.scale.x = val/100
				$.scale.y = val/100
				$.scale.z = val/100
			)
			
			on resetBT pressed do
			(
				$.scale = [1,1,1]
				mySpinner.value = 100
			)
			
		)
		
	)
	


-- ajout des parametres au modifier vide

scaleCharMod = emptymodifier name: "scale character"
custAttributes.add scaleCharMod def
	
modPanel.addModToSelection scaleCharMod ui:on
-- custAttributes.add $.modifiers[#'Attribute Holder'] def

--ajout des parametres au panel de l'objet
--custAttributes.add $. def

---------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------
