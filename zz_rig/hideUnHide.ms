hlps = helpers as array

for h in hlps do hide h
	
for h in hlps do unhide h

sel = selection as array

for s in sel do s.wirecolor = orange 
	
sel = objects as array

for s in sel do
(
	try(print s.material)catch()
)

sel = selection as array

for s in sel do s.wirecolor = red 
	
sin(90)

