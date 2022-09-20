extensions[qlearningextension]
globals
[
  turtle_pos_x
  turtle_pos_y
  patch_color
  nb_trash
]
breed [blocs bloc]
breed [trashs trash]
breed [fires fire]
breed [boxes box]
turtles-own
[
  reward-list
]

patches-own
[
  reward
]


to setup-patches
  ;; initialize the patch-owned variables and color the patches to a base-color

  ask patches
  [
    set pcolor [245 245 200]

  ]

  ;; initialize the global variables that hold patch agentsets
  let br [ 11 -9 -11 9]
  ask patches with [ ( member? pycor br )] [ set pcolor brown set reward 0 ]
  let brr [-11 -9 ]
  ask patches with [ ( member? pxcor br )] [ set pcolor brown set reward 0 ]
  ;let a [ 1 2 3 6 7 8 11 12 13 16 17 18 21 22 23 26 27 28 (-2) (-3) (-4) (-7) (-8) (-9) (-12) (-13) (-14) (-17) (-18) (-19) (-22) (-23) (-24) (-27) (-28)]
  let a [10  30 -10 -30]
  ask patches with [ ( member? pxcor a )] [ set pcolor white set reward 0 ]

  ;let c [0 4 5 9 10 14 15 19 20 24 25 -1 -5 -6 -10 -11 -15 -16 -20 -21 -25 -26]
 let b [10 30 -10  -30]
  ;ask patches with [ (( member? pxcor c)) and (member? pycor b  )] [ set pcolor white set reward -1 ]
  ask patches with [(member? pycor b  )] [ set pcolor white set reward 0 ]

  let bordure_x [-27 27 ]
  let bordure_y [28 -28 ]
  ask patches with [(member? pxcor bordure_x  )] [ set pcolor brown set reward 0  ]
  ask patches with [(member? pycor bordure_y  )] [ set pcolor brown set reward 0 ]

end


to setup-globals
  set nb_trash 11
end



to-report bla
  report "c"
end

to setup
   clear-all
   set-current-plot "Ave Reward Per Episode"
   set-plot-y-range -10 10

   setup-globals
   setup-patches


  set-default-shape turtles "person"

  crt 1 [
          set color black
    set size 4]

  crt 1 [
          set shape "house"
    set xcor 4
    set ycor 5
    set color grey
    set size 4]
  crt 1 [
          set shape "house"
    set xcor -4
    set color grey
    set ycor -3
    set size 4]

  crt 1 [
          set shape "house"
    set xcor -4
    set ycor 5
    set size 3]

  crt 1 [
          set shape "tree"
    set xcor -2
    set ycor 22
    set size 3]
  crt 1 [
          set shape "tree"
    set xcor 0
    set ycor 22
    set size 3]
  crt 1 [
          set shape "tree"
    set xcor -1
    set ycor 20
    set size 3]

  crt 1 [
          set shape "Tree"
    set color cyan
    set xcor -20
    set ycor -19
    set size 5]
  crt 1 [
          set shape "plant"
    set color orange
    set xcor -17
    set ycor -16
    set size 5]

   crt 1 [
          set shape "plant"
    set color orange
    set xcor -17
    set ycor -22
    set size 5]
  crt 1 [
          set shape "plant"
    set color orange
    set xcor -24
    set ycor -18
    set size 5]

  set patch_color ([pcolor] of patch posx_initiale posy_initiale)

  ifelse (patch_color = white)
  [ask turtles with [shape = "person"][set xcor posx_initiale set ycor posy_initiale]
  set turtle_pos_x posx_initiale
  set turtle_pos_y posy_initiale
  ]
  [ask turtles with [shape = "person"][set xcor 10 set ycor -10]
  set turtle_pos_x 10
  set turtle_pos_y -10
  set posx_initiale 10
  set posy_initiale -10
  ]
  reward-function
  ask turtles with [shape = "leaf"][set reward 100 set plabel reward]
  ask turtle 0 [
    qlearningextension:state-def-extra [ "xcor" "ycor"][bla]
    (qlearningextension:actions [move_l] [move_r] [move_down] [move_top])
    qlearningextension:reward [rewardFunc]
    qlearningextension:end-episode [isEndState] resetEpisode
    qlearningextension:action-selection "e-greedy" [0.6 0.08]
    qlearningextension:learning-rate 1
    qlearningextension:discount-factor 0.75

    ; used to create the plot
    create-temporary-plot-pen (word who)
    set-plot-pen-color color
    set reward-list []
  ]


end

to-report rewardFunc
  set reward-list lput [reward] of patch-here reward-list
  report [reward] of patch-here
end


to move_r
  ifelse ([xcor] of turtle 0 < max-pxcor)
  [

  let pos_x_after_move (turtle_pos_x + 1)
  if ( [pcolor] of patch pos_x_after_move turtle_pos_y = white)
  [ask turtle 0 [set heading 90 fd 1]
  set turtle_pos_x ([xcor] of turtle 0)
  set turtle_pos_y ([ycor] of turtle 0)
  set patch_color ([pcolor] of patch turtle_pos_x turtle_pos_y)
  ask turtle 0 [let trash_count count trashs-here
  if (trash_count = 1)
  [ask patches with [ pxcor = turtle_pos_x and pycor = turtle_pos_y ][update-reward pxcor pycor]
          ask turtles with [ shape ="leaf" and xcor = turtle_pos_x and ycor = turtle_pos_y ][die]

        ask patches with [pxcor = turtle_pos_x and pycor = turtle_pos_y] [ set  reward 0  ]
         set nb_trash nb_trash - 1


        ]

    ]


    ]
  ]
  [show 1 ]
end


to move_l
  ifelse ([xcor] of turtle 0 < max-pxcor)
  [
    let pos_x_after_move (turtle_pos_x - 1)
  if ( [pcolor] of patch pos_x_after_move turtle_pos_y = white)
  [ask turtle 0 [set heading 90 fd -1]
  set turtle_pos_x ([xcor] of turtle 0)
  set turtle_pos_y ([ycor] of turtle 0)
  set patch_color ([pcolor] of patch turtle_pos_x turtle_pos_y) ]
  ask turtle 0 [let trash_count count trashs-here
  if (trash_count = 1)
  [ask patches with [ pxcor = turtle_pos_x and pycor = turtle_pos_y ][update-reward pxcor pycor]
        ask turtles with [ shape ="leaf" and xcor = turtle_pos_x and ycor = turtle_pos_y ][die]
        ask patches with [pxcor = turtle_pos_x and pycor = turtle_pos_y] [ set  reward 0 ]
        set nb_trash nb_trash - 1

      ]

    ]

  ]
  [show 1  ]
end

to move_top
  ifelse ( [ycor] of turtle 0 < max-pycor)
  [

  let pos_y_after_move (turtle_pos_y + 1)
  if ( [pcolor] of patch turtle_pos_x pos_y_after_move = white)
  [ask turtle 0 [set heading 0 fd 1]
  set turtle_pos_x ([xcor] of turtle 0)
  set turtle_pos_y ([ycor] of turtle 0)
  set patch_color ([pcolor] of patch turtle_pos_x turtle_pos_y) ]
  ask turtle 0 [let trash_count count trashs-here
  if (trash_count = 1)
      [ask patches with [ pxcor = turtle_pos_x and pycor = turtle_pos_y ][update-reward pxcor pycor]
        ask turtles with [ shape ="leaf" and xcor = turtle_pos_x and ycor = turtle_pos_y ][die]
        ask patches with [pxcor = turtle_pos_x and pycor = turtle_pos_y] [ set  reward 0 ]
        set nb_trash nb_trash - 1
    ]]


  ]
  [show 1 ]
end

to move_down
  ;show patch-here
  ;show breed
  ifelse ( [ycor] of turtle 0 < max-pycor)
  [let pos_y_after_move (turtle_pos_y - 1)
  if ( [pcolor] of patch  turtle_pos_x pos_y_after_move = white)
  [ask turtle 0 [set heading 0 fd -1]
  set turtle_pos_x ([xcor] of turtle 0)
  set turtle_pos_y ([ycor] of turtle 0)
  set patch_color ([pcolor] of patch turtle_pos_x turtle_pos_y) ]
  ask turtle 0 [let trash_count count trashs-here
  if (trash_count = 1)
      [ask patches with [ pxcor = turtle_pos_x and pycor = turtle_pos_y ][update-reward pxcor pycor]
        ask turtles with [ shape ="leaf" and xcor = turtle_pos_x and ycor = turtle_pos_y ][die]
        ask patches with [pxcor = turtle_pos_x and pycor = turtle_pos_y] [ set  reward 0 ]
        set nb_trash nb_trash - 1
        ;show nb_trash
      ]

    ]


  ]
  [show 1 ]
end

to init_fire
  ask one-of patches with [not any? fires-here and pcolor != blue][sprout 1 [set breed fires
    set shape "fire" set color orange set size 2.25] ]

end


to init_trash
  let x_trash [-10 -2 10 10 -23 -10 -6 -16 18 -10 10 ]
  let y_trash [10 10 10 23 10 24 -10 -10 -10 -21 -17]
  let i 0
  while  [i < 11]
  [ ;ask one-of patches with [not any? trashs-here and pcolor != brown + 3 ][sprout 1 [set breed trashs
    ;set shape "leaf" set color green set size 2.25 set reward 5] ]
    ask patches with [ pxcor = item i x_trash and pycor = item i y_trash ][sprout 1 [set breed trashs
      set shape "leaf" set color green set size 3 set reward 100 ]]
    set i i + 1
  ]

end

;;to init_box
    ;;ask one-of patches with [not any? boxes-here and pcolor = white and floor(pxcor) = 28 or floor(pycor) = 27 ][sprout 1 [set breed boxes
    ;;set shape "box" set color black set size 2.25] ]
;;end


to-report isEndState
  if nb_trash = 0 [
    report true
  ]
  report false
end

to resetEpisode
  set turtle_pos_x posx_initiale
  set turtle_pos_y posy_initiale
  set patch_color white
  set nb_trash 11

  init_trash
  reward-function
  ask turtles with [shape = "leaf"][set reward 100]
  ; used to update the plot
  let rew-sum 0
  let length-rew 0

  foreach reward-list [ r ->
    set rew-sum rew-sum + r
    set length-rew length-rew + 1
  ]
  let avg-rew rew-sum / length-rew

  set-current-plot-pen (word who)
  plot avg-rew
  set reward-list []
end


to reward-function
  let x_trash [-10 -2 10 10 -23 -10 -6 -16 18 -10 10 ]
  let y_trash [10 10 10 23 10 24 -10 -10 -10 -21 -17]
  let i 0
  let k 1
  let j 1
  let list_reward [10 7 5  2]
  while  [i < 11]
  [
       while [ k < 4 ]
      [ask patches with [ ( pxcor = item i x_trash - j   and pycor = item i y_trash and pcolor = white ) ][set reward item k list_reward] set k k + 1 set j j + 1  ]
      set k 0
      set j 1
      while [ k < 4 ]
      [ask patches with [ ( pxcor = item i x_trash + j   and pycor = item i y_trash and pcolor = white) ][ set reward item k list_reward ] set k k + 1 set j j + 1
      ]
      set k 0
      set j 1
      while [ k < 4 ]
      [ask patches with [ ( pxcor = item i x_trash  and pycor = item i y_trash - j  and pcolor = white) ][set reward item k list_reward] set k k + 1 set j j + 1 ]

      set k 0
      set j 1
      while [ k < 4 ]
    [ask patches with [ ( pxcor = item i x_trash  and pycor = item i y_trash + j  and pcolor = white) ][set reward item k list_reward] set k k + 1 set j j + 1 ]
    set k 0
    set j 1
      set i i + 1
  ]
end

to update-reward [ x y ]
  let k 0
  while [ k < 10 ]
      [ask patches with [ ( pxcor = x - k  and pycor = y and pcolor = white) ][ set reward 0]set k k + 1]
  set k 0
  while [ k < 10 ]
      [ask patches with [ ( pxcor = x + k  and pycor = y and pcolor = white) ][ set reward 0] set k k + 1
      ]
  set k 0
  while [ k < 10 ]
      [ask patches with [ ( pxcor = x  and pycor = y - k and pcolor = white) ][ set reward 0] set k k + 1]

  set k 0
  while [ k < 10 ]
      [ask patches with [ ( pxcor = x  and pycor = y + k and pcolor = white) ][set reward 0] set k k + 1 ]
end

to go
  ask turtle 0 [
    qlearningextension:learning
    ;print(qlearningextension:get-qtable)
  ]
end
@#$#@#$#@
GRAPHICS-WINDOW
383
15
937
590
-1
-1
9.93
1
12
1
1
1
0
0
0
1
-27
27
-28
28
0
0
1
ticks
30.0

BUTTON
10
161
94
194
Setup
setup
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

BUTTON
201
310
290
343
Right
Move_r
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

TEXTBOX
196
239
346
257
NIL
11
0.0
1

BUTTON
115
160
198
193
Trash
init_trash\n
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

BUTTON
224
161
297
194
Fire
init_fire
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

INPUTBOX
7
36
168
96
posx_initiale
10.0
1
0
Number

INPUTBOX
186
41
347
101
posy_initiale
-10.0
1
0
Number

BUTTON
5
312
84
345
Left
Move_l
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

BUTTON
91
272
192
305
Top
move_top\n
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

BUTTON
89
350
202
383
Down
Move_down
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

BUTTON
106
465
169
498
NIL
go
T
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

PLOT
1009
23
1456
321
Ave Reward Per Episode
NIL
NIL
0.0
10.0
0.0
10.0
true
false
"" ""
PENS
"default" 1.0 0 -16777216 true "" "plot count turtles"

@#$#@#$#@
## WHAT IS IT?

This is a model of traffic moving in a city grid. It allows you to control traffic lights and global variables, such as the speed limit and the number of cars, and explore traffic dynamics.

Try to develop strategies to improve traffic and to understand the different ways to measure the quality of traffic.

## HOW IT WORKS

Each time step, the cars attempt to move forward at their current speed.  If their current speed is less than the speed limit and there is no car directly in front of them, they accelerate.  If there is a slower car in front of them, they match the speed of the slower car and deccelerate.  If there is a red light or a stopped car in front of them, they stop.

There are two different ways the lights can change.  First, the user can change any light at any time by making the light current, and then clicking CHANGE LIGHT.  Second, lights can change automatically, once per cycle.  Initially, all lights will automatically change at the beginning of each cycle.

## HOW TO USE IT

Change the traffic grid (using the sliders GRID-SIZE-X and GRID-SIZE-Y) to make the desired number of lights.  Change any other of the settings that you would like to change.  Press the SETUP button.

At this time, you may configure the lights however you like, with any combination of auto/manual and any phase. Changes to the state of the current light are made using the CURRENT-AUTO?, CURRENT-PHASE and CHANGE LIGHT controls.  You may select the current intersection using the SELECT INTERSECTION control.  See below for details.

Start the simulation by pressing the GO button.  You may continue to make changes to the lights while the simulation is running.

### Buttons

SETUP - generates a new traffic grid based on the current GRID-SIZE-X and GRID-SIZE-Y and NUM-CARS number of cars.  This also clears all the plots. All lights are set to auto, and all phases are set to 0.
GO - runs the simulation indefinitely
CHANGE LIGHT - changes the direction traffic may flow through the current light. A light can be changed manually even if it is operating in auto mode.
SELECT INTERSECTION - allows you to select a new "current" light. When this button is depressed, click in the intersection which you would like to make current. When you've selected an intersection, the "current" label will move to the new intersection and this button will automatically pop up.

### Sliders

SPEED-LIMIT - sets the maximum speed for the cars
NUM-CARS - the number of cars in the simulation (you must press the SETUP button to see the change)
TICKS-PER-CYCLE - sets the number of ticks that will elapse for each cycle.  This has no effect on manual lights.  This allows you to increase or decrease the granularity with which lights can automatically change.
GRID-SIZE-X - sets the number of vertical roads there are (you must press the SETUP button to see the change)
GRID-SIZE-Y - sets the number of horizontal roads there are (you must press the SETUP button to see the change)
CURRENT-PHASE - controls when the current light changes, if it is in auto mode. The slider value represents the percentage of the way through each cycle at which the light should change. So, if the TICKS-PER-CYCLE is 20 and CURRENT-PHASE is 75%, the current light will switch at tick 15 of each cycle.

### Switches

POWER? - toggles the presence of traffic lights
CURRENT-AUTO? - toggles the current light between automatic mode, where it changes once per cycle (according to CURRENT-PHASE), and manual, in which you directly control it with CHANGE LIGHT.

### Plots

STOPPED CARS - displays the number of stopped cars over time
AVERAGE SPEED OF CARS - displays the average speed of cars over time
AVERAGE WAIT TIME OF CARS - displays the average time cars are stopped over time

## THINGS TO NOTICE

When cars have stopped at a traffic light, and then they start moving again, the traffic jam will move backwards even though the cars are moving forwards.  Why is this?

When POWER? is turned off and there are quite a few cars on the roads, "gridlock" usually occurs after a while.  In fact, gridlock can be so severe that traffic stops completely.  Why is it that no car can move forward and break the gridlock?  Could this happen in the real world?

Gridlock can occur when the power is turned on, as well.  What kinds of situations can lead to gridlock?

## THINGS TO TRY

Try changing the speed limit for the cars.  How does this affect the overall efficiency of the traffic flow?  Are fewer cars stopping for a shorter amount of time?  Is the average speed of the cars higher or lower than before?

Try changing the number of cars on the roads.  Does this affect the efficiency of the traffic flow?

How about changing the speed of the simulation?  Does this affect the efficiency of the traffic flow?

Try running this simulation with all lights automatic.  Is it harder to make the traffic move well using this scheme than controlling one light manually?  Why?

Try running this simulation with all lights automatic.  Try to find a way of setting the phases of the traffic lights so that the average speed of the cars is the highest.  Now try to minimize the number of stopped cars.  Now try to decrease the average wait time of the cars.  Is there any correlation between these different metrics?

## EXTENDING THE MODEL

Currently, the maximum speed limit (found in the SPEED-LIMIT slider) for the cars is 1.0.  This is due to the fact that the cars must look ahead the speed that they are traveling to see if there are cars ahead of them.  If there aren't, they speed up.  If there are, they slow down.  Looking ahead for a value greater than 1 is a little bit tricky.  Try implementing the correct behavior for speeds greater than 1.

When a car reaches the edge of the world, it reappears on the other side.  What if it disappeared, and if new cars entered the city at random locations and intervals?

## NETLOGO FEATURES

This model uses two forever buttons which may be active simultaneously, to allow the user to select a new current intersection while the model is running.

It also uses a chooser to allow the user to choose between several different possible plots, or to display all of them at once.

## RELATED MODELS

- "Traffic Basic": a simple model of the movement of cars on a highway.

- "Traffic Basic Utility": a version of "Traffic Basic" including a utility function for the cars.

- "Traffic Basic Adaptive": a version of "Traffic Basic" where cars adapt their acceleration to try and maintain a smooth flow of traffic.

- "Traffic Basic Adaptive Individuals": a version of "Traffic Basic Adaptive" where each car adapts individually, instead of all cars adapting in unison.

- "Traffic 2 Lanes": a more sophisticated two-lane version of the "Traffic Basic" model.

- "Traffic Intersection": a model of cars traveling through a single intersection.

- "Traffic Grid Goal": a version of "Traffic Grid" where the cars have goals, namely to drive to and from work.

- "Gridlock HubNet": a version of "Traffic Grid" where students control traffic lights in real-time.

- "Gridlock Alternate HubNet": a version of "Gridlock HubNet" where students can enter NetLogo code to plot custom metrics.

## HOW TO CITE

If you mention this model or the NetLogo software in a publication, we ask that you include the citations below.

For the model itself:

* Wilensky, U. (2003).  NetLogo Traffic Grid model.  http://ccl.northwestern.edu/netlogo/models/TrafficGrid.  Center for Connected Learning and Computer-Based Modeling, Northwestern University, Evanston, IL.

Please cite the NetLogo software as:

* Wilensky, U. (1999). NetLogo. http://ccl.northwestern.edu/netlogo/. Center for Connected Learning and Computer-Based Modeling, Northwestern University, Evanston, IL.

## COPYRIGHT AND LICENSE

Copyright 2003 Uri Wilensky.

![CC BY-NC-SA 3.0](http://ccl.northwestern.edu/images/creativecommons/byncsa.png)

This work is licensed under the Creative Commons Attribution-NonCommercial-ShareAlike 3.0 License.  To view a copy of this license, visit https://creativecommons.org/licenses/by-nc-sa/3.0/ or send a letter to Creative Commons, 559 Nathan Abbott Way, Stanford, California 94305, USA.

Commercial licenses are also available. To inquire about commercial licenses, please contact Uri Wilensky at uri@northwestern.edu.

This model was created as part of the projects: PARTICIPATORY SIMULATIONS: NETWORK-BASED DESIGN FOR SYSTEMS LEARNING IN CLASSROOMS and/or INTEGRATED SIMULATION AND MODELING ENVIRONMENT. The project gratefully acknowledges the support of the National Science Foundation (REPP & ROLE programs) -- grant numbers REC #9814682 and REC-0126227.

<!-- 2003 -->
@#$#@#$#@
default
true
0
Polygon -7500403 true true 150 5 40 250 150 205 260 250

airplane
true
0
Polygon -7500403 true true 150 0 135 15 120 60 120 105 15 165 15 195 120 180 135 240 105 270 120 285 150 270 180 285 210 270 165 240 180 180 285 195 285 165 180 105 180 60 165 15

arrow
true
0
Polygon -7500403 true true 150 0 0 150 105 150 105 293 195 293 195 150 300 150

box
false
0
Polygon -7500403 true true 150 285 285 225 285 75 150 135
Polygon -7500403 true true 150 135 15 75 150 15 285 75
Polygon -7500403 true true 15 75 15 225 150 285 150 135
Line -16777216 false 150 285 150 135
Line -16777216 false 150 135 15 75
Line -16777216 false 150 135 285 75

bug
true
0
Circle -7500403 true true 96 182 108
Circle -7500403 true true 110 127 80
Circle -7500403 true true 110 75 80
Line -7500403 true 150 100 80 30
Line -7500403 true 150 100 220 30

butterfly
true
0
Polygon -7500403 true true 150 165 209 199 225 225 225 255 195 270 165 255 150 240
Polygon -7500403 true true 150 165 89 198 75 225 75 255 105 270 135 255 150 240
Polygon -7500403 true true 139 148 100 105 55 90 25 90 10 105 10 135 25 180 40 195 85 194 139 163
Polygon -7500403 true true 162 150 200 105 245 90 275 90 290 105 290 135 275 180 260 195 215 195 162 165
Polygon -16777216 true false 150 255 135 225 120 150 135 120 150 105 165 120 180 150 165 225
Circle -16777216 true false 135 90 30
Line -16777216 false 150 105 195 60
Line -16777216 false 150 105 105 60

car
true
0
Polygon -7500403 true true 180 15 164 21 144 39 135 60 132 74 106 87 84 97 63 115 50 141 50 165 60 225 150 285 165 285 225 285 225 15 180 15
Circle -16777216 true false 180 30 90
Circle -16777216 true false 180 180 90
Polygon -16777216 true false 80 138 78 168 135 166 135 91 105 106 96 111 89 120
Circle -7500403 true true 195 195 58
Circle -7500403 true true 195 47 58

circle
false
0
Circle -7500403 true true 0 0 300

circle 2
false
0
Circle -7500403 true true 0 0 300
Circle -16777216 true false 30 30 240

cow
false
0
Polygon -7500403 true true 200 193 197 249 179 249 177 196 166 187 140 189 93 191 78 179 72 211 49 209 48 181 37 149 25 120 25 89 45 72 103 84 179 75 198 76 252 64 272 81 293 103 285 121 255 121 242 118 224 167
Polygon -7500403 true true 73 210 86 251 62 249 48 208
Polygon -7500403 true true 25 114 16 195 9 204 23 213 25 200 39 123

cylinder
false
0
Circle -7500403 true true 0 0 300

dot
false
0
Circle -7500403 true true 90 90 120

face happy
false
0
Circle -7500403 true true 8 8 285
Circle -16777216 true false 60 75 60
Circle -16777216 true false 180 75 60
Polygon -16777216 true false 150 255 90 239 62 213 47 191 67 179 90 203 109 218 150 225 192 218 210 203 227 181 251 194 236 217 212 240

face neutral
false
0
Circle -7500403 true true 8 7 285
Circle -16777216 true false 60 75 60
Circle -16777216 true false 180 75 60
Rectangle -16777216 true false 60 195 240 225

face sad
false
0
Circle -7500403 true true 8 8 285
Circle -16777216 true false 60 75 60
Circle -16777216 true false 180 75 60
Polygon -16777216 true false 150 168 90 184 62 210 47 232 67 244 90 220 109 205 150 198 192 205 210 220 227 242 251 229 236 206 212 183

fire
false
0
Polygon -7500403 true true 151 286 134 282 103 282 59 248 40 210 32 157 37 108 68 146 71 109 83 72 111 27 127 55 148 11 167 41 180 112 195 57 217 91 226 126 227 203 256 156 256 201 238 263 213 278 183 281
Polygon -955883 true false 126 284 91 251 85 212 91 168 103 132 118 153 125 181 135 141 151 96 185 161 195 203 193 253 164 286
Polygon -2674135 true false 155 284 172 268 172 243 162 224 148 201 130 233 131 260 135 282

fish
false
0
Polygon -1 true false 44 131 21 87 15 86 0 120 15 150 0 180 13 214 20 212 45 166
Polygon -1 true false 135 195 119 235 95 218 76 210 46 204 60 165
Polygon -1 true false 75 45 83 77 71 103 86 114 166 78 135 60
Polygon -7500403 true true 30 136 151 77 226 81 280 119 292 146 292 160 287 170 270 195 195 210 151 212 30 166
Circle -16777216 true false 215 106 30

flag
false
0
Rectangle -7500403 true true 60 15 75 300
Polygon -7500403 true true 90 150 270 90 90 30
Line -7500403 true 75 135 90 135
Line -7500403 true 75 45 90 45

flower
false
0
Polygon -10899396 true false 135 120 165 165 180 210 180 240 150 300 165 300 195 240 195 195 165 135
Circle -7500403 true true 85 132 38
Circle -7500403 true true 130 147 38
Circle -7500403 true true 192 85 38
Circle -7500403 true true 85 40 38
Circle -7500403 true true 177 40 38
Circle -7500403 true true 177 132 38
Circle -7500403 true true 70 85 38
Circle -7500403 true true 130 25 38
Circle -7500403 true true 96 51 108
Circle -16777216 true false 113 68 74
Polygon -10899396 true false 189 233 219 188 249 173 279 188 234 218
Polygon -10899396 true false 180 255 150 210 105 210 75 240 135 240

food
false
0
Polygon -7500403 true true 30 105 45 255 105 255 120 105
Rectangle -7500403 true true 15 90 135 105
Polygon -7500403 true true 75 90 105 15 120 15 90 90
Polygon -7500403 true true 135 225 150 240 195 255 225 255 270 240 285 225 150 225
Polygon -7500403 true true 135 180 150 165 195 150 225 150 270 165 285 180 150 180
Rectangle -7500403 true true 135 195 285 210

house
false
0
Rectangle -7500403 true true 45 120 255 285
Rectangle -16777216 true false 120 210 180 285
Polygon -7500403 true true 15 120 150 15 285 120
Line -16777216 false 30 120 270 120

leaf
false
0
Polygon -7500403 true true 150 210 135 195 120 210 60 210 30 195 60 180 60 165 15 135 30 120 15 105 40 104 45 90 60 90 90 105 105 120 120 120 105 60 120 60 135 30 150 15 165 30 180 60 195 60 180 120 195 120 210 105 240 90 255 90 263 104 285 105 270 120 285 135 240 165 240 180 270 195 240 210 180 210 165 195
Polygon -7500403 true true 135 195 135 240 120 255 105 255 105 285 135 285 165 240 165 195

line
true
0
Line -7500403 true 150 0 150 300

line half
true
0
Line -7500403 true 150 0 150 150

pentagon
false
0
Polygon -7500403 true true 150 15 15 120 60 285 240 285 285 120

person
false
0
Circle -7500403 true true 110 5 80
Polygon -7500403 true true 105 90 120 195 90 285 105 300 135 300 150 225 165 300 195 300 210 285 180 195 195 90
Rectangle -7500403 true true 127 79 172 94
Polygon -7500403 true true 195 90 240 150 225 180 165 105
Polygon -7500403 true true 105 90 60 150 75 180 135 105

plant
false
0
Rectangle -7500403 true true 135 90 165 300
Polygon -7500403 true true 135 255 90 210 45 195 75 255 135 285
Polygon -7500403 true true 165 255 210 210 255 195 225 255 165 285
Polygon -7500403 true true 135 180 90 135 45 120 75 180 135 210
Polygon -7500403 true true 165 180 165 210 225 180 255 120 210 135
Polygon -7500403 true true 135 105 90 60 45 45 75 105 135 135
Polygon -7500403 true true 165 105 165 135 225 105 255 45 210 60
Polygon -7500403 true true 135 90 120 45 150 15 180 45 165 90

square
false
0
Rectangle -7500403 true true 30 30 270 270

square 2
false
0
Rectangle -7500403 true true 30 30 270 270
Rectangle -16777216 true false 60 60 240 240

star
false
0
Polygon -7500403 true true 151 1 185 108 298 108 207 175 242 282 151 216 59 282 94 175 3 108 116 108

target
false
0
Circle -7500403 true true 0 0 300
Circle -16777216 true false 30 30 240
Circle -7500403 true true 60 60 180
Circle -16777216 true false 90 90 120
Circle -7500403 true true 120 120 60

tree
false
0
Circle -7500403 true true 118 3 94
Rectangle -6459832 true false 120 195 180 300
Circle -7500403 true true 65 21 108
Circle -7500403 true true 116 41 127
Circle -7500403 true true 45 90 120
Circle -7500403 true true 104 74 152

triangle
false
0
Polygon -7500403 true true 150 30 15 255 285 255

triangle 2
false
0
Polygon -7500403 true true 150 30 15 255 285 255
Polygon -16777216 true false 151 99 225 223 75 224

truck
false
0
Rectangle -7500403 true true 4 45 195 187
Polygon -7500403 true true 296 193 296 150 259 134 244 104 208 104 207 194
Rectangle -1 true false 195 60 195 105
Polygon -16777216 true false 238 112 252 141 219 141 218 112
Circle -16777216 true false 234 174 42
Rectangle -7500403 true true 181 185 214 194
Circle -16777216 true false 144 174 42
Circle -16777216 true false 24 174 42
Circle -7500403 false true 24 174 42
Circle -7500403 false true 144 174 42
Circle -7500403 false true 234 174 42

turtle
true
0
Polygon -10899396 true false 215 204 240 233 246 254 228 266 215 252 193 210
Polygon -10899396 true false 195 90 225 75 245 75 260 89 269 108 261 124 240 105 225 105 210 105
Polygon -10899396 true false 105 90 75 75 55 75 40 89 31 108 39 124 60 105 75 105 90 105
Polygon -10899396 true false 132 85 134 64 107 51 108 17 150 2 192 18 192 52 169 65 172 87
Polygon -10899396 true false 85 204 60 233 54 254 72 266 85 252 107 210
Polygon -7500403 true true 119 75 179 75 209 101 224 135 220 225 175 261 128 261 81 224 74 135 88 99

wheel
false
0
Circle -7500403 true true 3 3 294
Circle -16777216 true false 30 30 240
Line -7500403 true 150 285 150 15
Line -7500403 true 15 150 285 150
Circle -7500403 true true 120 120 60
Line -7500403 true 216 40 79 269
Line -7500403 true 40 84 269 221
Line -7500403 true 40 216 269 79
Line -7500403 true 84 40 221 269

x
false
0
Polygon -7500403 true true 270 75 225 30 30 225 75 270
Polygon -7500403 true true 30 75 75 30 270 225 225 270
@#$#@#$#@
NetLogo 6.2.0
@#$#@#$#@
@#$#@#$#@
@#$#@#$#@
@#$#@#$#@
@#$#@#$#@
default
0.0
-0.2 0 0.0 1.0
0.0 1 1.0 0.0
0.2 0 0.0 1.0
link direction
true
0
Line -7500403 true 150 150 90 180
Line -7500403 true 150 150 210 180
@#$#@#$#@
0
@#$#@#$#@
