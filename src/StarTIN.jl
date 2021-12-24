module StarTIN
using Libdl
using startin_jll
# libstartin = joinpath(pwd(), "../startin/target/release/libstartin.dylib")


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
        ptr = ccall((:new, libstartin), Ptr{Triangulation}, ())
        dt = new(ptr)
        finalizer(destroy!, dt)
        dt
    end
end


function Base.insert!(t::DT, points::Matrix{Float64})
    w, _ = size(points)
    w == 3 || error("Point array should be 3 dimensional, got $w dimensions.")
    res = ccall((:insert, libstartin), Cint, (Ptr{Triangulation}, Cint, Ref{Cdouble}), t.ptr, length(points), points)
    res == 0 || @warn "$res duplicate points encountered."
    res
end

function Base.insert!(t::DT, point::Vector{Float64})
    w = length(point)
    w == 3 || error("Point array should be 3 dimensional, got $w dimensions.")
    res = ccall((:insert_one_pt, libstartin), Cint, (Ptr{Triangulation}, Cdouble, Cdouble, Cdouble), t.ptr, point[1], point[2], point[3])
    res == 0 && @warn "Error inserting point."
    res
end

function Base.delete!(t::DT, pointid)
    ccall((:remove, libstartin), Cint, (Ptr{Triangulation}, Cint), t.ptr, pointid)
end

function info(t::DT)
    ccall((:debug, libstartin), Cint, (Ptr{Triangulation},), t.ptr)
end

function get_snap_tolerance(t::DT)
    ccall((:get_snap_tolerance, libstartin), Cdouble, (Ptr{Triangulation},), t.ptr)
end
function set_snap_tolerance!(t::DT, tol::Float64)
    ccall((:set_snap_tolerance, libstartin), Cdouble, (Ptr{Triangulation}, Cdouble), t.ptr, tol)
end

function interpolate_nn(t::DT, x::Float64, y::Float64)
    ccall((:interpolate_nn, libstartin), Cdouble, (Ptr{Triangulation}, Cdouble, Cdouble), t.ptr, x, y)
end
function interpolate_linear(t::DT, x::Float64, y::Float64)
    ccall((:interpolate_linear, libstartin), Cdouble, (Ptr{Triangulation}, Cdouble, Cdouble), t.ptr, x, y)
end
function interpolate_nni(t::DT, x::Float64, y::Float64)
    ccall((:interpolate_nni, libstartin), Cdouble, (Ptr{Triangulation}, Cdouble, Cdouble), t.ptr, x, y)
end
function interpolate_laplace(t::DT, x::Float64, y::Float64)
    ccall((:interpolate_laplace, libstartin), Cdouble, (Ptr{Triangulation}, Cdouble, Cdouble), t.ptr, x, y)
end

function write!(fn::AbstractString, t::DT)
    ccall((:write_obj, libstartin), Cint, (Ptr{Triangulation}, Cstring), t.ptr, fn)
end

function destroy!(t::DT)
    @debug "Cleaning up memory."
    ccall((:destroy, libstartin), Cint, (Ptr{Triangulation},), t.ptr)
end

export DT
export interpolate_nn
export interpolate_nni
export interpolate_linear
export interpolate_laplace
export get_snap_tolerance
export set_snap_tolerance!
export write!
export destroy!
export info

end
