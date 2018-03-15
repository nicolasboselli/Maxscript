fn printTotoFN  a b = 
(
	for o in ($selection as array) do print o.name 
)

test = NodeEventCallback mouseup: true delay: 1000   selectionChanged: printTotoFN 

printTotoFN

test = undefined
gc ()

-- v = "toto"

LM = LayerManager

lm.count

oneLay = lm.getLayer 0 

oneLay.alledges =false

