for s in $* do
(
	if classof s == LinkComposite then selectmore s
)

for s in $* where classof s.parent ==  LinkComposite do 
(
	s.parent = undefined
-- 	selectmore s
)
	
for s in selection do s.parent = undefined

o =  getnodebyname "Fenêtres <2 Vantaux - Imposte basse : 1.50m x 2.25m> Tapées"
select o