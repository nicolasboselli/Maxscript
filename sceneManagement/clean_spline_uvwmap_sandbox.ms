i = 0
k = 0
for o in geometry where superclassof o.baseobject == shape do
(
	i += 1
	if o.modifiers.count == 1 then
	(
		try
		(				
			format "% s.name: % uvw: %\n" i o.name o.uvwmap
			-- 		for m in s.modifiers do deletemodifier s m
			modcount = o.modifiers.count
			for i = 1 to modCount do deletemodifier o 1
			k += 1
		)
		catch()
	)
)
format "count:%\n" k

-- format "uvwmap: % \n" $.uvwmap
-- superclassof $Plane032_shape006