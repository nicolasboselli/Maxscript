-- loopList = $.GetSelection #edge
-- $.SelectBorder ()
-- $.ConvertSelection #Border #edge
-- borderList = $.GetSelection #edge

loopList = polyop.getEdgeSelection  $.baseobject
borderList = polyOp.getOpenEdges $.baseobject

-- loopList * borderList
polyop.setEdgeSelection  $.baseobject (loopList * borderList)