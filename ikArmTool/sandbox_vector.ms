
jambeRoot = $P_Loup_D_Cuisse_CTRL001_hlp
jambeTarget = $P_Loup_D_Pied_01_CTRL001
piedCheville = $Box001
piedTalon = $IKChain002_hlpqqq

jambeRoot 
jambeTarget = $P_Loup_D_Pied_01_CTRL001
piedCheville = $Box001
piedTalon = $IKChain002_hlpqqq


v1 = jambeRoot.pos - jambeTarget.pos
v2 = piedTalon.pos - piedCheville.pos 

v3 = v1 + v2

(v3.x^2 +v3.y^2 + v3.z^2 )^0.5



p1 = $point001
p2 = $point002
p3 = $Point003

v1 = p1.pos
v2 = p2.pos - p1.pos
p3.pos = v1 + v2

$.pos.controller[2].controller.z_position