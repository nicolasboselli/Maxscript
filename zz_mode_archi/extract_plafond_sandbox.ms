-- selectionner toutes les faces
$.outlineAmount = 5
$.EditablePoly.Outline ()

-- selectionner les edge ouverte
setSelectionLevel  $ #edge
edgeSel = polyop.getOpenEdges $
$.EditablePoly.SetSelection #Edge edgeSel
$.edgeExtrudeHeight = 0
$.edgeExtrudeWidth =0
$.buttonOp #extrude
move $.selectedEdges [0,0,-5]

$.capHoles #Face
move $ [0,0,2]
$.material = scenematerials["beton_blanc"]
    -- set an edge selection
-- polyOp.setEdgeSelection oPoly #{80}
-- $.EditablePoly.Extrude ()
    -- perform the edge extrusion
	
	
$.outlineAmount = -10
$.EditablePoly.Outline ()