using Turing
using SparseArrays


function extract_TDM(file = "epigrams.txt")
    epigram_bags = Vector{Set{UInt64}}()

    for epigram in eachline(file)
        push!(epigram_bags, Set(hash.(split(epigram))))
    end

    D = length(epigram_bags)
    T = length(reduce(union, epigram_bags))
    W = sparse([], [], Int[], D, T)

    for (epigram, bag) in enumerate(epigram_bags)
        for word in bag
            W[document, Int(rem(word, T)) + 1] += 1
        end
    end

    return W
end


