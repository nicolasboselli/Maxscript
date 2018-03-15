--création d'un modifier vide
modPanel.addModToSelection (emptymodifier ()) ui:on

-- definition des custom attributes
def = attributes boton
(
	-- definition de paramètres
	parameters main rollout:test
	(
	)
	-- definition de l'interface
	rollout test "Untitled" 
	(
		button btn2 "Button"  width:90 height:52
		on btn2 pressed do print "ahah!"
	)
	
)
	
-- ajout des parametres au modifier vide
custAttributes.add $.modifiers[#'Attribute Holder'] def

--ajout des parametres au panel de l'objet
custAttributes.add $ def

---------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------

--Start script
myAttrib = attributes myFirstScriptedAtrib
(
	parameters params rollout:myRollout
	(
		parmValue type:#float ui:(mySpinner)
	)
	rollout myRollout "This is a Rollout"
	(
		spinner mySpinner "Spin test:"
-- 		slider mySlider "My Control"
	)
)
custAttributes.add $ myAttrib
--End script

paramWire.connect $.baseObject.myFirstScriptedAtrib[#parmValue] $.baseObject[#Length] "parmValue"
custAttributes.delete $ myAttrib

$.baseObject.myFirstScriptedAtrib[#parmValue].controller.numWires

$.baseObject.length.controller.slaveAnimation 
