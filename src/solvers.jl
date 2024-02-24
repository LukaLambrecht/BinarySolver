# Implementation of binary puzzle solving methods


module solvers

function maplines(f, b)
    # execute a function on each line of a binary.
    # input arguments:
    # - f: function operating on a line in a binary
    # - b: a binary grid
    for row in eachrow(b) f(row) end
    for col in eachcol(b) f(col) end
    return nothing
end

function reduceline(x)
    # perform basic reduction operations on a line.
    # input arguments:
    # - x: 1d array representing a line in a binary
    # note: basic operations include:
    # - outer method: - 0 0 - -> 1 0 0 1
    # - inner metod: 0 - 0 -> 0 1 0
    # - balance method: ensure equal number of 0 and 1

    # initializations
    len = length(x)
    halflen = len/2

    # outer method
    if (x[1]!=-1 && x[2]==x[1] && x[3]==-1) x[3] = 1-x[1] end
    if (x[len]!=-1 && x[len-1]==x[len] && x[len-2]==-1) x[len-2] = 1-x[len] end
    for idx = 2:len-2
        if (x[idx]!=-1 && x[idx+1]==x[idx])
            if x[idx-1]==-1 x[idx-1] = 1-x[idx] end
            if x[idx+2]==-1 x[idx+2] = 1-x[idx] end
        end
    end

    # inner method
    for idx = 2:len-1
        if (x[idx]==-1 && x[idx-1]!=-1 && x[idx+1]==x[idx-1])
            x[idx] = 1-x[idx+1]
        end
    end

    # balance method
    if count(==(0), x) == halflen
        for idx = 1:len
            if x[idx]==-1 x[idx] = 1 end
        end
    end
    if count(==(1), x) == halflen
        for idx = 1:len
            if x[idx]==-1 x[idx] = 0 end
        end
    end
    return nothing
end

end
