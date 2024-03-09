# Implementation of line expansion methods
# The idea is to construct all possible solutions for a line
# and look for common patterns.

module expand

include("linesolvers.jl")
include("status.jl")

function expandline(x)
    # perform expansion on a line.
    # input arguments:
    # - x: 1d Array (aka Vector) representing a line in a binary
    # output:
    # - a Vector in which each element is a Vector by itself,
    #   representing the possible solutions of the input line.
    #   (NB: output type is Vector{Vector{Int}})

    # initialize output array
    out = Vector{Int}[]

    # special case if line is already solved
    if( !(-1 in x) )
        out = push!(out, x)
        return out
    end

    # check if line is maximally reduced
    # note: this is optional now as errors are checked for downstream,
    #       but keep for now to indicate potential inefficiencies.
    info = linesolvers.reducelineloop(x)
    if length(info)>0 error("input was not reduced.") end

    # split in two options
    x1, x2 = branchline(x)

    # solve the two options as much as possible
    linesolvers.reducelineloop(x1)
    linesolvers.reducelineloop(x2)

    # repeat recursively
    # (but exclude erroneous solutions)
    if !status.line_contains_error(x1)
        for xi in expandline(x1) push!(out, xi) end
    end
    if !status.line_contains_error(x2)
        for xi in expandline(x2) push!(out, xi) end
    end

    # return the output array
    return out
end

function branchline(x)
    # helper function for expandline to split a line in two options.
    # note: the splitting is done by returning two copies of the input line,
    #       where the first unknown value is set to 0 and 1 respectively.
    # warning: no check is done here on the validity of both options,
    #          it is assumed that the input line was reduced in advance.
    # input arguments:
    # - x: a 1d Array (aka a Vector) representing a partially solved line.
    # output:
    # - a tuple of two copies of x, with the first unknown value set to 0 and 1.
    x1 = copy(x)
    x2 = copy(x)
    len = length(x)
    for idx = 1:len
        if (x[idx]==-1)
            x1[idx] = 0
            x2[idx] = 1
            break
        end
    end
    return x1, x2
end

function commonpattern(lines)
    # extract a common pattern (if any) from a set of possible solutions for a line
    # input arguments:
    # - lines: a Vector of Vectors (each representing a possible solution of a line),
    #   e.g. the output of expandline.
    # returns:
    # - a Vector with the common digits of all lines set accordingly, and -1 elsewhere.
    x = copy(lines[1])
    len = length(x)
    nlines = length(lines)
    for idx = 1:len
        x[idx] = -1
        candidate = lines[1][idx]
        for linenumber = 2:nlines
            if lines[linenumber][idx]!=candidate
                candidate = -1
                break
            end
        end
        x[idx] = candidate
    end
    return x
end

function expandreduce(line)
    # reduce a line by common patterns in expansion,
    # combination of expandline and commonpattern
    # input arguments:
    # - line: Vector representing a line in a binary
    # returns:
    # - vector with information on indices that were filled
    lines = expandline(line)
    common = commonpattern(lines)
    filled = []
    for idx = 1:length(line)
        if (line[idx]==-1 && common[idx]!=-1)
            line[idx] = common[idx]
            push!(filled, ("expandreduce", idx, common[idx]))
        end
    end
    return filled
end

end
