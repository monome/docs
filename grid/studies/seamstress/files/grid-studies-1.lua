-- grid studies: seamstress
-- grid-study-1.lua

g = grid.connect()

function g.key(x,y,z)
  g:led(x, y, z * 15)
  g:refresh()
end