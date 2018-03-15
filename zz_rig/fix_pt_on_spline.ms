pt = $Point001.position.controller.percent.controller

pt.value = 40

fs = 200
cs = curvelength  $Line001

pt.value = fs/cs*part

fs = curvelength  $tentacle_line

sel = selection as array
sel[2].position.controller.percent.controller = sel[1].position.controller.percent.controller

for s in selection do s.scale.controller.value = [1,1,1]