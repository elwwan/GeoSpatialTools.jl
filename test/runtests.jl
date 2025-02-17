using GeoSpatialTools
using Test

@testset "Geometry types" begin
    # AbstractGeometry
    @test Point <: AbstractGeometry
    @test MultiPoint <: AbstractGeometry
    @test Polygon <: AbstractGeometry
    @test MultiPolygon <: AbstractGeometry
    @test LineString <: AbstractGeometry
    @test MultiLineString <: AbstractGeometry
    @test GeometryCollection <: AbstractGeometry
    
    # Point
    @test_throws MethodError Point(("0",0))
    @test_throws MethodError Point((0))
    @test_throws MethodError Point((0.0, 0))
    @test_throws MethodError Point((0, 0, 0))
    @test isa(Point((0,0)), Point)
    @test isa(Point((0.0,0.0)), Point)
    @test isa(Point((1/3, 1/25)), Point)
    @test Point((0,0)) == Point((0,0)) # Equality

    # MultiPoint
    @test_throws MethodError MultiPoint([Point((0,0), 0)])
    @test isa(MultiPoint([Point((0,0)), Point((0,0))]), MultiPoint)
    MultiPoint([Point((0,0)), Point((0,0))]) == MultiPoint([Point((0,0)), Point((0,0))]) # Equality


    # LineString
    @test_throws MethodError LineString([("0",0), (1,0)])
    @test_throws MethodError LineString([(0), (1,0)])
    @test_throws MethodError LineString([(0,0,0), (1,0)])
    @test_throws MethodError LineString([(0.0, 0), (1,0)])
    @test isa(LineString([(0,0), (1,0)]), LineString)
    @test isa(LineString([(0.0,0.0), (1.0,0.0)]), LineString)
    @test isa(LineString([(0,0), (1,0), (1,1), (0,1)]), LineString)
    @test LineString([(0,0), (1,0)]) == LineString([(0,0), (1,0)]) # Equality

    # MultiLineString
    @test_throws MethodError MultiLineString([LineString([(0,0), (1,0)]), "invalid"])
    @test isa(MultiLineString([LineString([(0,0), (1,0)])]), MultiLineString)
    multilinestring = MultiLineString([
        LineString([(0,0), (1,0)]),
        LineString([(2,2), (3,2)])
    ])
    @test isa(multilinestring, MultiLineString)
    @test multilinestring == multilinestring # Equality


    # Polygons
    @test_throws MethodError Polygon([[("0",0), (1,0), (1,1), (0,1)]])
    @test_throws MethodError Polygon([[(0), (1,0), (1,1), (0,1)]])
    @test_throws MethodError Polygon([[(0,0,0), (1,0), (1,1), (0,1)]])
    @test_throws MethodError Polygon([[(0.0, 0), (1,0), (1,1), (0,1)]])
    @test isa(Polygon([[(0,0), (1,0), (1,1), (0,1)]]), Polygon)
    @test isa(Polygon([[(0.0,0.0), (1.0,0.0), (1.0,1.0), (0.0,1.0)]]), Polygon)
    @test isa(Polygon([[(-1,-1), (2,-1), (2,2), (-1,2)], [(0,0), (1,0), (1,1), (0,1)]]), Polygon)
    @test isa(Polygon([[(-5,-5), (5,-5), (5,5), (-5,5)], [(-4,-4), (-2,-4), (-2,-2), (-4,-2)], [(2,2), (4,2), (4,4), (2,4)]]), Polygon)
    @test Polygon([[(0,0), (1,0), (1,1), (0,1)]]) == Polygon([[(0,0), (1,0), (1,1), (0,1)]]) # Equality
 
    # MultiPolygon
    @test_throws MethodError MultiPolygon([Polygon([[(0,0), (1,0), (1,1), (0,1)]]), "invalid"])
    @test isa(MultiPolygon([Polygon([[(0,0), (1,0), (1,1), (0,1)]])]), MultiPolygon)
    multipolygon = MultiPolygon([
        Polygon([[(0,0), (1,0), (1,1), (0,1)]]),
        Polygon([[(2,2), (3,2), (3,3), (2,3)]])
    ])
    @test isa(multipolygon, MultiPolygon)
    @test multipolygon == multipolygon # Equality

    
    # GeometryCollection
    @test_throws MethodError GeometryCollection(["invalid"])
    @test isa(GeometryCollection([
        Point((0,0)),
        LineString([(0,0), (1,0)]),
        Polygon([[(0,0), (1,0), (1,1), (0,1)]])
    ]), GeometryCollection)
    geometrycollection = GeometryCollection([
        MultiPoint([Point((0,0)), Point((1,1))]),
        MultiLineString([LineString([(0,0), (1,0)])]),
        MultiPolygon([Polygon([[(0,0), (1,0), (1,1), (0,1)]])])
    ])
    @test isa(geometrycollection, GeometryCollection)
    @test geometrycollection == geometrycollection # Equality

end

@testset "Area" begin
    @test_throws MethodError area(Point((0,0)))
    @test_throws MethodError area(MultiPoint([Point((0,0)), Point((0,0))]))
    @test_throws MethodError area(LineString([(0,0), (1,0)]))
    @test_throws MethodError area(MultiLineString([LineString([(0,0), (1,0)])]))

    #Polygon
    polygon1 = Polygon([[(-1,-1), (2,-1), (2,2), (-1,2)], [(0,0), (1,0), (1,1), (0,1)]])
    @test area(polygon1) == 8.0
    polygon2 = Polygon([[(6.31,5.41), (9.00,4.50), (11.00,0.50), (7.00,-2.50), (-3.00,-2.00), (-2.50,3.50), (3.00,6.50)]])
    @test area(polygon2) == 92.41499999999999
    @test area(polygon2, 2) == 92.42
    @test area(polygon2, 3) == 92.415

    #MultiPolygon
    @test area(MultiPolygon([polygon1, polygon2])) == 100.41499999999999
    @test area(MultiPolygon([polygon1, polygon2]), 2) == 100.42
    @test area(MultiPolygon([polygon1, polygon2]), 3) == 100.415
end

@testset "Length" begin
    @test_throws MethodError line_length(Point((0,0)))
    @test_throws MethodError line_length(MultiPoint([Point((0,0)), Point((0,0))]))
    @test_throws MethodError line_length(Polygon([[(0,0), (1,0), (1,1), (0,1)]]))
    @test_throws MethodError line_length(MultiPolygon([Polygon([[(0,0), (1,0), (1,1), (0,1)]]), Polygon([[(0,0), (1,0), (1,1), (0,1)]])]))

    @test line_length(LineString([(0,0), (0,1)])) == 1.0
    @test line_length(LineString([(0,0), (1,1)]), 5) == 1.41421

    @test line_length(MultiLineString([ LineString([(0,0), (0,1)]), LineString([(0,0), (0,1)]) ])) == 2.0
    @test line_length(MultiLineString([ LineString([(0,0), (0,1)]), LineString([(0,0), (1,1)]) ]), 5) == 2.41421
end

@testset "Bounding Box" begin
    # Point
    point = Point((0,0))
    @test bounding_box(point) == [0,0,0,0]
    point1 = Point((-5,5))
    @test bounding_box(point1) == [-5,5,-5,5]

    # MultiPoint
    multipoint = MultiPoint([point, point1]) 
    @test bounding_box(multipoint) == [-5.0, 0.0, 0.0, 5.0]

    # LineString

    linestring = LineString([(0,0), (1,1)])
    @test bounding_box(linestring) == [0,0,1,1]
    linestring1 = LineString([(5,5), (-8,-8)])
    @test bounding_box(MultiLineString([linestring, linestring1])) == [-8.0, -8.0, 5.0, 5.0]
end
