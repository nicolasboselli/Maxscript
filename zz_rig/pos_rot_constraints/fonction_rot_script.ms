fn rot_script_fn r1 r2 = 

(
				
				slave = r1
				master = r2

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
rot_script_fn s[1] s[2]
*/