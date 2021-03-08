using StarTIN
using Test

@testset "StarTIN.jl" begin
    using StarTIN

    t = DT()
    points = rand(0.0:0.01:100.0, 3, Int(1e5))
    @test @time insert!(t, points) > 0

    points = rand(4, 100)
    @test_throws Exception insert!(t, points)

    @test !isnan(interpolate_linear(t, 0.5, 0.5))
    @test !isnan(interpolate_nn(t, 0.5, 0.5))
    @test !isnan(interpolate_laplace(t, 0.5, 0.5))

    fn = "test.obj"
    write!(fn, t)
    @test isfile(fn)

    @test info(t) == 0

end
