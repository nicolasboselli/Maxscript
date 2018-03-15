rollout unnamedRollout "Untitled" width:200 height:350
(
	listBox lbx1 "ListBox" pos:[10,10] width:100 height:5 items: #()
	dropDownList ddl1 "DropDownList" pos:[10,100] width:78 height:5
	comboBox cbx1 "ComboBox" pos:[10,200] width:104 height:5
	pickButton btn5 "Select ref" pos:[10,300] width:170 height:30
	
	on btn5 picked obj do
	(
		lbx1.items = append lbx1.items	(obj.name as string)
	)

)

createdialog unnamedRollout
