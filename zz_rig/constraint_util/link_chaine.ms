test = $selection as array
for i = 1 to (test.count-1) do test[i+1].parent = test[i] 
select test[1]