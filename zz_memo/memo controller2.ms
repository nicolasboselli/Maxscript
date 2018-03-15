--appliquer un controller 3 points
$point006.pos.controller.pos1.controller = point3_script ()

--valeur d'un controller
$point006.position.controller.position_script.controller.value


pt6_p1 = $point006.pos.controller.pos1.controller
pt6_p2 = $point006.pos.controller.pos2.controller

pt6_p1 = point3_script ()

pt6_p1.value
pt6_p2.value

-- appeler un controller de poids
pt6_pw1 = $point006.pos.controller.weight[1].controller
pt6_pw2 = $point006.pos.controller.weight[2].controller

pt6_pw1.value
pt6_pw2.value

--assigner des controllers script et écrire dedans
sujet = $
sujet.position.controller = position_xyz ()
sujet.position.controller = position_list ()
sujet.position.controller.available.controller = position_script ()
sujet.position.controller.setname 1 "tata"
sujet.position.controller.setname 2 "toto"
z = "["
w = ","
v = "]"
a = "10"
b = "20"
c = "30"
sujet.position.controller.toto.controller.script = z+a+w+b+w+c+v
sujet.position.controller.setactive 2