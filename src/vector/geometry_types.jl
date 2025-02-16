
# GeometryTypes

abstract type AbstractGeometry end
struct Polygon{T<:Real} <: AbstractGeometry
  geometry::Vector{Vector{Tuple{T, T}}}
end
struct MultiPolygon <: AbstractGeometry
  geometry::Vector{Polygon}
end
struct LineString{T<:Real} <: AbstractGeometry
  geometry::Vector{Tuple{T, T}}
end
struct MultiLineString <: AbstractGeometry
  geometry::Vector{LineString}
end
struct Point{T<:Real} <: AbstractGeometry
  geometry::Tuple{T, T}
end
struct MultiPoint <: AbstractGeometry
  geometry::Vector{Point}
end
struct GeometryCollection <: AbstractGeometry
  geometry::Vector{AbstractGeometry}
end

# Equality
import Base: ==

function ==(a::Point, b::Point)
  a.geometry == b.geometry
end
function ==(a::MultiPoint, b::MultiPoint)
  a.geometry == b.geometry
end
function ==(a::LineString, b::LineString)
  a.geometry == b.geometry
end
function ==(a::MultiLineString, b::MultiLineString)
  a.geometry == b.geometry
end
function ==(a::Polygon, b::Polygon)
  a.geometry == b.geometry
end
function ==(a::MultiPolygon, b::MultiPolygon)
  a.geometry == b.geometry
end
function ==(a::GeometryCollection, b::GeometryCollection)
  a.geometry == b.geometry

end
