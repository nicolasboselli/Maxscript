rendOutputFilename = "" 

rem = maxOps.GetRenderElementMgr #Production
count = rem.NumRenderElements()

for i = 0 to count do
(
	print (rem.GetRenderElementFilename i)
	rem.SetRenderElementFilename i ""
)
