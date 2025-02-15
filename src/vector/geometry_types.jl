
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
