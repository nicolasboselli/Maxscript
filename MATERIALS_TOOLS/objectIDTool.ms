



try(destroydialog gbufferChannelRLT)catch()
rollout gbufferChannelRLT "G buffer Objetc ID Tools"
(
-- 	$.gbufferChannel = 0
	button id0bt "0 none"  
	button id2bt "2 Vitres" 
	button id4bt "4 Menu" 
	button id6bt "6 Cloture" 
	button id8bt "8 GC" 
	button id10bt "10 Haies" 
	button id45bt "45 Habillage" 
	button id50bt "50 Herbe" 
	button id55bt "55 arbres"
	
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
createdialog gbufferChannelRLT