fn pos_script_fn p1 p2 = 

(
				
				local slave = p1
				local master = p2


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



-- BONES TUNES

os = $ as array

/*
-- creation des spy rot
-- a quoi servent les spy bot ? pour le rig de doigt je crois. il permettent de donner une orientation correcte au controleur spline
bn_spy_rot = for i = 1 to os.count collect
(
point name: (uniquename "bn_spy_rot") rotation:os[i].rotation pos:os[i].position  size: 1 box: false cross: false  axistripod: true
)
for i = 1 to bn_spy_rot.count do bn_spy_rot[i].parent = os[i]
*/
-- creation des hlpers de bones 
bn_tune_hlps = for i = 1 to os.count collect 
(
point name: (uniquename "bn_tune_hlp") rotation: os[i].rotation pos: os[i].pos size: 5 box: false cross: true axistripod: false
)

-- contrainte des bones aux helpers
for i= 1 to os.count do
(
pos_script os[i] bn_tune_hlps[i] 
)

for i= 1 to os.count-1 do
(
os[i].rotation.controller = LookAt_Constraint ()
os[i].rotation.controller.constraints.appendTarget bn_tune_hlps[i+1] 100
os[i].rotation.controller.upnode_world = off
os[i].rotation.controller.pickUpNode = bn_tune_hlps[i]
os[i].rotation.controller.upnode_ctrl = 1
os[i].rotation.controller.viewline_length_abs = off
)


