fn pos_rot_script a1 a2 = 

(
				
				slave = a1
				master = a2


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

				-- contrainte de rotation du substitut au nouveau controleur 
				slave.rotation.controller = Euler_xyz ()
				slave.rotation.controller = rotation_script ()
				
				slave.rotation.controller.AddNode "master" (master)
				slave.rotation.controller.AddNode "slave" (slave)
				
				rot_script = stringstream ""
format " if slave.parent == undefined then 
(
w = master.rotation.w
x = -1*(master.rotation.x)
y = -1*(master.rotation.y)
z = -1*(master.rotation.z)
(quat x y z w)
)
else
(
w = in coordsys slave.parent master.rotation.w
x = -1*(in coordsys slave.parent master.rotation.x)
y = -1*(in coordsys slave.parent master.rotation.y)
z = -1*(in coordsys slave.parent master.rotation.z)
(quat x y z w)
) " to: rot_script
				close rot_script
				slave.rotation.controller.script = rot_script as string
-- si l'esclave a un parent
)
/*
s = $ as array
pos_rot_script s[1] s[2]
*/