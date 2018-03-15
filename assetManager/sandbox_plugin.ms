plugin helper getsetHandlerTest
name:"DummyEx"
classID:#(1453456,5432110)
category:"Scripted Primitives"
extends:dummy
(
	parameters main rollout:params
	(
		nodeTab type:#nodetab tabSizeVariable:true
		on nodeTab set val index do format "set nodeTab: % : %\n" val index
		on nodeTab get val index do (format "get nodeTab: % : %\n" val index;val)
		intTab type:#inttab tabSizeVariable:true
		on intTab set val index do format "set intTab: % : %\n" val index
		on intTab get val index do (format "get intTab: % : %\n" val index;val)
		point3Tab type:#point3tab tabSizeVariable:true
		on point3Tab set val index do format "set point3Tab: % : %\n" val index
		on point3Tab get val index do (format "get point3Tab: % : %\n" val index;val)
		intVal type:#integer
		on intVal set val do format "set intVal: %\n" val
		on intVal get val do (format "get intVal: %\n" val;val)
	)
	rollout params "Parameters"
	(
		edittext testET "test:"
	)
)
getsetHandlerTest()