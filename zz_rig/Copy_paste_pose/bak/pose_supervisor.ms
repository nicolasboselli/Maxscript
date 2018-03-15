s = point () 
s.name = (uniquename "pose supervisor ")
select s
modPanel.addModToSelection (emptymodifier ()) ui:on
	
open_supervisor = attributes open_supervisor	
(
	parameters main rollout: open_supervisor
	(
	)
	
	rollout open_supervisor "open supervisor"
	(
		button open_supervisor "open supervisor"
		
		on open_supervisor pressed do
		(
			rollout supervisor (s.name as string)
			(
				pickButton Ref_Select "Ref Selection" pos:[10,10] width:120 height:20
				button copy_pose "Copy Pose" pos:[10,50] width:120 height:20
				listBox lbx1 "poses" pos:[10,100] width:120 height:5 items: #()

				button select_ref "Select Ref" pos:[10,200] width:55 height:30
				button select_set "Select Set" pos:[70 ,200] width:55 height:30
					
				button delete_pose "Delete pose" pos:[10,250] width:50 height:30	
				button paste_pose "Paste Pose" pos:[10,310] width:120 height:30
			)
			createdialog supervisor
		)
	)
)
custAttributes.add $.modifiers[#'Attribute Holder'] open_supervisor