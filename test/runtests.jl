using GeoSpatialTools
using Test

@testset "Geometry types" begin
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
