

-- superclassof $.baseobject 

fn railCloneReplace rc others =
(
-- 	format "youpi\n"
	if classof rc.baseobject == railclone_pro then
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
-- superclassof $.baseobject
fn railCloneReplace2 rc l = 
(
	if classof rc.baseobject == RailClone_Pro and superclassof l.baseobject == shape then
	(
			format "rc: % l: %\n" rc.name l.name
			local modcount = l.modifiers.count
			
		
		
			for i = 1 to modCount do deletemodifier l 1
			-- copy railclone
			new = copy rc
			l.layer.addnode new
			
			-- assign new spline
			new.banode[1] = l

			-- realign railclone
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
	else
	(
		format "fail rc: % l: %\n" rc.name l.name
	)
)

sel = selection as array
-- oneRc = sel[1]
-- railCloneReplace oneRc sel

for i = 2 to sel.count do 
(
	railCloneReplace2 sel[1] sel[i]
)



/*
sp = $.banode[1]

$.transform = sp.transform

	redrawViews ()
*/