f1(x1, x2) = -(3(1-x1)^2 * exp(-x1^2 - (x2+1)^2) - 10(x1/5 - x1^3 - x2^5) * exp(-x1^2-x2^2) -3exp(-(x1+2)^2 - x2^2 + x1 + x2/2))
f2(x1, x2) = -(3(1+x2)^2 * exp(-x2^2 - (1-x1)^2) - 10(-x2/5 + x2^3 + x1^5) * exp(-x1^2-x2^2) - 3exp(-(2-x2)^2 - x1^2))

struct Solution
    x1::Float64
    x2::Float64
    y1::Float64
    y2::Float64
end
Solution(x1, x2) = Solution(x1, x2, f1(x1, x2), f2(x1, x2))

import Base.<=
<=(a1,a2,b1,b2) = a1 <= b1  && a2 < b2 || a1 < b1 && a2 <= b2
<=(a::Solution, b::Solution) = <=(a.y1, a.y2, b.y1, b.y2)

function orientation(p::Solution, q::Solution, r::Solution)
    val = (q.y2 - p.y2) * (r.y1 - q.y1) - (q.y1 - p.y1) * (r.y2 - q.y2)
    val == 0 && return 0
    (val > 0) ? 1 : 2
end

function convexHull(YN)
    n = length(YN)
    @assert n >= 3
    p = l = indmin(map(e->e.y1, YN)) #Find the leftmost point
    hull = Int[]
    while true
        push!(hull, p) #Add current point to result
        q = (p%n) + 1
        for i = 1:n
           if orientation(YN[p], YN[i], YN[q]) == 2
               q = i
           end
        end
        p = q
        p == l && break
    end
    return YN[hull]
end

YN = Solution[]
for i = 1:10000
    x1, x2 = 6 * rand() - 3, 6 * rand() - 3
    s = Solution(x1, x2, f1(x1, x2), f2(x1, x2))
    if !any(elt -> elt <= s, YN)
        push!(YN, s)
        filter!(elt -> !(elt >= s), YN)
    end
end

sort!(YN, by = x->x.y1)
YSN = convexHull(YN) ; deleteat!(YSN, findfirst(YSN, YN[end])+1:length(YSN))
YNN = setdiff(YN, YSN)


using PyPlot
plot(map(x->x.y1, YNN), map(x -> x.y2, YNN), "rx",   map(x->x.y1, YSN), map(x -> x.y2, YSN), "b-")
!isinteractive() && show()