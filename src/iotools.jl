# Input/output tools


module iotools

using DelimitedFiles

function checkfile(inputfile)
    # check if a file is suitable for reading into a binary grid
    # input arguments:
    # - inputfile: path to an input txt file
    # returns
    # - a tuple of two variables, first one is a bool
    #   (true if file is good, false otherwise),
    #   the second one is a potential error message.
    
    # check file type by extension
    if !endswith(inputfile, ".txt")
        return (false, "file does not have .txt extension.")
    end
    
    # try to read it
    try
        content = readdlm(inputfile)
    catch e
        msg = "internal reader error, file seems not to be a regular .txt file."
        return (false, msg)
    end

    # read the file
    # (note: re-reading is needed as variables inside try-catch block
    # are not available outside that scope, maybe find smarter solution later)
    content = readdlm(inputfile)

    # check the shape
    nrows = size(content,1)
    ncols = size(content,2)
    if ncols!=nrows
        msg = "file does not contain a square grid"
        msg = msg * " (found $nrows rows but $ncols columns)."
        return (false, msg)
    end

    # check illegal values
    content[content .== 1] .= "-"
    content[content .== 0] .= "-"
    if any(content .!= "-")
        idx = findfirst(content .!= "-")
        row = idx[1]
        col = idx[2]
        val = content[idx]
        msg = "file contains illegal character $val (at position ($row, $col))."
        return (false, msg)
    end

    return (true, "")
end

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
