# Area

# Base function for closed LineString (used to calculate area of outer and inner rings) using Shoelace formula
function area(closed_linestring::LineString)
  x = [point.x for point in closed_linestring.points]
  y = [point.y for point in closed_linestring.points]
  return abs(sum([i * j for (i, j) in zip(x, y[2:end])]) - 
             sum([i * j for (i, j) in zip(x[2:end], y)])) / 2
end

# Polygon
function area(polygon::Polygon)
  total = 0
  total += area(polygon.outer_ring)
  for inner_ring in polygon.inner_rings
      total -= area(inner_ring)
  end
  return total
end

# MultiPolygon
function area(multipolygon::MultiPolygon)
  total = 0
  for polygon in multipolygon.polygons
      total += area(polygon)
  end
  return total
end

# CurvePolygon
# MultiSurface
function area(multisurface::MultiSurface)
  total = 0
  for surface in multisurface.surfaces
    total += area(surface)
  end
  return total 
end

# GeometryCollection
function area(geometrycollection::GeometryCollection)
  total = 0
  for geometry in geometrycollection.geometries
    total += geometry isa Union{Surface, MultiPolygon, MultiSurface, GeometryCollection} ? area(geometry) : nothing
  end
  return total
end
