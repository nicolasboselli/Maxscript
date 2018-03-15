
filename = @"C:\Users\nicolas\Desktop\animTest\test2.xaf"
nodes = selection as array
userAttributes = #("")
userValues = #("")

LoadSaveAnimation.saveAnimation fileName nodes userAttributes userValues \
animatedTracks:true includeConstraints:false keyableTracks:true saveSegment:false segInterval: (interval 0f 10f)  segKeyPerFrame: false 