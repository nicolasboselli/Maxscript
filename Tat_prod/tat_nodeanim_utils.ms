-- edit tat node
showproperties $.modifiers["selset_setup"]
$.modifiers["selset_setup"].nodes
$.modifiers["selset_setup"].names
$.modifiers["selset_setup"].index
$.modifiers["selset_setup"].sizes

$.baseobject.m_virtualParent
$.baseobject.m_isHidden

showproperties  $.baseobject

showproperties $.modifiers["selset_anim"]
$.modifiers["selset_anim"].nodes
$.modifiers["selset_anim"].names
$.modifiers["selset_anim"].index
$.modifiers["selset_anim"].sizes

-- 
tg.nodes = #()
tg.names = #()
tg.index = #()
tg.sizes = #()

-- tg = sel[2].modifiers["selset_anim"]
tg = $.modifiers["selset_anim"]
tg = $A_ArbreBananier_ANIM.modifiers["selset_anim"]
-- sc.nodes.count
-- for s in sc.nodes do print s

test = $.modifiers["selset_anim"]
for t in test.nodes do print t

tg = $.modifiers["selset_anim"]

sc = $.modifiers["selset_anim"]
for o in sc.nodes do print o

for o in sc.nodes do append tg.nodes o
for n in sc.names do append tg.names (n + suf)
for id in sc.index  do append tg.index (id + jump)
for sz in sc.sizes do append tg.sizes sz



sel = selection as array
tg = sel[sel.count].modifiers["selset_anim"]

for i = 1 to  (sel.count - 1) do
(
	sc = sel[i].modifiers["selset_anim"]

	-- ajout nodes
	jump = tg.nodes.count
	-- lettre = "H"
	lettre = sel[i].name
	suf = "_feuille" + "_" + lettre
	suf = ""

	-- append array
	for o in sc.nodes do append tg.nodes o
	-- ajout names
	for n in sc.names do append tg.names (n + suf)
	-- append array
	-- ajout index

	-- append array
	for id in sc.index  do append tg.index (id + jump)
	-- mise à jour des index avec la taille de l'array node précédent
	-- ajout sizes
	-- append array
	for sz in sc.sizes do append tg.sizes sz
)




tg.nodes 
tg.names 
tg.index 
tg.sizes 



	