z1(x) = x^2
z2(x) = (x-2)^2

struct Solution
	x::Float64
	z1::Float64
 	z2::Float64
end
Solution(x) = Solution(x, z1(x), z2(x))

import Base.<=
<=(a1,a2,b1,b2) = a1 <= b1  && a2 < b2 || a1 < b1 && a2 <= b2
<=(a::Solution, b::Solution) = <=(a.z1, a.z2, b.z1, b.z2)


const YN = Solution[]
for i = 1:10000
	x = rand()*20 - 10
	s = Solution(x)
	if !any(elt -> elt <= s, YN) #if ⁠¬(∃e ∈ YN | e <= s)
		push!(YN, s) #add s to YN
		filter!(elt -> !(elt >= s), YN) #keep only e in YN | ¬(s<=e)
	end
end


using PyPlot
plot(map(x->x.z1, YN), map(x -> x.z2, YN), "rx")
!isinteractive() && show()