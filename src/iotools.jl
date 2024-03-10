# Input/output tools


module iotools

using DelimitedFiles

function readtxt(inputfile)
    # read a txt file into a binary grid
    # input arguments:
    # - inputfile: path to an input txt file
    # returns
    # - an object of type Matrix{Int} (i.e. a 2D Array{Int}),
    #   with each element either 0, 1 or -1 (for unknown)
    aux = readdlm(inputfile)
    aux[aux .== "-"] .= -1
    binary = Int.(aux)
    return binary
end

function getdashed(b)
    # make a copy with -1 replaced by "-" (e.g. for printing)
    dashed = copy(b)
    dashed = convert(Matrix{Any}, dashed)
    dashed[dashed .== -1] .= "-"
    return dashed
end

function tostring(b)
    # get a printable string representation of a binary
    dashed = getdashed(b)
    out = ""
    for row in eachrow(dashed)
        for idx = 1:length(row)
            out = out * string(row[idx]) * " "
        end
        out = out * "\n"
    end
    return out
end

function printbinary(b)
    # print a binary in a nice way
    print(tostring(b))
    return nothing
end

end
