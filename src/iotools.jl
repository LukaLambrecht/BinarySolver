# Input/output tools


module iotools

using DelimitedFiles

function readtxt(inputfile)
    # read a txt file into a binary grid
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

function printbinary(b)
    # print a binary in a nice way
    dashed = getdashed(b)
    for row in eachrow(dashed)
        for idx = 1:length(row)
            print(row[idx])
            print(" ")
        end
        println()
    end
    return nothing
end

end
