rollout MinMaxTest "Minimize/Maximize Test" width:208 height:28
(
	local MyHandle
	
	local WM_SYSCOMMAND	= 0x112
	local SC_MINIMIZE	= 0xf020
	local SC_MAXIMIZE	= 0xf030
	local SC_RESTORE	= 0xf120
	
	button btnMinimize "Minimize" pos:[4,4] width:64 height:20
	button btnMaximize "Maximize" pos:[72,4] width:64 height:20
	button btnClose "Close" pos:[140,4] width:64 height:20
	
	on btnMinimize pressed do
	(
		windows.sendMessage MyHandle WM_SYSCOMMAND SC_MINIMIZE 0
	)
	
	on btnMaximize pressed do
	(
		if MinMaxTest.placement == #maximized then
			windows.sendMessage MyHandle WM_SYSCOMMAND SC_RESTORE 0
		else
			windows.sendMessage MyHandle WM_SYSCOMMAND SC_MAXIMIZE 0
	)
	
	on btnClose pressed do
	(
		destroyDialog MinMaxTest
	)
	
	on MinMaxTest open do
	(
		-- backup current title and set it to a unique string
		local MyTitle = MinMaxTest.title
		MinMaxTest.title = "__UnIqUe_TiTlE__"
		
		-- get the rollouts handle using the UIAccessor interface
		local OpenDialogs	= UIAccessor.GetPopupDialogs()
		local DialogTitles	= for d in OpenDialogs collect (UIAccessor.GetWindowText d)
		local DialogIndex	= findItem DialogTitles "__UnIqUe_TiTlE__"
		MyHandle = OpenDialogs[DialogIndex]
		
		-- get the rollouts handle using the windows structure
-- 		local MaxWindows	= windows.getChildrenHWND 0 parent:#max
-- 		local WindowTitles	= for w in MaxWindows collect w[5]
-- 		local WindowIndex	= findItem WindowTitles "__UnIqUe_TiTlE__"
-- 		MyHandle = MaxWindows[WindowIndex][1]

		-- restore previous dialog title
		MinMaxTest.title = MyTitle
	)
)

createDialog MinMaxTest style:#()