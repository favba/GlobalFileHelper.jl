module GlobalFileHelper

using Reexport
@reexport using ReadGlobal

using InplaceRealFFT, FluidFields

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

end