-- macroscript FreeSpline category:"HowTo" tooltip:"FreeSpline"
rollout freeSplineRLT "freeSpline"
(
	local old_pos
	local new_spline
	local second_knot_set
	 
	fn get_mouse_pos pen_pos old_pen_pos =
	(
		if old_pos == undefined then old_pos = old_pen_pos
		if distance pen_pos old_pos > 10 then
		(
			if second_knot_set then
			addKnot new_spline 1 #smooth #curve pen_pos
			else
		(
			setKnotPoint new_spline 1 2 pen_pos
			second_knot_set = true
		)
			old_pos = pen_pos
			updateShape new_spline
		)-- end if
	)-- end fn
	
	fn draw_new_line old_pen_pos =
	(
		pickPoint mouseMoveCallback:#(get_mouse_pos,old_pen_pos)
	)
	
	button freeSplineBT "free spline"
	
	on freeSplineBT pressed do
	(
		undo"Free Spline"on
		(
			new_spline = splineShape ()
			old_pen_pos = pickPoint ()
			if old_pen_pos == #RightClick then
			(
				delete new_spline
			)
			else
			(
				select new_spline
				new_spline.pos = old_pen_pos
				addNewSpline new_spline
				addKnot new_spline 1 #smooth #curve old_pen_pos
				addKnot new_spline 1 #smooth #curve old_pen_pos
				second_knot_set = false
				draw_new_line old_pen_pos
				q = querybox "Close Spline?" title:"Free Spline"
				if q then
				(
					close new_spline 1
					updateshape new_spline
				) 
				select new_spline
			)--end else
		)--end undo
	)
)--end script

createDialog freeSplineRLT