#!/bin/bash
for img in `ls *.png`
do
  magick convert $img -gamma 1.25 -filter point -resize 400% -gravity center -background black -extent 120% $img
done