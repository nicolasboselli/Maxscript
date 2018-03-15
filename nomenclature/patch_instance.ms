sel = selection as array

for s in sel do
(
	if matchpattern s.name pattern: "*001" and matchpattern s.name pattern: "P_LeLoup_*" then
	(
		s.name = substitutestring s.name "001" ""
		s.name = substitutestring s.name "P_LeLoup_" "P_LeLoup01_"
	)
	else()
)
