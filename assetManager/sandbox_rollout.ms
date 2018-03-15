try(destroydialog TestRLT)catch()
rollout TestRLT "test"
(
	local testVar -- = "coucou"
)

try(destroydialog TestRLT2)catch()
rollout TestRLT2 "test2"
(
	local testVar2 = "coucou2"
	
	on TestRLT2 open do
	(
		print "youpi"
		createdialog TestRLT
		TestRLT.testVar = testVar2
	)
)
createdialog TestRLT2


TestRLT2.testVar2 = "toto"

TestRLT.testVar
