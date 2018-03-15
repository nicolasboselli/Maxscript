sel = objects as array 
bipTagsAr = #()
for s in sel do
(
	if classof s == Biped_Object then
	(
		ar = filterString s.name " "
		print ar[ar.count]
		append  bipTagsAr ar[ar.count]
	)
)	
bipTagsAr
