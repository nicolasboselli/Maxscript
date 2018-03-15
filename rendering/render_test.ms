-- outputfile =  @"C:\TEMPORAIRE\nico\test.jpg"
bmpTest = bitmap 720 420 gamma: 0.454545 filename: @"C:\TEMPORAIRE\nico\test.jpg"
renderDone = render vfb: false to: bmpTest 

if renderDone != undefined then
(
	save bmpTest 
	print "render done"
)
