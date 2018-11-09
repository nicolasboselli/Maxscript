--script to explode splines from a shape leaving the original intact
(
baseSpline = $
indx = baseSpline.numSplines 
i_array = #()
for i = 1 to indx do
 (
 newspline = copy baseSpline name:(uniqueName "exploded spline")
 for a = indx to 1 by -1 where a != i do
  (
  deleteSpline newspline a
  )
 CenterPivot newspline
 updateShape newspline
 )
)

fn explodesplines x=
(
	for j=1 to numsplines x do
	(
		s=splineshape pos:x.pos name:(x.name+"-SHAPE"+(j as string))
		a=addnewspline s
		for i=1 to numknots x j do
		(
			try seg=(getsegmenttype x j i)
			catch seg=#line
			addknot s a (getknottype x j i) (seg) (getknotpoint x j i) (getinvec x j i) (getoutvec x j i)
		)
		if (isclosed x j) then close s 1
		updateshape s
	)

)
for s in selection do if classof s==SplineShape then explodesplines s