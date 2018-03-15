for o in ($* as array) do
(
	if classof o == point then
	(
		o.size = o.size / 2.5
	)
)

for o in ($selection as array) do
(
	if classof o == point then
	(
		o.size = o.size / 2
	)
)

for o in ($selection as array) do
(
	if (classof o == splineshape) or (classof o == circle) then
	(
		o.radius = o.radius / 2
	)
)




