macroScript macroScaleOne
	category:"ArmadasScripts"
	toolTip:""
(
	fn scale1 s = s.scale.controller.value = [1,1,1]
		
	sel = selection as array
	for s in sel do scale1 s
)
