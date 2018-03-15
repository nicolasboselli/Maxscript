s = $
animatevertex s #all

converttosplineshape s
refinesegment
updateshape s


addmodifier s (Edit_Spline())
convertto s SplineShape	