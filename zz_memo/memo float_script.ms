sujet = $point007
objet = $point006

sujet.pos.controller.y_position.controller = bezier_float ()
sujet.pos.controller.y_position.controller = float_script ()
sujet.pos.controller.y_position.controller.addconstant "test" (objet.pos.controller.y_position.controller)
sujet.pos.controller.y_position.controller.script = "test.value"
sujet.pos.controller.y_position.controller.addconstant "test2" (test.value)

sujet.pos.controller.y_position.controller.getValue "test"


