x = 2
y = 7
z = 10 + choose(x > y, 3, choose(y >= 7, y * 2, 0)) * 3
say "z=", z
