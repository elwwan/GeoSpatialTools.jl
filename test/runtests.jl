using GeoSpatialTools
using Test

@testset "Geometry types" begin
    @testset "Type defenition" begin
        # Test types
        @test Curve <: Geometry
        @test Surface <: Geometry
        @test Point <: Geometry
        @test MultiPoint <: Geometry
        @test LineString <: Curve
        @test MultiLineString <: Geometry
        @test CircularString <: Curve
        @test CompoundCurve <: Curve
        @test MultiCurve <: Geometry
        @test Polygon <: Surface
        @test MultiPolygon <: Geometry
        @test CurvePolygon <: Surface
        @test MultiSurface <: Geometry
        @test GeometryCollection <: Geometry
    end
    @testset "Equality test" begin
        # Point tests
        p1 = Point(1, 2)
        p2 = Point(1, 2, 3)
        p3 = Point(1, 2, 3, 4)
        
        @test p1.x == 1 && p1.y == 2
        @test p2.z == 3 && p2.m === nothing
        @test p1 == Point(1, 2)
        @test p1 != Point(2, 1)
        
        # LineString tests
        ls1 = LineString([Point(0, 0), Point(1, 1)])
        ls2 = LineString([Point(0, 0), Point(2, 2)])
        
        @test ls1.points[2] == Point(1, 1)
        @test ls1 == LineString([Point(0, 0), Point(1, 1)])
        @test ls1 != ls2
        
        # CircularString tests
        cs1 = CircularString([Point(0, 0), Point(1, 1), Point(2, 0)])
        cs2 = CircularString([Point(0, 0), Point(1, 1), Point(2, 1)])
        
        @test cs1.points[2] == Point(1, 1)
        @test cs1 == CircularString([Point(0, 0), Point(1, 1), Point(2, 0)])
        @test cs1 != cs2
        
        # CompoundCurve tests
        cc1 = CompoundCurve([ls1, cs1])
        cc2 = CompoundCurve([ls2, cs1])
        
        @test cc1.curves[1] == ls1
        @test cc1 == CompoundCurve([ls1, cs1])
        @test cc1 != cc2
        
        # Polygon tests
        outer = LineString([Point(0, 0), Point(10, 0), Point(10, 10), Point(0, 10), Point(0, 0)])
        inner = LineString([Point(2, 2), Point(8, 2), Point(8, 8), Point(2, 8), Point(2, 2)])
        poly1 = Polygon(outer)
        poly2 = Polygon(outer, [inner])
        
        @test poly1.outer_ring == outer
        @test poly1 == Polygon(outer)
        @test poly1 != poly2
        
        # CurvePolygon tests
        cp1 = CurvePolygon(cs1)
        cp2 = CurvePolygon(cs1, [ls1])
        
        @test cp1.outer_ring == cs1
        @test cp1 == CurvePolygon(cs1)
        @test cp1 != cp2
        
        # MultiSurface tests
        ms1 = MultiSurface([poly1, cp1])
        ms2 = MultiSurface([poly2, cp1])
        
        @test ms1.surfaces[1] == poly1
        @test ms1 == MultiSurface([poly1, cp1])
        @test ms1 != ms2
        
        # MultiPolygon tests
        mp1 = MultiPolygon([poly1, poly2])
        mp2 = MultiPolygon([poly2])
        
        @test mp1.polygons[1] == poly1
        @test mp1 == MultiPolygon([poly1, poly2])
        @test mp1 != mp2
        
        # MultiCurve tests
        mc1 = MultiCurve([ls1, cs1])
        mc2 = MultiCurve([ls2, cs1])
        
        @test mc1.curves[1] == ls1
        @test mc1 == MultiCurve([ls1, cs1])
        @test mc1 != mc2
        
        # MultiLineString tests
        mls1 = MultiLineString([ls1, ls2])
        mls2 = MultiLineString([ls2])
        
        @test mls1.linestrings[1] == ls1
        @test mls1 == MultiLineString([ls1, ls2])
        @test mls1 != mls2
        
        # MultiPoint tests
        mp1 = MultiPoint([p1, p2])
        mp2 = MultiPoint([p2, p3])
        
        @test mp1.points[1] == p1
        @test mp1 == MultiPoint([p1, p2])
        @test mp1 != mp2
        
        # GeometryCollection tests
        gc1 = GeometryCollection([p1, ls1])
        gc2 = GeometryCollection([p1, cs1])
        
        @test gc1.geometries[2] == ls1
        @test gc1 == GeometryCollection([p1, ls1])
        @test gc1 != gc2
    end
end

@testset "Bounding Box" begin
    @testset "Merging bounding box and equality" begin
        a = BBox(0,0,0,0)
        b = BBox(0,0,0,0)
        @test a == b
        b = BBox(2,2,2,2)
        c = merge_bbox(a,b)
        @test c == BBox(0,0,2,2)
    end
    @testset "Bounding Box from Geometry" begin
    end
end