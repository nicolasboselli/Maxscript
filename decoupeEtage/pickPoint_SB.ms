fn printPickPoint val =
(
-- 	format "val: %\n" val
)


fn testPickPoint  =
(
	local p = pickPoint () -- mouseMoveCallback:printPickPoint
	format "p = %\n" p
	box position: p
)

testPickPoint()

box pos:(gw.getPointOnCP [500,500])
getViewSize() 

$t1.transform = $b1.transform -- * $b2.transform 