objs = selection as array

for o in objs where (doesUserPropExist o "pivotFenetre") do
(
	setUserProp o "pivotFenetre" (not (getUserProp o "pivotFenetre"))
	format "done:%\n" o.name
)

(
	try
	(
		doesUserPropExist o "pivotFenetre"
		setUserProp o "pivotFenetre" (not (getUserProp o "pivotFenetre"))
		format "done:%\n" o.name
	)
	catch(format "fail:%\n" o.name)
)


classof (getUserProp $ "windowsTemplate")