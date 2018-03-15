
fn cleanEltsOutput =
(
	re = maxOps.GetCurRenderElementMgr ()
	num = re.numrenderelements ()
	for i = 0 to (num - 1) do re.SetRenderElementFilename i ""
)
cleanEltsOutput()