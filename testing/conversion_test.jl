# Testing script for conversion functionality

include("../src/iotools.jl")
include("../src/conversion.jl")

# make a binary grid
b = [1 0 1; 0 0 0; 2 2 2]

# print
println("Input grid:")
iotools.printbinary(b)

# get rows an columns
println("Rows:")
for row in conversion.getrows(b) println(row) end
println("Columns:")
for col in conversion.getcolumns(b) println(col) end
println("Rows and columns:")
for line in conversion.tolist(b) println(line) end
