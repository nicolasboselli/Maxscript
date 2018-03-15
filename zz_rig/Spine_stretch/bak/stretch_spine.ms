os = $ as array

test = line ()

addnewspline test
for i = 1 to os.count do 
addknot test 1 #corner #line os[i].pos

updateshape test

os.count