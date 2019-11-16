using Turing
using SparseArrays
using DataStructures: Accumulator, counter


function extract_TDM(file = "epigrams.txt")
    epigram_bags = Vector{Accumulator{UInt64, Int8}}()

    for epigram in eachline(file)
        push!(epigram_bags, counter(hash.(split(epigram))))
    end

    D = length(epigram_bags)
    T = length(reduce(union, epigram_bags))
    W = sparse([], [], Int8[], D, T)

    for (epigram, bag) in enumerate(epigram_bags)
        for (word, count) in bag
            W[epigram, Int(rem(word, T)) + 1] += count
        end
    end

    return W
end


