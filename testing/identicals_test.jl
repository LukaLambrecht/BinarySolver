# Testing script for expand functionality

include("../src/identicals.jl")

# make a line to be solved
x = [1, -1, -1, 0, 1, 0]
x = Int.(x)

# make solved lines to check against
check1 = [1, 0, 1, 0, 1, 0]
check2 = [0, 0, 1, 1, 0, 1]
checklines = Vector{Int}[]
push!(checklines, Int.(check1))
push!(checklines, Int.(check2))

# print
println("Input line:")
println(x)

# solve by expansion and removing identicals
out = identicals.expandfilter(x, checklines)

# printouts
println("Filtered possible solutions:")
for line in out
    println(line)
end
