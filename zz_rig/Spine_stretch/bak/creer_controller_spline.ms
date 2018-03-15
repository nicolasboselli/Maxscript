cercle = for i= 1 to 3 collect circle ()


rotate cercle[1]  (angleaxis 90 [1,0,0])
rotate cercle[2]  (angleaxis 90 [0,1,0])
rotate cercle[3] (angleaxis 90 [0,0,1])

 for o in cercle do
	(
	select o
	modPanel.addModToSelection (Edit_Spline ()) ui:on
	maxOps.CollapseNodeTo o 1 off
	)

for i = 2 to cercle.count do
addandweld cercle[1] cercle[i] 10

	
test = stringstream ""
format "toto%" (random 1 100) to: test

cercle[1].name = test as string