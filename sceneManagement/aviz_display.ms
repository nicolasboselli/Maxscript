for s in (getclassinstances AvizstudioToolsATiles) do s.tilesViewport = 3

for o in geometry where iskindof o AvizstudioToolsATiles do (converttopoly o)
-- for s in (getclassinstances AvizstudioToolsATiles) do (converttopoly s)
-- converttopoly $