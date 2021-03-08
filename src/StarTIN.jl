module StarTIN
using Libdl

const startin = "libstartin"

struct Star
    pt::Vector{Float64} # length 3
    link::Vector{UInt}
end

struct Triangulation
    stars::Vector{Star}
    snaptol::Float64
    cur::UInt
    is_init::Bool
    jump_and_walk::Bool
    robust_predicates::Bool
    removed_indices::Vector{UInt}
end

mutable struct DT
    ptr::Ptr{Triangulation}
    function DT()
        ptr = ccall((:new, startin), Ptr{Triangulation}, ())
        dt = new(ptr)
        finalizer(destroy!, dt)
        dt
    end
end


function Base.insert!(t::DT, points::Matrix{Float64})
    w, h = size(points)
    w == 3 || error("Point array should be 3 dimensional, got $w dimensions.")
    res = ccall((:insert, startin), Cint, (Ptr{Triangulation}, Cint, Ref{Cdouble}), t.ptr, length(points), points)
    res == 0 || @warn "$res duplicate points encountered."
    res
end

function info(t::DT)
    ccall((:debug, startin), Cint, (Ptr{Triangulation},), t.ptr)
end

function interpolate_nn(t::DT, x::Float64, y::Float64)
    ccall((:interpolate_nn, startin), Cdouble, (Ptr{Triangulation}, Cdouble, Cdouble), t.ptr, x, y)
end
function interpolate_linear(t::DT, x::Float64, y::Float64)
    ccall((:interpolate_linear, startin), Cdouble, (Ptr{Triangulation}, Cdouble, Cdouble), t.ptr, x, y)
end
function interpolate_laplace(t::DT, x::Float64, y::Float64)
    ccall((:interpolate_laplace, startin), Cdouble, (Ptr{Triangulation}, Cdouble, Cdouble), t.ptr, x, y)
end

function write!(fn::AbstractString, t::DT)
    ccall((:write_obj, startin), Cint, (Ptr{Triangulation}, Cstring), t.ptr, fn)
end

function destroy!(t::DT)
    @debug "Cleaning up memory."
    ccall((:destroy, startin), Cint, (Ptr{Triangulation},), t.ptr)
end

export DT
export insert!
export interpolate_nn
export interpolate_linear
export interpolate_laplace
export write!
export destroy!
export info

end
