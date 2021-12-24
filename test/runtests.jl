using StarTIN
using Test

@testset "StarTIN.jl" begin
    using StarTIN

    t = DT()

    # Insert multiple points
    points = rand(0.0:0.01:100.0, 3, Int(1e5))
    @test @time insert!(t, points) > 0

    # Insert single point
    @test @time insert!(t, [50.0, 50.0, 50.0]) > 0

    # Insert invalid points
    points = rand(4, 100)
    @test_throws Exception insert!(t, points)
    @test_throws Exception insert!(t, [1.0, 2.0])

    # Test removal
    pid = insert!(t, [51.0, 51.0, 50.0])
    @test delete!(t, pid) == 0

    # Test tolerance
    @test get_snap_tolerance(t) == 0.001
    @test set_snap_tolerance!(t, 0.00001) == 0.00001

    # Test interpolation
    @test !isnan(interpolate_linear(t, 0.5, 0.5))
    @test !isnan(interpolate_nn(t, 0.5, 0.5))
    @test !isnan(interpolate_nni(t, 0.5, 0.5))
    @test !isnan(interpolate_laplace(t, 0.5, 0.5))

    fn = "test.obj"
    write!(fn, t)
    @test isfile(fn)

    @test info(t) == 0

end
