   try (destroyDialog roll_Test) catch ()
    
    rollout roll_Test "Test" width:370 height:210
    (
    	dotNetControl myDGV "System.Windows.Forms.DataGridView"
    	
    	on roll_Test open do
    	(
    		local myCol1 = dotNetObject "System.Windows.Forms.DataGridViewTextBoxColumn"
    		myCol1.headerText = "Col1"
    		myCol1.width = 100
    		
    		local myCol2 = dotNetObject "System.Windows.Forms.DataGridViewTextBoxColumn"
    		myCol2.headerText = "Col2"
    		myCol2.width = 100
    		
    		local myCol3 = dotNetObject "System.Windows.Forms.DataGridViewTextBoxColumn"
    		myCol3.headerText = "Col3"
    		myCol3.width = 100
    		
    		myDGV.columns.add myCol1
    		myDGV.columns.add myCol2
    		myDGV.columns.add myCol3
    		
    		myDGV.width = 343
    		myDGV.height = 200
    		
    		for i=0 to 4 do
    		(
    			myDGV.rows.add ()
    			myDGV.rows.item [i].cells.item [0].value = "Pleaaaaseee"
    			myDGV.rows.item [i].cells.item [1].value = "hellllllppppp"
    			myDGV.rows.item [i].cells.item [2].value = "meeeeee!!!"
    		)
    	) -- on open
    	
    	on myDGV click s e do
    	(
    		if e.button == e.button.left then format "Great, you press the LMB! ...at pos: %\n" [e.x,  e.y]
    		if e.button == e.button.middle then format "Excellent, you pressed the MMB! ...at pos: %\n" [e.x,  e.y]
    		if e.button == e.button.right then format "Yahooooo, you pressed the RMB! ...at pos: %\n" [e.x,  e.y]
    	) -- on click
    )
    
    createDialog roll_Test
    clearListener ()