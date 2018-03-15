s = point () 
s.name = (uniquename "pose_supervisor_")
select s

-- modPanel.addModToSelection (emptymodifier ()) ui:on	

supervisor_track = attributes supervisor_node
(
	parameters main rollout: open_supervisor
	(
		stack_node type:#nodetab tabSizeVariable:true
	)

	rollout open_supervisor "open supervisor"
	(
		button open_sup "open supervisor"
		
		
		
		on open_sup pressed do 
		(
			rollout supervisor_rollout "supervisor"
			(

					button refresh "refresh list"
					listBox node_list "poses" height:5 items: #()
					pickButton add_node "add node" 
					button select_node "select node"
					button delete_node "delete node"
					
					-- local s = $pose_supervisor_001
					 --local nodeTab = s.supervisor_node.stack_node
					
					--on refresh pressed do print nodeTab
					
					on add_node picked obj do
						(
							if obj != undefined do
							(
								append  stack_node obj
								node_list.items = for i = 1 to stack_node.count collect stack_node[i].name
							)
						)
					
					on refresh pressed do
						(
							node_list.items = for i = 1 to stack_node.count collect stack_node[i].name
						)
					
					on delete_node pressed do
						(
							nb = node_list.selection
							print nb
							deleteitem stack_node 1
							node_list.items = for i = 1 to stack_node.count collect stack_node[i].name
							--deleteitem collection nb
						)
					
					on select_node pressed do
						(
							nb = node_list.selection
							select stack_node[nb]
						)
						
			)
			createdialog supervisor_rollout
		)
	)
)

custAttributes.add $ supervisor_track


--createdialog supervisor_rollout

/*
$[4]
$.supervisor_node.stack_node
custAttributes.delete $ open_supervisor
*/
/*




.source
*/