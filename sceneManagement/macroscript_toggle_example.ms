macroScript test category:"Tests"
(
  local isOpen = false --initialize to false (closed)
  rollout myRollout "MyRollout"
  (
    label lbl_hello "hello world"
    on myRollout close do --when closing, set to false and redraw GUI
    (
      isOpen = false
      updateToolbarButtons()
    )
  )
  on execute do
  (
    if isOpen then --if open, close it
    (
      destroyDialog myRollout
      isOpen = false--and lower the flag
    )
    else --if closed, open it
    (
      createDialog myRollout
      isOpen = true --and raise the flag
    )
  )
  on isChecked return isOpen --return the flag
)