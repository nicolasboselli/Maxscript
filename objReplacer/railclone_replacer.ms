sel = selection as array
rc = sel[1]

fn railCloneReplace rc others =
(
	if classof rc == railclone_pro then
	(
		for i = 2 to others.Count do
		(
			l = others[i]
			
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

railCloneReplace rc sel






/*
sp = $.banode[1]

$.transform = sp.transform

	redrawViews ()
*/