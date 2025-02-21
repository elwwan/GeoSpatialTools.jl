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
  export BBox, bounding_box
  include("vector/envelope.jl")
  export envelope
end