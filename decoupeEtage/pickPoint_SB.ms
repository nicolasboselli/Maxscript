fn printPickPoint val =
(
	format "val: %\n" val
)


fn testPickPoint  =
(
	local p = pickPoint mouseMoveCallback:printPickPoint
	format "p = %\n" p
)

testPickPoint()

