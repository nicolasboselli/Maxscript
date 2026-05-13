objetWhithoutMat = #()

for o in geometry where o.material == undefined do
(
	print o
	append objetWhithoutMat o
	
)
select objetWhithoutMat