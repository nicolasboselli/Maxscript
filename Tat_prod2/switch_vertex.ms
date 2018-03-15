vertAr = ($.GetSelection #vertex) as array
vertA = vertAr[1]
vertB = vertAr[2]

-- posA = $.GetVertex  vertA
-- posB = $.GetVertex  vertB

-- $.setvertex 
posA = polyop.getVert $ vertA 
posB = polyop.getVert $ vertB

polyop.setVert $ vertA posB
polyop.setVert $ vertB posA