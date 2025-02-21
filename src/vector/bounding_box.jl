# Bounding Box
mutable struct BBox
  minx::Real
  miny::Real
  maxx::Real
  maxy::Real
end

function merge_bbox(a::BBox, b::BBox)
  return BBox(
      min(a.minx, b.minx),
      min(a.miny, b.miny),
      max(a.maxx, b.maxx),
      max(a.maxy, b.maxy)
  )
end

# Point
function bounding_box(point::Point)
  return BBox(point.x, point.y, point.x, point.y)
end

# Curves
# LineString
function bounding_box(linestring::LineString)
  bbox = BBox(Inf, Inf, -Inf, -Inf)
  for point in linestring.points
      bbox = merge_bbox(bbox, bounding_box(point))
  end
  return bbox
end

# CircularString
function bounding_box(circular_string::CircularString)
  bbox = BBox(Inf, Inf, -Inf, -Inf)

  # Define inner functions for geometric calculations
  function compute_circle_center_and_radius(p1, p2, p3)
      x1, y1 = p1.x, p1.y
      x2, y2 = p2.x, p2.y
      x3, y3 = p3.x, p3.y

      D = 2 * (x1*(y2 - y3) + x2*(y3 - y1) + x3*(y1 - y2))
      if D ≈ 0
          throw(ArgumentError("Colinear points cannot define a circle"))
      end

      A = x1^2 + y1^2
      B = x2^2 + y2^2
      C = x3^2 + y3^2

      cx = (A*(y2 - y3) + B*(y3 - y1) + C*(y1 - y2)) / D
      cy = (A*(x3 - x2) + B*(x1 - x3) + C*(x2 - x1)) / D
      r = sqrt((x1 - cx)^2 + (y1 - cy)^2)
      return (cx, cy), r
  end

  function compute_angle(point, center)
      dx = point.x - center[1]
      dy = point.y - center[2]
      atan2(dy, dx)
  end

  function determine_arc_direction(p1, p2, p3)
      v1x = p2.x - p1.x
      v1y = p2.y - p1.y
      v2x = p3.x - p2.x
      v2y = p3.y - p2.y

      cross = v1x * v2y - v1y * v2x
      if cross > 0
          :counterclockwise
      elseif cross < 0
          :clockwise
      else
          throw(ArgumentError("Colinear points cannot determine arc direction"))
      end
  end

  function compute_arc_bounding_box(p1, p2, p3)
      center, radius = compute_circle_center_and_radius(p1, p2, p3)
      θ1 = compute_angle(p1, center)
      θ3 = compute_angle(p3, center)
      direction = determine_arc_direction(p1, p2, p3)

      # Adjust angles based on direction
      if direction == :counterclockwise
          θ3 < θ1 && (θ3 += 2π)
      else
          θ3 > θ1 && (θ3 -= 2π)
      end

      # Check critical angles (0, π/2, π, 3π/2) within the arc's range
      critical_angles = [0.0, π/2, π, 3π/2]
      if direction == :counterclockwise
          relevant_angles = [θ for θ in critical_angles if θ1 <= θ <= θ3]
      else
          relevant_angles = [θ for θ in critical_angles if θ3 <= θ <= θ1]
      end
      push!(relevant_angles, θ1, θ3)
      unique!(relevant_angles)
      sort!(relevant_angles)

      # Generate points at relevant angles and endpoints
      points = [Point(center[1] + radius*cos(θ), center[2] + radius*sin(θ)) for θ in relevant_angles]
      push!(points, p1, p3)

      # Compute bounding box for this arc
      minx = minimum(point.x for point in points)
      maxx = maximum(point.x for point in points)
      miny = minimum(point.y for point in points)
      maxy = maximum(point.y for point in points)
      return BBox(minx, miny, maxx, maxy)
  end

  # Iterate over each arc in the CircularString
  for i in 1:(length(circular_string.points) - 2)
      p1 = circular_string.points[i]
      p2 = circular_string.points[i+1]
      p3 = circular_string.points[i+2]
      arc_bbox = compute_arc_bounding_box(p1, p2, p3)
      bbox = merge_bbox(bbox, arc_bbox)
  end

  return bbox
end

# CompoundCurve
function bounding_box(compound_curve::CompoundCurve)
  bbox = BBox(Inf, Inf, -Inf, -Inf)
  for curve in compound_curve.curves
      bbox = merge_bbox(bbox, bounding_box(curve))
  end
  return bbox
end

# Surfaces
# Polygon
function bounding_box(polygon::Polygon)
  return bounding_box(polygon.outer_ring)
end

# CurvePolygon
function bounding_box(curve_polygon::CurvePolygon)
  bbox = BBox(Inf, Inf, -Inf, -Inf)
  for curve in curve_polygon.outer_ring
      bbox = merge_bbox(bbox, bounding_box(curve))
  end
  return bbox
end

# Collections
# MultiPoint
function bounding_box(multipoint::MultiPoint)
  bbox = BBox(Inf, Inf, -Inf, -Inf)
  for point in multipoint.points
      bbox = merge_bbox(bbox, bounding_box(point))
  end
  return bbox
end

# MultiLineString
function bounding_box(multi_line_string::MultiLineString)
  bbox = BBox(Inf, Inf, -Inf, -Inf)
  for linestring in multi_line_string.linestrings
      bbox = merge_bbox(bbox, bounding_box(linestring))
  end
  return bbox
end

# MultiCurve
function bounding_box(multi_curve::MultiCurve)
  bbox = BBox(Inf, Inf, -Inf, -Inf)
  for curve in multi_curve.curves
      bbox = merge_bbox(bbox, bounding_box(curve))
  end
  return bbox
end

# MultiPolygon
function bounding_box(multi_polygon::MultiPolygon)
  bbox = BBox(Inf, Inf, -Inf, -Inf)
  for polygon in multi_polygon.polygons
      bbox = merge_bbox(bbox, bounding_box(polygon))
  end
  return bbox
end

# MultiSurface
function bounding_box(multi_surface::MultiSurface)
  bbox = BBox(Inf, Inf, -Inf, -Inf)
  for surface in multi_surface.surfaces
      bbox = merge_bbox(bbox, bounding_box(surface))
  end
  return bbox
end

# GeometryCollection
function bounding_box(geometry_collection::GeometryCollection)
  bbox = BBox(Inf, Inf, -Inf, -Inf)
  for geometry in geometry_collection.geometries
      bbox = merge_bbox(bbox, bounding_box(geometry))
  end
  return bbox
end