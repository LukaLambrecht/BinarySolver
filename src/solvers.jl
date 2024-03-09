# Implementation of binary puzzle solving methods


module solvers

include("linesolvers.jl")
include("expand.jl")
include("iotools.jl")

function maplines(f, b; dobreak=false)
    # execute a function on each line of a binary.
    # note: f is supposed to return a vector with info on filled instances,
    #       with elements of type (infostr, idx, value)
    # input arguments:
    # - f: function operating on a line in a binary
    # - b: a binary grid
    # - break: whether to break after one line was found
    #          in which instance(s) could be filled
    # returns:
    # - a vector with info on filled instances,
    #   with elements of type (infostr, (rown, coln), value)
    filled = []
    for (rown, row) in enumerate(eachrow(b))
        infos = f(row)
        for info in infos push!(filled, (info[1]*" (row)", (rown, info[2]), info[3])) end
        if (dobreak && length(filled)>0) break end
    end
    if (dobreak && length(filled)>0) return filled end
    for (coln, col) in enumerate(eachcol(b))
        infos = f(col)
        for info in infos push!(filled, (info[1]*" (column)", (info[2], coln), info[3])) end
        if (dobreak && length(filled)>0) break end
    end
    return filled
end

function maplinesloop(f, b)
    # execute a function on each line of a binary
    # and repeat until no more entries can be filled.
    # note: f is supposed to return a vector with info on filled instances,
    #       with elements of type (infostr, idx, value)
    # input arguments:
    # - f: function operating on a line in a binary
    # - b: a binary grid
    # returns:
    # - a vector with info on filled instances,
    #   with elements of type (infostr, (rown, coln), value)
    temp = maplines(f, b)
    filled = copy(temp)
    while length(temp)>0
        temp = maplines(f, b)
        for el in temp push!(filled, el) end
    end
    return filled
end

function solve(b)
    # complete solving method
    
    # initialize vector of filled locations
    filled = []
    filled_iteration = [0]

    # repeat as long as entries can be filled
    while length(filled_iteration)>0
        filled_iteration = []
    
        # basic line reduction until no more entries can be filled
        temp = maplinesloop(linesolvers.reducelineloop, b)
        for el in temp 
            push!(filled_iteration, el)
            push!(filled, el)
        end

        # common patterns in possible solutions
        temp = maplines(expand.expandreduce, b, dobreak=true)
        for el in temp
            push!(filled_iteration, el)
            push!(filled, el)
        end
    end

    # return vector with filled locations
    return filled

end

end
