sourceColor = color (random 0 255) (random 0 255) (random 0 255)
sourceArr = for i = 1 to 4 collect box pos: [(random -500 500),(random -500 500),(random -500 500)] \
rotation: (eulerAngles  (random 0 360) (random 0 360) (random 0 360)) name: (uniquename "source") \
wirecolor: sourceColor

targetColor = color (random 0 255) (random 0 255) (random 0 255)
targetArr =  for i = 1 to 4 collect box pos: [(random -500 500),(random -500 500),(random -500 500)] \
rotation: (eulerAngles  (random 0 360) (random 0 360) (random 0 360)) name: (uniquename "target") \
wirecolor: targetColor
	
	

for i = 1 to  sourceArr.count do 
(
	targetArr[i].rotation = sourceArr[i].rotation
	targetArr[i].position = sourceArr[i].position
)