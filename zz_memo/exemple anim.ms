b=box height:10

at time 5 animate on b.height=50

at time 10 animate on b.height=100

bhc=b.height.controller

bhk=bhc.keys

addnewkey bhc 7

addnewkey bhc 9

for k in bhk do format "%:%\n" k.time k.value

selectKeys bhc (interval 7 9)

deleteKeys bhc #selection

bhk

addnewkey bhc 7

addnewkey bhc 9

selectKeys bhc (interval 7 9)

deleteKeys bhc #selection #slide

bhk

addnewkey bhc 7

addnewkey bhc 9

selectKeys bhc (interval 7 9)

deleteKeys bhc #selection #slide #rightToLeft

bhk

addnewkey bhc 8

i=getKeyIndex bhc 8

selectKey bhc i

moveKey bhc i 10

bhk

getKeyTime bhc 4

b.width.controller=noise_float()

numkeys b.width.controller