
-- scene setting
units.SystemType = #Centimeters 
units.DisplayType = #Metric
units.MetricType = #meters
units.MetricType = #centimeters

environmentmap.manual_sun_node = false 

xrefs.deleteAllXRefs ()


-- object scale
fn rescaleObj s =
(
	s.scale = [100,100,100]
	resetxform s
	converttopoly s
)
rescaleObj $

