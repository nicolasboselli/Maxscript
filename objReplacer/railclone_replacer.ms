

-- superclassof $.baseobject 

fn railCloneReplace rc others =
(
-- 	format "youpi\n"
	if classof rc == railclone_pro then
	(
		for i = 2 to others.Count do
		(
			
			l = others[i]
			if superclassof l.baseobject != shape do continue
				
			modcount = l.modifiers.count
			for i = 1 to modCount do deletemodifier l 1
			-- copy railclone
			new = copy rc
			-- assign new spline
			new.banode[1] = l

			-- realign railclone
-- 			new.transform = copy l.transform
			new.transform = copy l.transform

			-- re assign line
			new.banode[1] = l
			

			-- realign railclone
		-- 	new.transform = copy l.transform
			new.disabled = on
			redrawviews ()
			
			new.disabled = off
			redrawviews ()
		)
	)
	else()
)

sel = selection as array
oneRc = sel[1]
railCloneReplace oneRc sel






/*
sp = $.banode[1]

$.transform = sp.transform

	redrawViews ()
*/