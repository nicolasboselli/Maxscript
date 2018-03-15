model = $3008_proxy_
sel = selection as array

for s in sel do
(
	res = instancereplace s model
	res.parent = undefined
	res.name = uniquename "3008_proxy_"
)


model = $art_de_table_proxy_01

sel = selection as array
for s in sel do
(
	ref = s.transform
	inst = instance model
	inst.transform = ref
)

