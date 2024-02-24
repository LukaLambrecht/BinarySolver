# Main


include("./src/iotools.jl")
include("./src/status.jl")
include("./src/solvers.jl")


a = iotools.readtxt("./fls/example1.txt")
iotools.printbinary(a)
println()
solvers.maplines(solvers.reduceline, a)
iotools.printbinary(a)
println()
print("Is fully filled: ")
println(status.isfilled(a))
print("Contains any error: ")
println(status.containserror(a))
