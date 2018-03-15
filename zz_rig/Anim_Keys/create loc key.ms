-- la fonction createlockkey ne fonctionne pas

for o in ($selection as array) do
(
createLockKey o.pos.controller (slidertime - 1) 0
createLockKey o.pos.controller (slidertime - 1) 1
)