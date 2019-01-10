s = SplineShape ()
updateShape s

extMod = extrude ()
shellMod = shell ()

addmodifier s extMod
addmodifier s shellMod
select s

-- bug
enableShowEndRes true
enableShowEndRes false
enableShowEndRes true

modPanel.setCurrentObject s.baseobject 
splineOps.startCreateLine s
-- showEndResult  true 

-- showEndResult 