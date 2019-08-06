@with_kw #=@mixin=# struct NoisyIFParameter <: AbstractIFParameter
    σ::SNNFloat = 0
end

@with_kw #=@mixin=# mutable struct NoisyIF <: AbstractIF
    param::NoisyIFParameter = NoisyIFParameter()
    randncache::Vector{SNNFloat} = randn(N)
end

#=@replace=# function integrate!(p::NoisyIF, param::NoisyIFParameter, dt::SNNFloat)
    randn!(randncache)
    @inbounds for i = 1:N
        v[i] += dt * (ge[i] + gi[i] - (v[i] - El) + I[i] + σ / √dt * randncache[i]) / τm
        ge[i] += dt * -ge[i] / τe
        gi[i] += dt * -gi[i] / τi
    end
    @inbounds for i = 1:N
        fire[i] = v[i] > Vt
        v[i] = ifelse(fire[i], Vr, v[i])
    end
end
