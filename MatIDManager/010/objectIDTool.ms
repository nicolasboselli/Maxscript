



try(destroydialog gbufferChannel0RLT)catch()
rollout gbufferChannel0RLT "Visiolab Objects ID Tool"
(
-- 	$.gbufferChannel = 0
	button id0bt "0 none" width: 100  across: 3 
	button id2bt "2 Vitres" width: 100
	button id4bt "4 Menu"  width: 100
	button id6bt "6 Cloture" width: 100 across: 3 
	button id8bt "8 GC" width: 100
	button id10bt "10 Haies" width: 100
	button id45bt "45 Habillage" width: 100 across: 3 
	button id50bt "50 Herbe" width: 100
	button id55bt "55 arbres" width: 100
	
	on id0bt pressed do
	(
		sel = selection as Array
		for s in sel do s.gbufferChannel = 0
	)
	
	on id2bt pressed do
	(
		sel = selection as Array
		for s in sel do s.gbufferChannel = 2
	)
	
	on id4bt pressed do
	(
		sel = selection as Array
		for s in sel do s.gbufferChannel = 4
	)
	
	on id6bt pressed do
	(
		sel = selection as Array
		for s in sel do s.gbufferChannel = 6
	)
	
		on id8bt pressed do
	(
		sel = selection as Array
		for s in sel do s.gbufferChannel = 8
	)
	
		on id10bt pressed do
	(
		sel = selection as Array
		for s in sel do s.gbufferChannel = 10
	)
	
	on id45bt pressed do
	(
		sel = selection as Array
		for s in sel do s.gbufferChannel = 45
	)
	
	on id50bt pressed do
	(
		sel = selection as Array
		for s in sel do s.gbufferChannel = 50
	)
	
	on id55bt pressed do
	(
		sel = selection as Array
		for s in sel do 
		(
			s.gbufferChannel = 55
			s.renderByLayer = true
		)
	)
	
)
-- createdialog gbufferChannelRLT