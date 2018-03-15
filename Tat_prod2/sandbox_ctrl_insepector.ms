sel = $*BIP as array

for s in sel do
(
-- 	if matchpattern 
-- 	format "s: %, ctrl: %\n" s.name s.position.controller[1]
	format "s: %, ctrl: %\n" s.name s.scale.controller
-- 	format "ctrl: %\n" s.scale.controller
	if classof  s.scale.controller == Base_Layer then selectmore s
)

-- select $P_Araignee_G_PattesB_piedOffset_BIP