import Data.List

rtriangle lim = [[a,b,c] | a <- [1..lim], b <- [1..a], c <- [1..b], a^2 == c^2 + b^2]

squares lim = [i^2 | i <- [1..lim], 0 == (rem (i^2) 5)]

coords lim = [[a,b]| a <- [1..lim], b <- [1..lim]]
