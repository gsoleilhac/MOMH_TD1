import Base.<=, Base.push!
z1(x) = x^2
z2(x) = (x-2)^2

struct Solution
	x::Float64
	z1::Float64
 	z2::Float64
end
Solution(x) = Solution(x, z1(x), z2(x))
Solution() = Solution(rand()*20 - 10)
<=(a1,a2,b1,b2) = a1 <= b1  && a2 < b2 || a1 < b1 && a2 <= b2
<=(a::Solution, b::Solution) = <=(a.z1, a.z2, b.z1, b.z2)

struct NonDomList
    x::Vector{Solution}
    NonDomList() = new(Solution[])
end

function push!(ndl::NonDomList, s::Solution)
    if isempty(ndl.x) 
        return push!(ndl.x, s)
    else
        ind = searchsortedlast(ndl.x, s, by = x -> x.z1)
        if ind == 0 || !(ndl.x[ind] <= s)
            insert!(ndl.x, ind+1, s)
            if ind+2 <= length(ndl.x) && s <= ndl.x[ind+2]
                deb, fin = ind+2, ind+2
                while fin+1 <= length(ndl.x) && s <= ndl.x[fin+1]
                    fin += 1
                end
                deleteat!(ndl.x, deb:fin)
            end
        end
    end
end

const solutions = [Solution() for _=1:100000];
println("Brute force :")
@time YN1 = begin
    YN = Solution[]
    for s in solutions
        if !any(elt -> elt <= s, YN) #if ⁠¬(∃e ∈ YN | e <= s)
            push!(YN, s) #add s to YN
            filter!(elt -> !(elt >= s), YN) #keep only e in YN | ¬(s<=e)
        end
    end
    sort(YN, by = x -> x.z1)
end;

println("Sorted Non-Dominated List : ")
@time YN2 = begin
    YN = NonDomList()
    for s in solutions
        push!(YN, s)
    end
    YN.x
end;

@show YN1 == YN2

using PyPlot
plot(map(x->x.z1, YN2), map(x -> x.z2, YN2), "rx")
!isinteractive() && show()