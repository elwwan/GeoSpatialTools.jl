module GeoSpatialTools
  include("vector/geometry_types.jl")
  export  AbstractGeometry,
          Point, 
          MultiPoint, 
          Polygon, 
          MultiPolygon, 
          LineString, 
          MultiLineString, 
          GeometryCollection
  include("vector/area.jl")
  export area
  include("vector/length.jl")
  export line_length

end
