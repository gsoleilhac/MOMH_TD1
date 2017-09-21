using Combinatorics
import Base.<=
immutable Solution
    x::Vector{Int}
    y1::Int
    y2::Int
    y3::Int
end
<=(a1,a2,a3,b1,b2,b3) = a1<=b1 && a2<=b2 && a3<=b3 && (a1<b1 || a2<b2 || a3<b3)
<=(a::Solution, b::Solution) = <=(a.y1, a.y2, a.y3, b.y1, b.y2, b.y3)

C1 = [2 5 4 7 ; 3 3 5 7 ; 3 8 4 2 ; 6 5 2 5]
C2 = [3 3 6 2 ; 5 3 7 3 ; 5 2 7 4 ; 4 6 3 5]
C3 = [4 2 5 3 ; 5 3 4 3 ; 4 3 5 2 ; 6 4 7 3]

z(x, C) = begin
	y = 0
	for i = 1:length(x)
		y += C[i, x[i]]
	end
	y
end


Solution(x) = Solution(x, z(x, C1), z(x, C2), z(x, C3))


YDom = Solution[]
YN = Solution[]
for p in permutations([1,2,3,4])
    s = Solution(p)
    if !any(elt -> elt <= s, YN)
        push!(YN, s)
        filter!(elt -> !(elt >= s), YN)
    else
        push!(YDom, s)
    end
end

using PyPlot
plot3D([0], [0], [0], "go");
plot3D(map(e->e.y1, YN), map(e->e.y2, YN), map(e->e.y3, YN), "bo");
plot3D(map(e->e.y1, YDom), map(e->e.y2, YDom), map(e->e.y3, YDom), "rx");
!isinteractive() && show()


