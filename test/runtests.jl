using Minpack: hybrd
using Base.Test

@testset "analytic" begin

function residual(xvec, arg1, arg2)

    fvec = zeros(xvec)

    fvec[1] = xvec[1] - arg1
    fvec[2] = xvec[1] + xvec[2] - arg2

    return fvec
end

x0 = [1.0, 0.0]
args = (3.0, 1.0)
tol = 1e-8

x, f = hybrd(residual, x0, args, tol)


@test isapprox(x[1], 3.0; atol=1e-8)
@test isapprox(x[2], -2.0; atol=1e-8)
@test isapprox(f[1], 0.0; atol=1e-8)
@test isapprox(f[2], 0.0; atol=1e-8)


function residual2(xvec)

    fvec = zeros(xvec)

    fvec[1] = exp(-exp(-(xvec[1]+xvec[2]))) - xvec[2]*(1+xvec[1]^2)
    fvec[2] = xvec[1]*cos(xvec[2]) + xvec[2]*sin(xvec[1]) - 0.5

    return fvec
end

x0 = [0.0, 0.0]
args = ()
tol = 1e-8

x, f = hybrd(residual2, x0, args, tol)


@test isapprox(x[1], 0.3532; atol=1e-4)
@test isapprox(x[2], 0.6061; atol=1e-4)
@test isapprox(f[1], 0.0; atol=1e-8)
@test isapprox(f[2], 0.0; atol=1e-8)

end  # test set
