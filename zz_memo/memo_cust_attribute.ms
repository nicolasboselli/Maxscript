

CamPdvStack = attributes CamPdvStackAT 
(
	local test = #()
	local TestListName = #()
	
	parameters TestPRM rollout: testRLT
	(
		TestList type: #nodetab  tabSizeVariable: true 
	)
	
	rollout TestRLT "test"
	(
-- 		vars
		
		
		listbox listboxLB "listbox"
		button refresh "refresh" 
		button addSel "addsel"
		
		on refresh pressed do
		(
			print TestList
			TestListName = for o in TestList collect o.name
			listboxLB.items = TestListName
		)
		
		on addSel pressed do
		(
			append TestList $
		)
	)
)

custAttributes.add $ CamPdvStack


/*
custAttributes.getdefdata (custAttributes.getdef $ 1) 

custAttributes.setDefData (custAttributes.getdef $ 1) #(1,2,3)
custAttributes.setDefData (custAttributes.getdef $ 1)  $.name
showproperties $[8]

custAttributes.delete $ 1

custAttributes.getdefs $


showproperties test

setuserprop $ "test" #(1,2,3)

showproperties $
execute (getuserprop $ "test") 

$.custom_attributes[1] = 50

*/