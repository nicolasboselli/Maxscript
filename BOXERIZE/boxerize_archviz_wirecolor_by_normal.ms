-- wirecolor by normal

-- $.transform.row1

fn wirecolorByOrientation sel = 
(
	colors = #(red, green, blue, yellow, brown, orange, black, white, \
		(color 225 88 199), (color 88 177 27), (color 141 7 58), (color 87 225 198),\
		(color 27 177 27),(color 225 88 199), (color 28 149 177), (color 224 86 86),
		(color 135 59 8))

	normalsCollected = #()

	for s in sel do
	(
		format "start s: %\n" s.name
		colorid = undefined
		alreadycollectd = false
		
		if normalsCollected.count == 0 then
		(
			append normalsCollected s.transform.row1
			s.wirecolor = colors[normalsCollected.count]
			continue
		)
		
		for i = 1 to normalsCollected.count do
		(
			test = minAngle = ((((acos(dot s.transform.row1 normalsCollected[i]))*100)as integer)as float)/100
			if test <= 1 then 
			(
				
				alreadycollectd = true
				colorid = i
				format "alreadycollectd: % corlorid: %\n" alreadycollectd i
			)
		)
		
		if alreadycollectd then
		(
			s.wirecolor = colors[colorid]
		)
		else
		(
			append normalsCollected s.transform.row1
			s.wirecolor = colors[normalsCollected.count]
		)
		
		format "done s: %\n" s.name
		
	)
)

sel = selection as Array
wirecolorByOrientation sel

-- $.wirecolor
-- $.transform.row1