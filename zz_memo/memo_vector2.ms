A = $A.pos
B = $B.pos
C = $C.pos

v1 = normalize (A - B)
v2 = normalize (A - C)

acos (dot v2 v1)