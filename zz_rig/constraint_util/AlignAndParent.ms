-- Align and parent
duoAr = selection as array
-- Align

duoAr[1].parent = duoAr[2]
in coordsys parent duoAr[1].rotation = (quat 0 0 0 -1)
in coordsys parent duoAr[1].position = [0,0,0]
	


