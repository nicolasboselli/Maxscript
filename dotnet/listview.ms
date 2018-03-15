
rollout listview_rollout "ListView Selected"
(
/* ActiveX Version:
fn initListView lv =
(
lv.gridLines = true 
lv.View = #lvwReport 
lv.fullRowSelect = true
layout_def = #("Object Name", "Object Class", "Verts", "Faces", "Material")
for i in layout_def do
(
column = lv.ColumnHeaders.add()
column.text = I
)
)
*/

	fn initListView lv =
	(
		lv.gridLines = true --same as in ActiveX
		--The following controls the display of details. We use defaults:
		lv.View = (dotNetClass "System.Windows.Forms.View").Details
		lv.fullRowSelect = true --same as in ActiveX
		layout_def = #("Object Name", "Object Class", "Verts", "Faces", "Material")
		for i in layout_def do
		lv.Columns.add i 96 --add column with name and optional width
	)
/* ActiveX Version:
fn fillInSpreadSheet lv =
(
for o in selection do
(
li = lv.ListItems.add()
li.text = o.name
sub_li = li.ListSubItems.add()
sub_li.text = (classof o) as string
sub_li = li.ListSubItems.add()
sub_li.text = try((o.mesh.numverts) as string)catch("--")
sub_li = li.ListSubItems.add()
sub_li.text = try((o.mesh.numfaces) as string)catch("--")
sub_li = li.ListSubItems.add()
sub_li.text = (o.material) as string
)
)
*/

	fn fillInSpreadSheet lv =
	(
		theRange = #() --array to collect the list items
		for o in selection do
		(
			--First we create a ListViewItem objectwith the object's name:
			li = dotNetObject "System.Windows.Forms.ListViewItem" o.name
			--Then we add all the sub-itemswith the desired string values:
			sub_li = li.SubItems.add ((classof o) as string)
			sub_li = li.SubItems.add (try((o.mesh.numverts) as string)catch("--"))
			sub_li = li.SubItems.add (try((o.mesh.numfaces) as string)catch("--"))
			sub_li = li.SubItems.add ((o.material) as string)
			append theRange li--we add the list item to the array
		)
		lv.Items.AddRange theRange--when done, we populate the ListView
	)
/* ActiveX Version:
activeXControl lv_objects "MSComctlLib.ListViewCtrl" width:490 height:190 align:#center
*/

	dotNetControl lv_objects "System.Windows.Forms.ListView" width:490 height:190 align:#center
	on listview_rollout open do
	(
		initListView lv_objects
		fillInSpreadSheet lv_objects
	)
	)
	
try(destroyDialog listview_rollout)catch()
createDialog listview_rollout 500 200
