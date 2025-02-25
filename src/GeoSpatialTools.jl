module GeoSpatialTools
  include("vector/geometry_types.jl")
  export  Geometry,
          Curve,
          Surface,
          Point,
          MultiPoint,
          LineString,
          MultiLineString,
          CircularString,
          CompoundCurve,
          MultiCurve,
          Polygon,
          MultiPolygon,
          CurvePolygon,
          MultiSurface,
          GeometryCollection
  include("vector/bounding_box.jl")
  export BBox, merge_bbox, bounding_box
  include("vector/envelope.jl")
  export envelope
  include("vector/midpoint_radius_angle.jl")
  export midpoint_radius_angle
  include("vector/length.jl")
  export length
  include("vector/area.jl")
  export area
end