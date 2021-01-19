
for o in objects do (o.controller=prs() if classof o.parent == LinkComposite do o.parent = undefined )
for o in objects where classof o == LinkComposite do delete o 