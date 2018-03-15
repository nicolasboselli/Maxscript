rollout objectKiller "Object Killer"
(
button collec "collect"
	on collec changed state do 
	if state == on then 
	(test = for o in $ collect o.name)
 else
(test = #()
)	--Define a list box, collect the names of all scene objects and
--assign them to the items array
listbox objectToKill "Objects:" items:test
--If the user clicked a name on the list,
--get the name from the .items array by index
--then get the node by name and select it.
--COMPARE to the doubleClicked handler below which performs a
--similar task using a slightly different approach.
--Both ways are valid!
on objectToKill selected nameIndex do
select (getNodeByName objectToKill.items[nameIndex])
on objectToKill doubleClicked itm do
(
--Get node using its name from the .selected property and delete it:
delete (getNodeByName objectToKill.selected)
--Get the items into a temporary array:
temp = objectToKill.items
--Delete the doubleckicked item by index
--the local variable itm contains the index!
deleteItem temp itm
--Assign the result back to the items array:
objectToKill.items = temp
)
)
createDialog objectKiller--create a dialog from the rolloutParameters