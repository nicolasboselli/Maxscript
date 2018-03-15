objs = objects as array

for o in objs where classof o == railclone_pro do
(
	converttopoly o
)

for o in objs where o.modifiers.count > 0 do
(
	for m in o.modifiers where classof m == sweep do converttopoly o
)