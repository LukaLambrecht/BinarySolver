# Main


include("./src/iotools.jl")
include("./src/status.jl")
include("./src/linesolvers.jl")
include("./src/solvers.jl")


a = iotools.readtxt("./fls/example_6x6_hard_3.txt")
iotools.printbinary(a)
println()
filled = solvers.solve(a)
iotools.printbinary(a)
println()
print("Is fully filled: ")
println(status.isfilled(a))
print("Contains any error: ")
println(status.containserror(a))

println("Order of filling:")
for el in filled println(el) end
