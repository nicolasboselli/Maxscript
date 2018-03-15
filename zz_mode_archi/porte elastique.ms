/*
$.pos.controller.x_position.controller = bezier_float ()
$.pos.controller.x_position.controller = float_script ()

$.pos.controller.y_position.controller = bezier_float ()
$.pos.controller.y_position.controller = float_script ()



$.pos.controller.x_position.controller.addnode "red_driver" red_driver
$.pos.controller.x_position.controller.addnode "blue_driver" blue_driver

$.pos.controller.y_position.controller.addnode "red_driver" red_driver
$.pos.controller.y_position.controller.addnode "blue_driver" blue_driver
*/
root = $Point098
red_driver = $Point097
blue_driver = $Point099

hlp_skin = for i = 1 to 4 collect point name:("hlp_skin_" + i as string)
for o in hlp_skin do 
(
o.parent = root
o.wirecolor = color 27 177 27
	)

/*
delete hlp_skin
select hlp_skin
select hlp_skin[1]
*/

for o in hlp_skin do 
(
o.pos.controller.x_position.controller = bezier_float ()
o.pos.controller.x_position.controller = float_script ()

o.pos.controller.y_position.controller = bezier_float ()
o.pos.controller.y_position.controller = float_script ()
	
o.pos.controller.x_position.controller.addnode "red_driver" red_driver
o.pos.controller.x_position.controller.addnode "blue_driver" blue_driver

o.pos.controller.y_position.controller.addnode "red_driver" red_driver
o.pos.controller.y_position.controller.addnode "blue_driver" blue_driver
)


hlp_skin[1].pos.controller.x_position.controller.script = "in coordsys parent red_driver.pos.x"
hlp_skin[1].pos.controller.y_position.controller.script = "in coordsys parent blue_driver.pos.y"

hlp_skin[2].pos.controller.x_position.controller.script = "in coordsys parent blue_driver.pos.x"
hlp_skin[2].pos.controller.y_position.controller.script = "in coordsys parent red_driver.pos.y"

hlp_skin[3].pos.controller.x_position.controller.script = "in coordsys parent blue_driver.pos.x"
hlp_skin[3].pos.controller.y_position.controller.script = "in coordsys parent blue_driver.pos.y"

hlp_skin[4].pos.controller.x_position.controller.script = "in coordsys parent red_driver.pos.x"
hlp_skin[4].pos.controller.y_position.controller.script = "in coordsys parent red_driver.pos.y"



