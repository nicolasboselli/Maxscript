sel = selection as array

source = sel[1]
-- target = sel[2]

propAr = getPropNames source

for i = 2 to sel.count do
(
	for p in propAr do 
	(
		if hasProperty  sel[i] p then
		(
			try(setProperty sel[i] p (getProperty source p))catch(format "property transfer ERROR: % \n" p)
			format "property transfer done: %\n" p
		)
		else
		(
			format "property transfer fail: %\n" p
		)
	)
)


-- showproperties $