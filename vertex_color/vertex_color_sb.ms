getNumVerts $


for i = 1 to 98 do setvertcolor $ i ( color 0 255 0 )

$.vertexColorType = 2
$.boxmode = on
$.boxmode = off
$.vertexColorType = 0
$.boxmode = on
$.boxmode = off


$.vertexColorType = 2
$.vertexColorType = 0

$.backfacecull = on
$.backfacecull = off
	
$.boxmode = off

getVertColor $ 1
setvertcolor $ 2 (color 0 0 0)
redrawViews()


fn gammaCorrectColor col val:2.2 =
(
	if iDisplayGamma.colorCorrectionMode == #gamma then
	(
		newCol = white
		newCol.r  = (pow (col.r/256.0) (1.0/val)) * 256.0
		newCol.g  = (pow (col.g/256.0) (1.0/val)) * 256.0
		newCol.b  = (pow (col.b/256.0) (1.0/val)) * 256.0

		newCol
	)
	else
	(
		col
	)
)


gammaCorrectColor (color 1 1 1)