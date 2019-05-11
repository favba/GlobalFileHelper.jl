module GlobalFileHelper

using Reexport
@reexport using ReadGlobal

using InplaceRealFFT, FluidFields, FluidTensors

function InplaceRealFFT.PaddedArray{T}(filename::AbstractString) where {T}
    nx,ny,nz,lx,ly,lz = getdimsize()
    dtype,padded = checkinput(filename,nx,ny,nz)
    @assert T === dtype
    return PaddedArray{T}(filename,(nx,ny,nz),padded)
end

function InplaceRealFFT.PaddedArray(filename::AbstractString)
    nx,ny,nz,lx,ly,lz = getdimsize()
    dtype,padded = checkinput(filename,nx,ny,nz)
    return PaddedArray{dtype}(filename,(nx,ny,nz),padded)
end

function FluidFields.ScalarField{T}(filename::AbstractString) where {T}
    nx,ny,nz,lx,ly,lz = getdimsize()
    dtype,padded = checkinput(filename,nx,ny,nz)
    @assert T === dtype
    f = ScalarField{T}((nx,ny,nz),(lx,ly,lz))
    read!(filename,f.field,padded)
    return f 
end

function FluidFields.ScalarField(filename::AbstractString)
    nx,ny,nz,lx,ly,lz = getdimsize()
    dtype,padded = checkinput(filename,nx,ny,nz)
    f = ScalarField{dtype}((nx,ny,nz),(lx,ly,lz))
    read!(filename,f.field,padded)
    return f 
end

function Base.read!(filename::AbstractString,f::ScalarField{T}) where {T}
    nx,ny,nz,lx,ly,lz = getdimsize()
    dtype,padded = checkinput(filename,nx,ny,nz)
    @assert dtype === T
    read!(filename,f.field,padded)
    return f 
end

function Base.read!(filenames::NTuple{3,AbstractString},f::VectorField{T}) where {T}
    nx,ny,nz,lx,ly,lz = getdimsize()
    dtp = checkinput.(filenames,nx,ny,nz)
    dtypes = getindex.(dtp,1)
    paddeds = getindex.(dtp,2)
    @assert all(T .=== dtypes)
    read!(filenames[1],f.c.x.field,paddeds[1])
    read!(filenames[2],f.c.y.field,paddeds[2])
    read!(filenames[3],f.c.z.field,paddeds[3])
    return f 
end

function FluidFields.VectorField{T}(filenames::Vararg{AbstractString,3}) where {T}
    nx,ny,nz,lx,ly,lz = getdimsize()
    dtp = checkinput.(filenames,nx,ny,nz)
    dtypes = getindex.(dtp,1)
    paddeds = getindex.(dtp,2)
    @assert all(T .=== dtypes)
    f = VectorField{T}((nx,ny,nz),(lx,ly,lz))
    read!(filenames[1],f.c.x.field,paddeds[1])
    read!(filenames[2],f.c.y.field,paddeds[2])
    read!(filenames[3],f.c.z.field,paddeds[3])
    return f 
end

function FluidFields.VectorField(filenames::Vararg{AbstractString,3})
    nx,ny,nz,lx,ly,lz = getdimsize()
    dtp = checkinput.(filenames,nx,ny,nz)
    dtypes = getindex.(dtp,1)
    paddeds = getindex.(dtp,2)
    @assert all(dtypes[1] .=== dtypes)
    f = VectorField{dtypes[1]}((nx,ny,nz),(lx,ly,lz))
    read!(filenames[1],f.c.x.field,paddeds[1])
    read!(filenames[2],f.c.y.field,paddeds[2])
    read!(filenames[3],f.c.z.field,paddeds[3])
    return f 
end


FluidTensors.SymTrTenArray(filenames::Vararg{AbstractString,5}) = SymTrTenArray(readfield.(filenames)...)
FluidTensors.SymTenArray(filenames::Vararg{AbstractString,6}) = SymTenArray(readfield.(filenames)...)
FluidTensors.AntiSymTenArray(filenames::Vararg{AbstractString,3}) = AntiSymTenArray(readfield.(filenames)...)
FluidTensors.VecArray(filenames::Vararg{AbstractString,3}) = VecArray(readfield.(filenames)...)

function FluidFields.SymTenField(filenames::Vararg{AbstractString,6})
    nx,ny,nz,lx,ly,lz = getdimsize()
    dtp = checkinput.(filenames,nx,ny,nz)
    dtypes = getindex.(dtp,1)
    paddeds = getindex.(dtp,2)
    @assert all(dtypes[1] .=== dtypes)
    f = SymTenField{dtypes[1]}((nx,ny,nz),(lx,ly,lz))
    read!.(filenames,getfield.(getfield.(Ref(f.c), (:xx, :xy, :xz, :yy, :yz, :zz)),:field),paddeds)
    return f 
end

function FluidFields.SymTrTenField(filenames::Vararg{AbstractString,5})
    nx,ny,nz,lx,ly,lz = getdimsize()
    dtp = checkinput.(filenames,nx,ny,nz)
    dtypes = getindex.(dtp,1)
    paddeds = getindex.(dtp,2)
    @assert all(dtypes[1] .=== dtypes)
    f = SymTrTenField{dtypes[1]}((nx,ny,nz),(lx,ly,lz))
    read!.(filenames,getfield.(getfield.(Ref(f.c), (:xx, :xy, :xz, :yy, :yz)),:field),paddeds)
    return f 
end

function FluidFields.AntiSymTenField(filenames::Vararg{AbstractString,3})
    nx,ny,nz,lx,ly,lz = getdimsize()
    dtp = checkinput.(filenames,nx,ny,nz)
    dtypes = getindex.(dtp,1)
    paddeds = getindex.(dtp,2)
    @assert all(dtypes[1] .=== dtypes)
    f = AntiSymTenField{dtypes[1]}((nx,ny,nz),(lx,ly,lz))
    read!.(filenames,getfield.(getfield.(Ref(f.c), (:xy, :xz, :yz)),:field),paddeds)
    return f 
end

end