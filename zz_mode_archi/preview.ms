
--The following script creates a plane and a small menu to interactively
--extrude selected polygons.
p = convertToPoly(Plane()) --create a plane, turn to Epoly.
select p --select the plane
max modify mode --enter Modify panel
subobjectlevel = 4 --set Sub-Object mode to Polygon
rollout extrude_faces"Extrude" --define a rollout
(
button try_it"Preview"across:3 --a button to start a new extrusion
button cancel_it"Cancel" --a button to cancel preview
button accept_it"Accept" --a button to accept the extrusion
on cancel_it pressed do p.previewCancel() --cancel
on accept_it pressed do p.previewAccept() --accept
on try_it pressed do p.previewBegin #Extrude --begin again
)
createDialog extrude_faces 200 30 --create a dialog with the rollout
--Run the script, select some polygons, press Preview
--and watch them extrude interactively.
--Press Accept if you like the result, press Cancel to discard.
--Press Preview again for next extrusion etc.  
