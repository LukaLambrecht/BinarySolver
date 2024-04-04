# Main


include("./src/iotools.jl")
include("./src/status.jl")
include("./src/linesolvers.jl")
include("./src/solvers.jl")


# read command line args
file = ARGS[1]

# check the input file
(file_is_good, error_msg) = iotools.checkfile(file)
if !file_is_good
    msg = "input file could not be loaded because of the following error: "
    msg = msg * error_msg
    error(msg)
end

# load the binary
a = iotools.readtxt(file)
println("Loaded the following binary puzzle:")
iotools.printbinary(a)
println()

# solve
println("Solving...")
filled = solvers.solve(a)
println("Solved binary:")
iotools.printbinary(a)
println()

# print some diagnostics
print("Is fully filled: ")
println(status.isfilled(a))
print("Contains any error: ")
println(status.containserror(a))
println()

# print log of solving
println("Log of solving methods:")
for el in filled
    solver = el[1]
    cell = el[2]
    value = el[3]
    println("Cell $cell was filled with $value using $solver")
end
