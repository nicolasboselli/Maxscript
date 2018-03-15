-- tag file properties railclone inside
RailClone_Inside
rcScene = getclassinstances railclone_pro
if rcScene.count > 0 then RailClone_Inside = true else RailClone_Inside = false
fileProperties.addProperty #custom "RailClone_Inside" RailClone_Inside 

-- interroge file properties railclone inside
rciId = fileProperties.findProperty #custom "RailClone_Inside"
format "railcone inside: %\n" (fileProperties.getPropertyValue #custom rciId)