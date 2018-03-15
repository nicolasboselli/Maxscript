macroScript Clean_Output
	category:"ArmadasScripts"
	toolTip:""
(
	re = maxOps.GetCurRenderElementMgr ()

	num = re.numrenderelements ()

	clean_name = ""

	for i = 0 to (num - 1) do
	(
	re.SetRenderElementFilename i clean_name
	)
)