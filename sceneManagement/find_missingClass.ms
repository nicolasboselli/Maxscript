-- classof $
objs = objects as array

missingObjs = for o in objs where classof o == Missing_GeomObject collect o
-- (
-- 	if classof o == Missing_GeomObject then format "%: %\n" o.name (classof o)
-- )
-- 	
select missingObjs