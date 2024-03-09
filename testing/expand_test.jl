# Testing script for expand functionality

include("../src/expand.jl")

# make a line
x = [1, -1, -1, -1, -1, -1]

# convert to correct type
x = Int.(x)

# print
println("Input line:")
println(x)

# expand all possible solutions
println("Performing expansion...")
out = expand.expandline(x)

# printouts
println("All possible solutions:")
for line in out
    println(line)
end
println()

# repeat for a line that actually has a common pattern
x = [1, 1, 0, -1, -1, -1]
x = Int.(x)
println("Input line:")
println(x)
out = expand.expandline(x)
common = expand.commonpattern(out)
println("Common pattern in all solutions:")
println(common)
println()

# check combination function
x = [1, 1, 0, -1, -1, -1]
x = Int.(x)
println("Input line:")
println(x)
filled = expand.expandreduce(x)
println("Common pattern in all solutions:")
println(x)
println("Filled indices:")
println(filled)
println()

# case of a line that can not be reduced further with basic methods,
# and yet there is only one solution after expansion
x = [1, -1, -1, 0, -1, 1]
x = Int.(x)
println("Input line:")
println(x)
out = expand.expandline(x)
println("Expansion:")
for line in out println(line) end
