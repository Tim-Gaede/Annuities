using Test

include("annuities.jl")

# Tests adapted from `problem-specifications//canonical-data.json` @ v1.1.0

println("\n"^3, "-"^60, "\n")

@testset "5.3% interest over 20 payments.............." begin
    @test annuityRatio(5.3, 20) ≈ 1.7066994798369612
end
println("\n")

@testset "0.0% interest over 25 payments.............." begin
    @test annuityRatio(0.0, 25) ≈ 1
end
println("\n")

@testset "-5.0% interest over 10 payments............." begin
    @test annuityRatio(-5.0, 10) ≈ 0.8025261215232422
end
println("\n")


@testset "One payout throws DomainError..............." begin
    @test_throws DomainError annuityRatio(5.3, 1)
end
println("\n")

@testset "Negative 150% interest throws DomainError..." begin
    @test_throws DomainError annuityRatio(-150.0, 25)
end
println("\n")

@testset "A dozen random combinations of annuities...." begin
    for comparison = 1 : 12
        ratio = 1.1 + 3rand()
        n = rand(2 : 30)

        @test annuityRatio(annuityAPR(ratio, n), n) ≈ ratio
    end
end
println("\n")
