matAr = for mat in scenematerials collect mat
qsort matAr sortMatbyname
-- matNameAr = for mat in matAr collect mat.name
-- finditem matNameAr	"Acier gris poli"

for i = 1 to (matAr.count - 1) do
(
	if matAr[i].name == matAr[i + 1].name then
	(
-- 		format "i: %, matAr[i]: % matAr[i + 1]: %\n" i matAr[i].name matAr[i + 1].name
		format "count: % i: % replaceinstances matAr[i + 1]: % by matAr[i]: %\n" matAr.count i matAr[i + 1].name matAr[i].name 
		replaceinstances matAr[i + 1] matAr[i]
	)
	else()
)
-- matAr[6].name