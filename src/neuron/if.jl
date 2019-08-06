abstract type AbstractIFParameter end
@with_kw #=@trait=# struct IFParameter <: AbstractIFParameter
    τm::SNNFloat = 20ms
    τe::SNNFloat = 5ms
    τi::SNNFloat = 10ms
    Vt::SNNFloat = -50mV
    Vr::SNNFloat = -60mV
    El::SNNFloat = Vr
end

abstract type AbstractIF end
@with_kw #=@trait=# mutable struct IF <: AbstractIF
    param::IFParameter = IFParameter()
    N::SNNInt = 100
    v::Vector{SNNFloat} = param.Vr .+ rand(N) .* (param.Vt - param.Vr)
    ge::Vector{SNNFloat} = zeros(N)
    gi::Vector{SNNFloat} = zeros(N)
    fire::Vector{Bool} = zeros(Bool, N)
    I::Vector{SNNFloat} = zeros(N)
    records::Dict = Dict()
end

#=@replace=# function integrate!(p::IF, param::IFParameter, dt::SNNFloat)
    @inbounds for i = 1:N
        v[i] += dt * (ge[i] + gi[i] - (v[i] - El) + I[i]) / τm
        ge[i] += dt * -ge[i] / τe
        gi[i] += dt * -gi[i] / τi
    end
    @inbounds for i = 1:N
        fire[i] = v[i] > Vt
        v[i] = ifelse(fire[i], Vr, v[i])
    end
end
