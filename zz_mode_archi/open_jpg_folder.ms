sel = $selection
if sel.count == 1 do
(
	for s in sel do
	(
		bitmapVar = s.material.diffusemap.filename
		folder = getFileNamePath bitmapVar

		var = stringstream ""
		format "explorer %" folder to: var
		doscommand (var as string)
	)
)
