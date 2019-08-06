@with_kw #=@trait=# struct PoissonParameter
    rate::SNNFloat = 1Hz
end

@with_kw #=@trait=# mutable struct Poisson
    param::PoissonParameter = PoissonParameter()
    N::SNNInt = 100
    randcache::Vector{SNNFloat} = rand(N)
    fire::Vector{Bool} = zeros(Bool, N)
    records::Dict = Dict()
end

#=@replace=# function integrate!(p::Poisson, param::PoissonParameter, dt::SNNFloat)
    prob = rate * dt
    rand!(randcache)
    @inbounds for i = 1:N
        fire[i] = randcache[i] < prob
    end
end
