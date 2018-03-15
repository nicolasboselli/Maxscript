-- verifier s il y a deja un backup dans la scene
select 
for o in scene print o.name
classOf $ == point

getNodeByName ("CamPt2vue_bakUp_" ) all: true

-- s'il y en a un ouvrir l'éditeur de camera
-- s'il y en a plusieurs demander de choisir
-- s'il n y en a pas, le créer

point name: (uniquename "CamPt2vue_bakUp_") size: 500


Attribute_CamPt2vueBak = attributes CamPt2vueBak
(
	parameters CamPt2vue
	(
		CamPt2vueNodeTab type: #nodetab tabSizeVariable: true
	)
)

custAttributes.add $ Attribute_CamPt2vueBak

custAttributes.count $

test2 = custAttributes.get $ 1

test3 = custAttributes.getdef $ 1

custAttributes.delete $ 1

$.custAttributes.name

$.test_attributes.CamPt2vueNodeTab

