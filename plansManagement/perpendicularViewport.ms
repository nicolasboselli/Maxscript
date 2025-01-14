fn perpendicularViewport =
(
	sel = selection as Array
	if sel.count == 1 then
	(
		viewport.setTM (inverse(sel[1].transform))
		viewport.setType #view_persp_user 
	-- 	viewport.setType #view_iso_user 
	-- 	viewport.ZoomToBounds false sel[1].min sel[1].max
	-- 	viewport.setType #view_persp_user 
		viewport.setType #view_iso_user 
		viewport.ZoomToBounds false sel[1].min sel[1].max
		redrawViews()
	)
)
	
perpendicularViewport()