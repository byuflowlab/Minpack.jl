# Minpack

Julia wrapper to the fortran MINPACK library used for solving systems of nonlinear equations.  Currently I have wrapped only hybrd (which is the default method used in scipy.optimize.root), though wrapping others (like the  Levenberg-Marquardt algorithm) would be straightforward to add.

[![Build Status](https://travis-ci.org/byuflowlab/Minpack.jl.svg?branch=master)](https://travis-ci.org/byuflowlab/Minpack.jl)

[![Coverage Status](https://coveralls.io/repos/byuflowlab/Minpack.jl/badge.svg?branch=master&service=github)](https://coveralls.io/github/byuflowlab/Minpack.jl?branch=master)

[![codecov.io](http://codecov.io/github/byuflowlab/Minpack.jl/coverage.svg?branch=master)](http://codecov.io/github/byuflowlab/Minpack.jl?branch=master)

After Pkg.clone(...) be sure to do a Pkg.build("Minpack") to build the fortran dependencies (windows not supported).
