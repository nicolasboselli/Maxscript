-- b1 = box()
-- b2 = box()



fn posInTime = 
(
	t1 = timeStamp()
	bakpos = b1.pos

	do
	(
		pauseOk = false
		t2 = timeStamp()
		
		if t2 - t1 > 1000 then 
		(
			pauseOk = true
		)
-- 		else format "pause: %\n" (t2 - t1)
		
	)
	while not pauseOk
	
	
	newpos = b1.pos
	vec = normalize(newpos - bakpos)
	format "vec: ¨%\n" vec
)
-- posInTime()

when transform b1 changes id: #toto do
(
	t1 = timeStamp()
	bakpos = b1.pos

	do
	(
		pauseOk = false
		t2 = timeStamp()
		
		if t2 - t1 > 1000 then 
		(
			pauseOk = true
		)
-- 		else format "pause: %\n" (t2 - t1)
		
	)
	while not pauseOk
	
	newpos = b1.pos
	vec = normalize(newpos - bakpos)
	format "vec: ¨%\n" vec
)

deleteAllChangeHandlers ()

currentTime

t1 = timeStamp() 
t2 = timeStamp() 
-- t1 = timeGetTime()
t2 - t1



theTimer = dotNetObject "System.Windows.Forms.Timer"
fn printTime = (
	format "localtime: %\n" localtime
		b2.pos = b1.pos 
)
dotnet.addEventHandler theTimer "tick" printTime
theTimer.interval = 1000
theTimer.start()

localtime
-- theTimer.stop()

rollout test "Test Timer"
(
	local newpos
	local bakpos
	
	timer clock "testClock" interval:500 active: false--tick once a second
	button startBT "start clock"
	
	on startBT pressed do
	(
		newpos = b1.pos
		clock.active = not clock.active
		format "clock.active : %\n" clock.active 
	)

	on clock tick do
	(
		bakpos = newpos
		newpos = b1.pos
		vec = normalize(newpos - bakpos)
		format "vec: %\n" vec
		b2.pos = b1.pos 
		redrawviews ()
	)
)
createDialog test

 
