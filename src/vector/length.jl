import Base.length

# Length
# LineString
function length(linestring::LineString)
  total = 0
  for i in 1:length(linestring.points)-1
      total += sqrt( (linestring.points[i+1].x - linestring.points[i].x)^2 + (linestring.points[i+1].y - linestring.points[i].y)^2 )
  end
  return total
end
import Base.length
# CircularString
function length(circularstring::CircularString)
  pts = circularstring.points
  if length(pts) <= 3
    center, radius, angle = midpoint_radius_angle(pts)
    return angle * radius
  else 
    total = 0.0
    for i in 1:2:(length(pts) - 2)
      center, radius, angle = midpoint_radius_angle(pts[i:i+2])
      total += angle * radius
    end
    return total
  end
end

# CompoundCurve
function length(compoundcurve::CompoundCurve)
  total = 0
  for curve in compoundcurve.curves
    total += length(curve)
  end
  return total
end

# MultiLineString
function length(multilinestring::MultiLineString)
  total = 0
  for line in multilinestring.linestrings
    total += length(line)
  end
  return total
end

# MultiCurve
function length(multicurve::MultiCurve)
  total = 0
  for curve in multicurve.curves
    total += length(curve)
  end
  return curve
end
# GeometryCollection 
function length(geometrycollection::GeometryCollection)
  total = 0
  for geometry in geometrycollection.geometries
    total += geometry isa Union{Curve, MultiLineString, MultiCurve, GeometryCollection} ? length(geometry) : nothing
  end
  return total
end