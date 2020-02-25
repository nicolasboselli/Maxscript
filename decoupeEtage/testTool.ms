tool foo
(
	local restart = false
	
	on start do print "Starting"
		
	on freeMove do
	(
		print "Free Moving"
		restart = false
	)
	
	on mousePoint clickno do
	(
		format "Point: %\n" clickno
		restart = true
		
		if clickno > 10 then
		(
-- 			format "pre stop\n"
			#stop
-- 			format "post stop\n"
		)
	)
	

	on mouseMove clickno do format "Moving: %\n" clickno
	
	on mouseAbort clickno do
	(
		format "Abort: %\n" clickno
	)
		
	on stop do
	(
		print "Ending"
		if restart then starttool foo
	)
)
startTool foo prompt:"Hello!"