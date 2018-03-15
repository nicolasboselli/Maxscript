try(destroydialog testRLT)catch()
rollout testRLT "test"
(
	local menuRC
	
	fn createMenu = 
	(
		rcmenu menuRC
		(
			menuItem testItem "Test item" 
			
			on testItem picked do (print "youpi")
		)
	)
	
	checkbutton CheckOneCB "check one"  highlightColor: green
	checkbutton ChecTwoCB "check two"  highlightColor: blue --  border: false
	
	on CheckOneCB rightclick  do
	(
		popUpMenu menuRC rollout: testRLT
	)
	
	on testRLT open do createMenu()
)
createdialog testRLT

