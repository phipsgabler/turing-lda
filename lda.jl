using SparseArrays
using DataStructures: Accumulator, counter
using Turing
using Distributions


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


@model LatentDirichletAllocation(W, ntopics = 10, α = 0.5, β = 0.5) = begin
    ndocs, ntypes = size(W)
    ntokens = sum(W)

    # prior for topic distribution per document
    θ = Vector{Vector{Real}}(undef, ndocs)
    for d = 1:ndocs
        θ[d] ~ Dirichlet(ntopics, α)
    end

    # topic distribution per document
    Z = Vector{Vector{Int}}(undef, ndocs)
    for d = 1:ndocs
        z[d] ~ Categorical(θ[d])
    end

    # prior for topic distribution per word
    ϕ = Vector{Vector{Real}}(undef, ntopics)
    for t = 1:ntopics
        ϕ[t] ~ Dirichlet(ntypes, β)
    end

    # distribution of word per document
    for d = 1:ndocs, w = 1:ntypes
        W[d, w] ~ Categorical(ϕ[Z[d][w]])
    end
end


function test()
    W = extract_TDM()
    chain = sample(LatentDirichletAllocation(W), IS(), 10)
    describe(chain)
end

test()
