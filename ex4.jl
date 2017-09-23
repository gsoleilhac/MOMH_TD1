using vOptGeneric, GLPKMathProgInterface

m = vModel(solver = GLPKSolverMIP())

@variable(m, x[1:5] >= 0)
@variable(m, δ[1:3], Bin)

@addobjective(m, Max, dot([17,-12,-12,-19,-6], x) + dot([-73, -99, -81], δ))
@addobjective(m, Max, dot([2,-6,0,-12,13], x) + dot([-61,-79,-53], δ))
@addobjective(m, Max, dot([-20,7,-16,0,-1], x) + dot([-72,-54,-79], δ))

@constraint(m, sum(δ) <= 1)
@constraint(m, -x[2] + 6x[5] + 25δ[1] <= 52)
@constraint(m, -x[1] + 18x[4] + 18x[5] + 8δ[2] <= 77)
@constraint(m, 7x[4] + 9x[5] + 19δ[3] <= 66)
@constraint(m, 16x[1] + 20x[5] <= 86)
@constraint(m, 13x[2] + 7x[4] <= 86)

solve(m, method=:lex)


using PyPlot
YN = getY_N(m)
plot3D(map(e->e[1], YN), map(e->e[2], YN), map(e->e[3], YN), "bo");
!isinteractive() && show()