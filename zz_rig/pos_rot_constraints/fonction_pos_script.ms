fn pos_script_fn p1 p2 = 

(
				
				slave = p1
				master = p2


				-- contrainte de position du substitut au nouveau controleur 
				slave.pos.controller = position_xyz ()
				slave.pos.controller = position_script ()

				slave.position.controller.AddNode "master" (master)
				slave.position.controller.Addnode "slave" (slave)
				
				pos_script = stringstream ""				
format "if slave.parent == undefined then master.position
else
in coordsys slave.parent master.position" to: pos_script
				close pos_script
				slave.position.controller.script = pos_script as string

)

/*
s = $ as array
pos_script_fn s[1] s[2]
*/
