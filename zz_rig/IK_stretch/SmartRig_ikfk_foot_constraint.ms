selToCons = $selection as array

for o in selToCons do
(
	o.position.controller = Position_XYZ ()
	o.position.controller = Position_Constraint ()
	
	o.rotation.controller = Euler_XYZ ()
	o.rotation.controller = Orientation_Constraint ()
)