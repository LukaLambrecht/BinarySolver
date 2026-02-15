# Implementation of methods for solving by avoiding identical lines.

module identicals

include("linesolvers.jl")
include("status.jl")
include("expand.jl")

function expandfilter(line, checklines)
    # solve a line by expansion and filtering out identicals with any line in checklines.
    # input arguments:
    # - line: a line (i.e. a Vector{Int}) to be solved
    # - checklines: an array of lines (i.e. Vector{Vector{Int}})
    #   with fully solved lines to which the to-be-solved line cannot be identical.
    # returns:
    # - an array of lines (i.e. Vector{Vector{Int}}) with potential solutions for the line,
    #   after expansion and filtering out identicals with checklines.

    # special case if line is already solved
    if( !(-1 in line) )
        out = Vector{Int}[]
        out = push!(out, line)
        return out
    end

    # check if line is maximally reduced
    # note: this is optional now as this is checked in expansion function as well,
    #       but keep for now to indicate potential inefficiencies.
    info = linesolvers.reducelineloop(line)
    if length(info)>0 error("input was not reduced.") end

    # get all possible solutions of the line
    candidates = expand.expandline(line)

    # disregard potential solutions that are identical to any in checklines
    keepids = Int[]
    for (idx, candidate) in enumerate(candidates)
        keep = true
        for checkline in checklines
            if status.issubarray(candidate, checkline) keep = false end 
        end
        if keep keepids = push!(keepids, idx) end
    end
    
    return candidates[keepids]
end

end
