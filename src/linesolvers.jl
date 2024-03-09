# Implementation of single line solving methods


module linesolvers

function reduceline(x)
    # perform basic reduction operations on a line.
    # input arguments:
    # - x: 1d array representing a line in a binary
    # returns:
    # - vector with information on instances that were filled
    #   (empty vector if no locations could be filled)
    # note: basic operations include:
    # - outer method: - 0 0 - -> 1 0 0 1
    # - inner metod: 0 - 0 -> 0 1 0
    # - balance method: ensure equal number of 0 and 1

    # initializations
    len = length(x)
    halflen = len/2
    reduced = []

    # outer method
    if (x[1]!=-1 && x[2]==x[1] && x[3]==-1)
        x[3] = 1-x[1] 
        push!(reduced, ("outer", 3, 1-x[1]))
    end
    if (x[len]!=-1 && x[len-1]==x[len] && x[len-2]==-1)
        x[len-2] = 1-x[len]
        push!(reduced, ("outer", len-2, 1-x[len]))
    end
    for idx = 2:len-2
        if (x[idx]!=-1 && x[idx+1]==x[idx])
            if (x[idx-1]==-1)
                x[idx-1] = 1-x[idx]
                push!(reduced, ("outer", idx-1, 1-x[idx]))
            end
            if (x[idx+2]==-1)
                x[idx+2] = 1-x[idx]
                push!(reduced, ("outer", idx+2, 1-x[idx]))
            end
        end
    end

    # inner method
    for idx = 2:len-1
        if (x[idx]==-1 && x[idx-1]!=-1 && x[idx+1]==x[idx-1])
            x[idx] = 1-x[idx+1]
            push!(reduced, ("inner", idx, 1-x[idx+1]))
        end
    end

    # balance method
    if count(==(0), x) == halflen
        for idx = 1:len
            if (x[idx]==-1)
                x[idx] = 1
                push!(reduced, ("balance", idx, 1))
            end
        end
    end
    if count(==(1), x) == halflen
        for idx = 1:len
            if (x[idx]==-1)
                x[idx] = 0
                push!(reduced, ("balance", idx, 0))
            end
        end
    end
    return reduced
end

function reducelineloop(x)
    # run line reduction in a loop until no further reduction can be done
    # returns:
    # - vector of indices of locations on the line that were filled
    #   (empty vector if no locations could be filled)
    temp = reduceline(x)
    reduced = copy(temp)
    while length(temp)>0
        temp = reduceline(x)
        for el in temp push!(reduced, el) end
    end
    return reduced
end

end
