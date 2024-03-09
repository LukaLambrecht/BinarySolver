# Conversion methods

module conversion

function tolist(b)
    # convert a binary grid to a list of rows and columns.
    # input arguments:
    # - b: a binary grid, of type Matrix{Int} (i.e. a 2D Array{Int})
    # returns:
    # - a Vector in which each element is a Vector by itself,
    #   representing all rows and columns in b.
    #   (NB: output type is Vector{Vector{Int}})

    # initialize output array
    out = Vector{Int}[]

    # fill it with each row and column from input grid
    for xi in eachrow(b) push!(out, xi) end
    for xi in eachcol(b) push!(out, xi) end

    # return output array
    return out
end

function getrows(b)
    # same as above but only rows
    out = Vector{Int}[]
    for xi in eachrow(b) push!(out, xi) end
    return out
end

function getcolumns(b)
    # same as above but only columns
    out = Vector{Int}[]
    for xi in eachcol(b) push!(out, xi) end
    return out
end

end
