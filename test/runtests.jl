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

    # MultiPoint
    @test_throws MethodError MultiPoint([Point((0,0), 0)])
    @test isa(MultiPoint([Point((0,0)), Point((0,0))]), MultiPoint)

    # Polygons
    @test_throws MethodError Polygon([[("0",0), (1,0), (1,1), (0,1)]])
    @test_throws MethodError Polygon([[(0), (1,0), (1,1), (0,1)]])
    @test_throws MethodError Polygon([[(0,0,0), (1,0), (1,1), (0,1)]])
    @test_throws MethodError Polygon([[(0.0, 0), (1,0), (1,1), (0,1)]])
    @test isa(Polygon([[(0,0), (1,0), (1,1), (0,1)]]), Polygon)
    @test isa(Polygon([[(0.0,0.0), (1.0,0.0), (1.0,1.0), (0.0,1.0)]]), Polygon)
    @test isa(Polygon([[(-1,-1), (2,-1), (2,2), (-1,2)], [(0,0), (1,0), (1,1), (0,1)]]), Polygon)
    @test isa(Polygon([[(-5,-5), (5,-5), (5,5), (-5,5)], [(-4,-4), (-2,-4), (-2,-2), (-4,-2)], [(2,2), (4,2), (4,4), (2,4)]]), Polygon)

    # MultiPolygon
    @test_throws MethodError MultiPolygon([Polygon([[(0,0), (1,0), (1,1), (0,1)]]), "invalid"])
    @test isa(MultiPolygon([Polygon([[(0,0), (1,0), (1,1), (0,1)]])]), MultiPolygon)
    @test isa(MultiPolygon([
        Polygon([[(0,0), (1,0), (1,1), (0,1)]]),
        Polygon([[(2,2), (3,2), (3,3), (2,3)]])
    ]), MultiPolygon)

    # LineString
    @test_throws MethodError LineString([("0",0), (1,0)])
    @test_throws MethodError LineString([(0), (1,0)])
    @test_throws MethodError LineString([(0,0,0), (1,0)])
    @test_throws MethodError LineString([(0.0, 0), (1,0)])
    @test isa(LineString([(0,0), (1,0)]), LineString)
    @test isa(LineString([(0.0,0.0), (1.0,0.0)]), LineString)
    @test isa(LineString([(0,0), (1,0), (1,1), (0,1)]), LineString)

    # MultiLineString
    @test_throws MethodError MultiLineString([LineString([(0,0), (1,0)]), "invalid"])
    @test isa(MultiLineString([LineString([(0,0), (1,0)])]), MultiLineString)
    @test isa(MultiLineString([
        LineString([(0,0), (1,0)]),
        LineString([(2,2), (3,2)])
    ]), MultiLineString)

    # GeometryCollection
    @test_throws MethodError GeometryCollection(["invalid"])
    @test isa(GeometryCollection([
        Point((0,0)),
        LineString([(0,0), (1,0)]),
        Polygon([[(0,0), (1,0), (1,1), (0,1)]])
    ]), GeometryCollection)
    @test isa(GeometryCollection([
        MultiPoint([Point((0,0)), Point((1,1))]),
        MultiLineString([LineString([(0,0), (1,0)])]),
        MultiPolygon([Polygon([[(0,0), (1,0), (1,1), (0,1)]])])
    ]), GeometryCollection)
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

