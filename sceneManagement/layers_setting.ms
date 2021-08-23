/*
travailler avec les scene state?
*/


try(destroydialog layersSettingRLT)catch()
rollout layersSettingRLT "Layers Setting"
(
	listBox setLB "sets:" 
	editText nameET "name:"
	button addSetBT "add" across: 2
	button delSetBT "del"
)
createdialog layersSettingRLT