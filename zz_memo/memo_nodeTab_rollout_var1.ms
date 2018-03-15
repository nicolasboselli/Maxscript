s = point () 
s.name = (uniquename "pose_supervisor_")
select s

-- modPanel.addModToSelection (emptymodifier ()) ui:on	

supervisor_track = attributes supervisor_node
(
	parameters main
	(
		stack_node type:#nodetab tabSizeVariable:true
	)
)	
-- custAttributes.add s supervisors
custAttributes.add $ supervisor_track
--$.modifiers[#'Attribute Holder'].supervisor.stack_node
/*
supervisor_track = undefined
s = undefined
nodeTab = undefined
*/
/*
------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------
s = undefined
nodeTab = undefined
(
					local s = $
					local nodeTab = s.supervisor_node.stack_node
					(
						rollout supervisor ($.name as string)
						(		
						
						button refresh "refresh list"
						listBox node_list "poses" height:5 items: #()
						pickButton add_node "add node" 
						button select_node "select node"
						button delete_node "delete node"
						

						
						--on refresh pressed do print nodeTab
						
						on add_node picked obj do
							(
								if obj != undefined do
								(
									append  nodeTab obj
									node_list.items = for i = 1 to nodeTab.count collect nodeTab[i].name
								)
							)
						
						on refresh pressed do
							(
								node_list.items = for i = 1 to nodeTab.count collect nodeTab[i].name
							)
						
						on delete_node pressed do
							(
								nb = node_list.selection
								print nb
								deleteitem nodeTab 1
								node_list.items = for i = 1 to nodeTab.count collect nodeTab[i].name
								--deleteitem collection nb
							)
						
						on select_node pressed do
							(
								nb = node_list.selection
								select nodeTab[nb]
							)
							
						)
					)
					
			
				)

------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------
*/

supervisor_iu = undefined
supervisor = undefined
nodeTab = undefined
				
supervisor_iu = attributes pose_supervisor
(
	
		parameters main
	(
		stack_node type:#nodetab tabSizeVariable:true
	)
	
	rollout open_supervisor_rollout "open supervisor"
	(
		button open_supervisor "open supervisor"
		
		on open_supervisor pressed do 
		(
			if $ != undefined do
			(
				--createdialog supervisor
				(
					
					
						rollout supervisor ($.name as string)
						(		
						
						button refresh "refresh list"
						listBox node_list "poses" height:5 items: #()
						pickButton add_node "add node" 
						button select_node "select node"
						button delete_node "delete node"
						
						local s = $
						--local nodeTab = s.supervisor_node.stack_node
						local nodeTab = stack_node
						
						--on refresh pressed do print nodeTab
						
						on add_node picked obj do
							(
								if obj != undefined do
								(
									append  nodeTab obj
									node_list.items = for i = 1 to nodeTab.count collect nodeTab[i].name
								)
							)
						
						on refresh pressed do
							(
								node_list.items = for i = 1 to nodeTab.count collect nodeTab[i].name
							)
						
						on delete_node pressed do
							(
								nb = node_list.selection
								print nb
								deleteitem nodeTab 1
								node_list.items = for i = 1 to nodeTab.count collect nodeTab[i].name
								--deleteitem collection nb
							)
						
						on select_node pressed do
							(
								nb = node_list.selection
								select nodeTab[nb]
							)
							
						)
					createdialog supervisor
					
			
				)
			)
		)
	)
)
custAttributes.add $ supervisor_iu


/*
$[4]
$.supervisor_node.stack_node
custAttributes.delete $ open_supervisor
*/
/*




.source
*/