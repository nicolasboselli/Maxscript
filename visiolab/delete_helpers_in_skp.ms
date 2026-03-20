start = timeStamp()
maxDeletedCount = 10000
deletedCount = 0
deleteCount = 1000

spAr =  helpers as array
startCount = spAr.count
maxDeletedCount = spAr.count


turn = 0
j = 0
startTmp = timeStamp()

for i = 1 to maxDeletedCount do
(
	
	delete spAr[i]
	j += 1
	if j > deleteCount then 
	(
		deletedCount += deleteCount
		turn += 1
		endTmp = timeStamp()
		format "deleted : % / % last : % time: % turn: %\n" deletedCount maxDeletedCount (helpers  as array).count  ((endTmp - startTmp)/1000) turn
		j = 0
		startTmp = timeStamp()
		
		
	)
	
)
-- classof $
end = timeStamp()
spAr = helpers  as array
format "time past: % turn: % last objects: % last time: %\n" (( end - start ) / 1000) turn spAr.count ((spAr.count / deletedCount )*((end-start) / 1000 ))

