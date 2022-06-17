fn sme_deleteView view:#all ask:on = 
(
	num = sme.GetNumViews()
	
	if view == #active then
	(
		sme.DeleteView sme.activeview ask
	)
	else if view == #all then
	(
		if not ask or queryBox "Do you really want to remove all node views?\n All node data will det lost!"  title:"Remove All Views" do
		(
			while sme.GetNumViews() > 0 do sme.DeleteView 1 off
		)
	)
	else if iskindof view Number do
	(
		sme.DeleteView view ask
	)
	
	num - sme.GetNumViews()
)

/* using >>>>>>>>

-- the optional <view> argument can be #active, #all or index
-- the optional <ask> argument asks to confirm deletion

sme_deleteView view:#all ask:on

*/