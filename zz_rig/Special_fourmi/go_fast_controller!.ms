-- selection du controleur spline
s = $
converttosplineshape s
updateshape s

-- conservation de l'animation a travers une copy
s_copy = copy s

--renommage
s_copy.name =  s.name
s.name = s.name + "_sub"

s_copy.wirecolor = s.wirecolor
s.wirecolor = color 115 115 115


s_children = s.children
s_children.parent = s_copy

s.parent = world

-- creation du substitut au controleur spline original
transfert = circle radius: 1 rotation: s.rotation position: s.pos
converttosplineshape transfert
updateshape transfert

-- fusion du controleur et du substitut
addAndWeld s transfert  0

num = numSplines s
for i = 1 to ( num - 1) do 
(
deleteSpline s 1
updateshape s
)



-- contrainte de position du substitut au nouveau controleur 
s.pos.controller = position_xyz ()
s.pos.controller = position_script ()

s.position.controller.AddNode "node" (s_copy)
s.position.controller.script = "node.position"

-- contrainte de rotation du substitut au nouveau controleur 
s.rotation.controller = Euler_xyz ()
s.rotation.controller = rotation_script ()
s.rotation.controller.AddNode "node" (s_copy)

rot_script = stringstream ""
format "w = 1*node.rotation.w
x = -1*(node.rotation.x)
y = -1*(node.rotation.y)
z = -1*(node.rotation.z)

(quat x y z w)" to: rot_script
close rot_script
s.rotation.controller.script = rot_script as string

s = $

num = numSplines s
for i = 1 to ( num - 1) do 
(
deleteSpline s 1
updateshape s
)
