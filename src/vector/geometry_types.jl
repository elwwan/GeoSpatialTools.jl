import Base: ==

abstract type Geometry end
abstract type Curve <: Geometry end
abstract type Surface <: Geometry end

# Point
mutable struct Point <: Geometry
    x::Real
    y::Real
    z::Union{Nothing, Real}
    m::Union{Nothing, Real}
end
Point(x, y) = Point(x, y, nothing, nothing)
Point(x, y, z) = Point(x, y, z, nothing)
function ==(a::Point, b::Point)
    a.x == b.x &&
    a.y == b.y &&
    a.z == b.z &&
    a.m == b.m
end

# Curves
# LineString
mutable struct LineString <: Curve  
    points::Vector{Point}
end
function ==(a::LineString, b::LineString)
    a.points == b.points
end

# CircularString
mutable struct CircularString <: Curve  
    points::Vector{Point}
end
function ==(a::CircularString, b::CircularString)
    a.points == b.points
end

# CompoundCurve
mutable struct CompoundCurve <: Curve  
    curves::Vector{Union{LineString, CircularString}}
end
function ==(a::CompoundCurve, b::CompoundCurve)
    a.curves == b.curves
end

# Surfaces
# Polygon
mutable struct Polygon <: Surface
    outer_ring::LineString
    inner_rings::Vector{LineString}
end
Polygon(x) = Polygon(x, [])
function ==(a::Polygon, b::Polygon)
    a.outer_ring == b.outer_ring &&
    a.inner_rings == b.inner_rings
end

# CurvePolygon
mutable struct CurvePolygon <: Surface
    outer_ring::Curve
    inner_rings::Vector{Curve}
end
CurvePolygon(x) = CurvePolygon(x, [])
function ==(a::CurvePolygon, b::CurvePolygon)
    a.outer_ring == b.outer_ring &&
    a.inner_rings == b.inner_rings
end

# Collections
# MultiSurface
mutable struct MultiSurface <: Geometry
    surfaces::Vector{Surface}
end
function ==(a::MultiSurface, b::MultiSurface)
    a.surfaces == b.surfaces
end

# MultiPolygon
mutable struct MultiPolygon <: Geometry
    polygons::Vector{Polygon}
end
function ==(a::MultiPolygon, b::MultiPolygon)
    a.polygons == b.polygons
end

# MultiCurve
mutable struct MultiCurve <: Geometry
    curves::Vector{Curve}
end
function ==(a::MultiCurve, b::MultiCurve)
    a.curves == b.curves
end

# MultiLineString
mutable struct MultiLineString <: Geometry
    linestrings::Vector{LineString}
end
function ==(a::MultiLineString, b::MultiLineString)
    a.linestrings == b.linestrings
end

# MultiPoint
mutable struct MultiPoint <: Geometry
    points::Vector{Point}
end
function ==(a::MultiPoint, b::MultiPoint)
    a.points == b.points
end

# GeometryCollection
mutable struct GeometryCollection <: Geometry
    geometries::Vector{Geometry}
end
function ==(a::GeometryCollection, b::GeometryCollection)
    a.geometries == b.geometries
end