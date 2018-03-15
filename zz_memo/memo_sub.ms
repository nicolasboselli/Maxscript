
 
 

rollout test "test" height:200

( 

  subrollout test1 "test1"

  subrollout test2 "test2"

)

 

rollout test1a "test1a"

( 

  spinner test1as "test1as"

)

 

rollout test1b "test1b"

( 

  spinner test1bs "test1bs"

)

 

createdialog test

 

AddSubRollout test.test1 OverRiderRT

AddSubRollout test.test1 test1b

 

test.test1.height += 100

test.test2.pos += [0,100]

 

rollout test2a "test2a"

( 

  spinner test2as "test2as"

)

 

AddSubRollout test.test2 test2a

test.test2.height += 50

 
 
