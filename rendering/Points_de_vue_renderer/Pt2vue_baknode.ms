-- creation du helper

if (getnodebyname "Pt2vueNode") == undefined then 
(
	Pt2vueNode = point name: "Pt2vueNode"

	ZeroLayer = LayerManager.getLayer 0
	ZeroLayer.addnode Pt2vueNode


	the_Pt2vueNodeAT1 = attributes CameraStack
	(
	)
	custAttributes.add Pt2vueNode the_Pt2vueNodeAT1
	
	the_Pt2vueNodeAT2 = attributes OutPathname
	(
	)
	custAttributes.add Pt2vueNode the_Pt2vueNodeAT2
	print "pt2vuenode vient d'etre creer"

)
else
(
	Pt2vueNode = (getnodebyname "Pt2vueNode")
	print "pt2vuenode detecte"
	
	print (custAttributes.getdefdata (custAttributes.getdef Pt2vueNode.camerastack))
	print (custAttributes.getDefData (custAttributes.getdef Pt2vueNode.OutPathname))

)

-- 
delete Pt2vueNode 
/*

-- ecriture des datas
custAttributes.getdefdata (custAttributes.getdef $.camerastack)
custAttributes.getDefData (custAttributes.getdef $.OutPathname)


-- recuperation des Datas
custAttributes.setDefData (custAttributes.getdef $.camerastack) CamArray
custAttributes.setDefData (custAttributes.getdef $.OutPathname) (Pt2vue_renderer_UI.savepath.text)
*/

	


/*
-- custAttributes.delete Pt2vueNode 1

custAttributes.setDefData (custAttributes.getdef $ 1) #()

custAttributes.getdefs $ 

select Pt2vueNode

custAttributes.delete Pt2vueNode 1

custAttributes.count Pt2vueNode

array1 = #("test1","test2")
array2 = #("test3","test4")
	

custAttributes.setDefData the_Pt2vueNodeAT #(array1,array2)

arr = custAttributes.getDefData the_Pt2vueNodeAT

custAttributes.get Pt2vueNode 1

custAttributes.getDef  Pt2vueNode 1

$.the_Pt2vueNodeAT
*/