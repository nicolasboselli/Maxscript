

rollout colorBoxRLT "color box"
(
	local T1color = color 178 0 0
	local T2Color = color 109 217 0
	local T3Color = color 255 51 102
	local T4Color = color 255 147 38
	local T5Color = color 80 210 194
	local T6Color = color 0 102 102
	
	button T1BT "T1"
	button T2BT "T2"
	button T3BT "T3"
	button T4BT "T4"
	button T5BT "T5"
	button T6BT "T6"
	
	on T1BT pressed do
	(
		for s in selection do s.wirecolor = T1Color
	)
	
	on T2BT pressed do
	(
		for s in selection do s.wirecolor = T2Color
	)
		
	on T3BT pressed do
	(
		for s in selection do s.wirecolor = T3Color
	)
		
	on T4BT pressed do
	(
		for s in selection do s.wirecolor = T4Color
	)
		
	on T5BT pressed do
	(
		for s in selection do s.wirecolor = T5Color
	)
		
	on T6BT pressed do
	(
		for s in selection do s.wirecolor = T6Color
	)
	
)
createdialog colorBoxRLT