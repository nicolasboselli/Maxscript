first = box width: 2 length: 2 height: 100
converttopoly first
first.pivot = first.center
resetxform first
converttopoly first

jump = 5
lastJump = 0

randomPost = #()
for i = 1 to 60 do
(
	copyFirst = copy first
	lastJump  = lastJump + jump
	move copyFirst [lastJump, (random -1 1), 0]
	in coordsys local copyFirst.controller.rotation.y = (random -0.1 0.1)
	append randomPost copyFirst
)

select randomPost

