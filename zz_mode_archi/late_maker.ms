delete lattes
s = $Box252

lattes = for i = 1 to 100 collect copy s

pas = 0
for o in lattes do 
(
	o.wirecolor = s.wirecolor
	pas = pas + (random 30 10)
	in coordsys local move o [pas,0,0]
	o.width = (random 5 15)
)

select lattes
