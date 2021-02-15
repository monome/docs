---
layout: default
nav_exclude: true
permalink: /norns/study-0/

---

<div class="vid"><iframe src="https://player.vimeo.com/video/503167191?color=ffffff&title=0&byline=0&portrait=0" width="860" height="484" frameborder="0" webkitallowfullscreen mozallowfullscreen allowfullscreen></iframe></div>

# first light

before study, learning to see.

## who am i

we have ideas about what it means to be a musician and what it means to be a programmer, and these ideas shape how we approach instruments and code.

norns is a platform for customizing and creating sound instruments with code.

while norns can be used to craft ambitious sonic toolkits, it can also be used to create small compositional moments.

this study aims to show the musician the power of editing a few lines of code, and the programmer that sound can be explored playfully.

## a short journey

run _firstlight_. (if you don't have it, download it via the maiden project manager in the `base` collection.)

it's a simple delay effect with a sequencer which modulates the loop length. a wind-chime synth plays, which you can toggle with K3. you can also play sound into the audio input.

sit, listen.

...

ok let's edit something now. get norns connected to [wifi](../wifi-files) and open [maiden](../maiden).

## the code is alive

click on the `>>` bar at the bottom of maiden. this is where you enter commands. the script we're running can manipulated in real time, and that's what we'll do now. try this:

```
engine.hz(700)
```

this plays 700hz tone. (you might want to toggle off the wind-chimes first). try different numbers. (you may also enjoy reading about [music and math](https://en.wikipedia.org/wiki/Music_and_mathematics)).

`softcut` is the digital tape system in norns, which this script sets up as a delay line on the first voice (hence the `1` in the command). the following command changes the feedback level 0.95:

```
softcut.pre_level(1,0.95)
```

(careful, setting this value greater than 1.0 can eventually create very loud sounds!)

toggle off the sequencer (K2) and try each of these, one at a time:

```
softcut.rate(1,2.0)
softcut.rate(1,1.0)
softcut.rate(1,0.5)
```

the sequencer is synchronized to the global clock. you can change the clock settings via the PARAMS menu, but you can also act upon the clock this way:

```
params:set('clock_tempo',50)
```

the script itself has some simple variables that can be changed on the fly, for example:

```
chimes = false
length = 16
numbers[1] = 0
```

some other things to try:

```
engine.pw(0.2)
engine.cutoff(300)
engine.release(2.0)
softcut.rate_slew_time(1,0.1)
```

## make it so

entering commands as we did above changes the running state of the script, but the system doesn't remember these changes if you restart. so, let's edit the actual script so we can load our customized version.

you might want to make a copy of the original file, which you can do with the `duplicate` icon in maiden. you can then rename your new version of the file.

let's change some defaults when the scripts starts:

- different synth sound
- more delay feedback
- different and more chime

see line 78:

```
engine.release(1)
engine.pw(0.5)
engine.cutoff(1000)
```

these are the synth parameters that get set at startup. try changing the numbers, save the file, then re-launch the script using the PLAY arrow in maiden or using the menu on the hardware.

line 100 sets the delay feedback.

line 62 is the table of notes. in this case the table is a list of numbers, separated by commas and enclosed by braces:

```
notes = {400,451,525,555}
```

the notes are frequencies, just like we called with `engine.hz(700)`. try changing the values of the table, and also adding additional notes. the chime player can handle different table lengths.

## now differently

now that we've successfully changed the defaults, let's do some small changes that alter how the script actually works.

### clock by hand

instead of having the sequencer run on a clock, let's have it step forward every time we push K2.

first, let's disable the sequence clock, on line 32:

```
sequence = false
```

now, when the clock ticks, line 43 shows that the function `step()` will not be run. (by the way, we can type `step()` into the maiden REPL to advance the sequencer!)

let's edit what happens when K2 gets pressed, on line 151:

```
-- sequence = not sequence
step()
```

add two dashes to comment-out the sequence toggle, which deactivates this line of code. then add `step()`. save and re-run. now K2 advances the sequencer!

### play a random note

instead of chimes, let's have K3 play a random tone.

first, let's disable the chimes, on line 33:

```
chimes = false
```

on line 148 we disable the chimes toggle. after this line we add a command to play a random frequency between 100 and 600.

```
-- chimes = not chimes
engine.hz(math.random(100,600))
```

save at try it out.

let's make a change so that it plays notes from a table instead. erase the `engine.hz` line and do this instead:

```
basket = {80,201,400,555,606}
engine.hz(basket[math.random(#basket)])
```

`basket` can be any length: add more frequencies separated by commas. `math.random(x)` makes a random number from `1` to `x`. `basket[x]` gets the `x` element of the table, so `basket[1]` would be `80`. this gets passed to `engine.hz()` and the note gets played!

### even strum

instead of a windy chime with variation, let's have the wind make a regular strum. make sure line 33 is turned back on: `chimes = true`.

see line 64:

```
if math.random() > 0.2 then
  engine.hz(table.remove(notes,math.random(#notes)))
end
```

what this bit does:

- make a random number between 0.0 and 1.0
- if it is less than 0.2 then
- get a random value from the `note` table and remove it
- play this note

this creates the nice random scattered effect and creates uneven timing, with no single note played twice.

let's comment out these three lines (with `--` in front) and make it more regular:

```
engine.hz(table.remove(notes,1))
```

this simpler line just gets the first element of the table and removes it, so the notes get played in order.

try changing the strum speed by altering:

```
clock.sleep(0.05)
```

and you can change how frequently the strum happens by changing this line:

```
clock.sleep(math.random(3,9))
```

as is, the strum will happen randomly every 3-9 seconds.

### sequence weirder

the sequencer step values can be used for any number of things. instead of modulating the loop time, let's modulate the delay rate, which will re-pitch the delay line wildly.

see line 52:

```
softcut.loop_end(1,numbers[pos]/8)
```

- `numbers` is a table (line 25) that gets updated with the knob interface. it's the sequencer data, which is basically up to 16 steps of values 1-8.
- `pos` is the playback position. line 50 advances the position by adding 1 and maybe wrapping back to the start. (hint: try changing `pos+1` to `pos-1` to make it run backwards!)
- we're dividing the step value by 8, hence setting the `loop_end` to between 1/8 and 1.0 (8/8).

let's comment out this line and modulate `rate` instead:

```
--softcut.loop_end(1,numbers[pos]/8)
softcut.rate(1,numbers[pos]/8)
```

save and try! since the rate jumps are very large the result is substantial. let's try making it more subtle:

```
softcut.rate(1,1+(numbers[pos]/64))
```

this confines the numbers to a smaller range for a subtler effect. or perhaps we'd like to try something with multiples:

```
rates = {-1.0,-0.5,0.25,0.5,1.0,1.5,2.0,3.0}
softcut.rate(1,rates[numbers[pos]])
```

we've made a table `rates` which has 8 elements, letting us map the range of each step. this set of numbers contains a bunch of octaves which can create sparkly-delays. it also contains negative numbers which make for some nice reversals.

try setting `softcut.rate_slew_time(1,0)` down around line 98, which will make rate changes instantaneous rather than sliding.

## from here

suggested exercise:

- have the sequencer play notes using `engine.hz()`
- create a table to specify which frequencies get played. consider [just intonation](https://en.wikipedia.org/wiki/Just_intonation)
- randomize `x` for `engine.pw(x)` on each sequencer step
- have K2 toggle delay feedback (`pre_level`) between `0.8` and `1.0` 
- have K3 cycle delay speed with a table `{-1.0,0.5,1.0}`

and then on to [study 1: many tomorrows](../study-1) for a more in-depth scripting journey.

## resources

- [script reference](../reference) - list of commands and how to use them
