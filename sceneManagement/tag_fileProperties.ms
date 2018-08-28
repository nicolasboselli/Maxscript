/*
maj:
-- tagger rootplans et outputpath au changement de fichier

*/
try(callbacks.removeScripts #filePreSave id:#tagRCFP)catch()

-- tag file properties railclone inside
fn tagRailconeFilePropertie =
(
	RailClone_Inside
	rcScene = getclassinstances railclone_pro
	if rcScene.count > 0 then RailClone_Inside = true else RailClone_Inside = false
	fileProperties.addProperty #custom "RailClone_Inside" RailClone_Inside 

	-- interroge file properties railclone inside
	rciId = fileProperties.findProperty #custom "RailClone_Inside"
	format "railcone inside: %\n" (fileProperties.getPropertyValue #custom rciId)
)

(
	local rcproid = finditem GeometryClass.classes railclone_pro
	-- callback pre save
	if rcproid > 0 then
	(
		callbacks.addScript #filePreSave  "tagRailconeFilePropertie()" id:#tagRCFP
		format "tagRailconeFilePropertie loaded\n"
	)
	else
	(
		format "tagRailconeFilePropertie NOT loaded\n"
	)
)


