function merge(a::Vector{<:Real}, b::Vector{<:Real})
  return [
      min(a[1], b[1]),
      min(a[2], b[2]),
      max(a[3], b[3]),
      max(a[4], b[4])
  ]
end


# General 
function bounding_box(points::Vector{Tuple{T, T}}) where T <: Real
  coords::Vector{<:Real} = [Inf, Inf, -Inf, -Inf]
  for (x, y) in points
      coords = merge(coords, [x, y, x, y])
  end
  return coords
end

# Point
function bounding_box(point::Point)
  x, y = point.geometry
  return [x, y, x, y]
end
# MultiPoint
function bounding_box(multipoint::MultiPoint)
  coords::Vector{<:Real} = [Inf, Inf, -Inf, -Inf]
  for point in multipoint.geometry
    coords = merge(coords, bounding_box(point))
  end
  return coords
end

# LineString
function bounding_box(linestring::LineString)
  return bounding_box(linestring.geometry)
end

# MultiLineString
function bounding_box(multilinestring::MultiLineString)
  coords::Vector{<:Real} = [Inf, Inf, -Inf, -Inf]
  for line in multilinestring.geometry
    coords = merge(coords, bounding_box(line))
  end
  return coords
end

# Polygon (now handles all rings)
function bounding_box(polygon::Polygon)
  return bounding_box(polygon.geometry[1])
end

# MultiPolygon
function bounding_box(multipolygon::MultiPolygon)
  coords::Vector{<:Real} = [Inf, Inf, -Inf, -Inf]
  for polygon in multipolygon.geometry
    coords = merge(coords, bounding_box(polygon))
  end
  return coords
end

# GeometryCollection
function bounding_box(collection::GeometryCollection)
  coords::Vector{<:Real} = [Inf, Inf, -Inf, -Inf]
  for geom in collection.geometry
    coords = merge(coords, bounding_box(geom))
  end
  coords
end
