if $selection.count > 0 then
(

	local RenderList = batchRenderMgr

	local RenderListNameBak = #()
	local RenderListOutputBak = #()


	local RendNum = RenderList.numViews 

	-- bakup
	for i = 1 to RendNum do
	(
	TempRender = RenderList.getview i
	append RenderListNameBak TempRender.name
	append RenderListOutputBak TempRender.outputFilename
		
	print TempRender.name
	print TempRender.outputFilename 
	)

	-- modif des 

	for i = 1 to RendNum do
	(
	TempRender = RenderList.getview i
	TempRender.name =  TempRender.name + "_alpha"
	
	print TempRender.name
	print TempRender.outputFilename 
	)
	
	batchRenderMgr.render ()	
	
	-- recup_bakup
	for i = 1 to RendNum do
	(
	TempRender = RenderList.getview i
	TempRender.name = RenderListNameBak[i]
		
	print TempRender.name
	print TempRender.outputFilename 
	)
)
-- batchRenderMgr.render ()