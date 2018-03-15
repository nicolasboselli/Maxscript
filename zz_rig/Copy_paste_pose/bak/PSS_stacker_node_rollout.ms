macroScript edit_stacker
	category:"aMoi"
	toolTip:""

(
supervisor_rollout = undefined
test2 = undefined
if $ != undefined do


(

	local stack_node = $.supervisor_node.stack_node
			(
				rollout supervisor_rollout ($.name as string)
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
			)
)


createdialog supervisor_rollout
)
