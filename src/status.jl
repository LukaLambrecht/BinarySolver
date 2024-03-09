# Function for checking the status of a binary puzzle


module status

function isfilled(b)
    # check if a binary is fully filled
    # (i.e. no unknown values remain in the grid)
    return !(-1 in b)
end

function issubarray(sub::AbstractVector, full::AbstractVector)
    # help function to check presence of subarray
    # a little like builtin issubset, but order matters.
    sublen = length(sub)
    for idx in 1:length(full)-sublen+1
        if full[idx:idx+sublen-1] == sub return true end
    end
    return false
end
    
function line_contains_triplet(line)
    # check if a line contains a triplet
    if issubarray([0,0,0], line) return true end
    if issubarray([1,1,1], line) return true end
    return false
end

function containstriplet(b)
    # check if a binary contains a triplet
    # (e.g. for early-detecting mistakes)
    for row in eachrow(b)
        if line_contains_triplet(row) return true end
    end
    for col in eachcol(b)
        if line_contains_triplet(col) return true end
    end
    return false
end

function line_contains_excess(line)
    halflen = length(line) / 2
    if count(==(0), line) > halflen return true end
    if count(==(1), line) > halflen return true end
    return false
end

function containsexcess(b)
    # check if a binary contains too many 0s or 1s per line
    # (e.g. for early-detecting mistakes)
    for row in eachrow(b)
        if line_contains_excess(row) return true end
    end
    for col in eachcol(b)
        if line_contains_excess(col) return true end
    end
    return false
end

function containsidentical(b)
    # check if a binary contains identical rows or columns
    # (e.g. for early-detecting mistakes)
    len = size(b)[1]
    for idx = 1:len-1
        for idx2 = idx+1:len
            if ( !(-1 in b[idx,:]) && !(-1 in b[idx2,:]) )
                if issubarray(b[idx,:], b[idx2,:]) return true end
            end
            if ( !(-1 in b[:,idx]) && !(-1 in b[:,idx2]) )
                if issubarray(b[:,idx], b[:,idx2]) return true end
            end
        end
    end
    return false
end

function line_contains_error(line)
    # accumulator of line error functions
    return (line_contains_triplet(line) || line_contains_excess(line))
end

function containserror(b)
    # accumulator of functions above
    return (containstriplet(b) || containsexcess(b) || containsidentical(b))
end

end
