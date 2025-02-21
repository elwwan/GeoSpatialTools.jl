
# Enveloppe

# From bounding_box
function envelope(bbox::BBox)
  return Polygon(LineString([
    Point(bbox.minx, bbox.miny),
    Point(bbox.maxx, bbox.miny),
    Point(bbox.maxx, bbox.maxy),
    Point(bbox.minx, bbox.maxy),
    Point(bbox.minx, bbox.miny),
  ]))
end

# From geometry
function envelope(geometry::Geometry)
  return envelope(bounding_box(geometry))
end
