rollout TestRenderRT "Test Render"
(
button RenderBT "render"
	
	on RenderBT pressed do
	(
		m = NetRender.GetManager()
		m.connect #manual "192.168.0.69"
		
		Jobtest = m.newjob ()
		Jobtest.submit ()
		
		m.Disconnect ()
		
		render  frame: #current  netrender: true outputwidth: renderWidth outputheight: renderHeight 
	)
)

createdialog TestRenderRT


