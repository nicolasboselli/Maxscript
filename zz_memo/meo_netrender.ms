-- test = RenderElementMgr
-- RenderEltInt = maxOps.GetCurRenderElementMgr ()

-- showproperties NetRendMng 

-- RenderEltInt.SetElementsActive  false

-- render frame: #current 
/*
rendusenet true

rendUseNet = true

rendShowVFB = true



m.connected

m.QueryControl #dontwait

m.GetControl ()

Jobtest.delete ()

*/


Global m = NetRender.GetManager()

rollout NetRenderRLT "Manger Connection" width: 400
(
-- 	vars
	local mstate
	
-- 	UI
-- 	checkbutton Connect2ManagerCB "connect to manager" checked: true
	group "Connect Manager"
	(
		button Connect2ManagerBT "Connect to Manager" across: 3
		button CkeckManagerBT "Check Manager"
		button DisconnectManagerBT "Disconnect Manager"
	)
	button SendRenderBT "send Test"
	
-- 	Actions
	on NetRenderRLT open do
	(
-- 		Connect2ManagerCB.checked = m.connected
		print m.connected
-- 		print Connect2ManagerCB.state
	)
	
	on DisconnectManagerBT pressed do
	(
		m.Disconnect ()
	)
	
	on Connect2ManagerBT pressed do
	(
		m.connect #manual "192.168.0.69"
	)
	
	on CkeckManagerBT pressed do
	(
		WaitingJobs = m.getjobs filter:#waiting
		for o in WaitingJobs do print o.name
	)
	
	on SendRenderBT pressed do
	(
		Jobtest = m.newjob ()
		Jobtest.submit ()
	)
	
)

createdialog NetRenderRLT

