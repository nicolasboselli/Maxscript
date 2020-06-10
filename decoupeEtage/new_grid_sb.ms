
sel = selection as array
basename = "batD"
newGrid = grid name: (basename + "_r00") rotation: sel[1].rotation position: sel[1].position lenght: 500 width: 500

repBasename = "rep"

repLayer = layermanager.getLayerFromName repBasename
if repLayer == undefined then repLayer = layermanager.newLayerFromName  repBasename
	
oneRepLayer = layermanager.getLayerFromName  (repBasename+ "_" +basename)
if oneRepLayer == undefined then oneRepLayer = layermanager.newLayerFromName (repBasename+ "_" +basename)

oneRepLayer.setParent repLayer

oneRepLayer.addnode newGrid
