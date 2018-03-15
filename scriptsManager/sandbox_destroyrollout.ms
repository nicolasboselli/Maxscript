rollout miniRLT "mini"
(
	local test
	
	edittext testET "var:"
	button autoDestructionBT "petit suicide"
	
	on autoDestructionBT pressed do
	(
		destroydialog miniRLT
	)
	
	on testET changed val do
	(
		test = val
	)
)


try(destroydialog mainRLT)catch()
rollout mainRLT "main"
(
	button miniBT "mini rollout"
	
	on miniBT pressed do
	(
		createdialog miniRLT modal: true
		format "%\n" miniRLT.test
	)
)
createdialog mainRLT