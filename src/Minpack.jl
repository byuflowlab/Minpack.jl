module Minpack
# created Summer 2015
# Andrew Ning

export hybrd

function residual_wrapper(nw::Ptr{Cint}, xw::Ptr{Cdouble}, fw::Ptr{Cdouble}, iflag::Ptr{Cint})
    """
    Callback function from hybrd.  Unpacks the Fortran pointers, calls a
    residual function written in Julia, then stores results in another Fortran
    pointer.
    """

    # initialize
    nvec = unsafe_load(nw)  # length of arrays
    xvec = zeros(nvec)  # initialize copy

    # copy x values into Julia
    for i = 1:nvec
        xvec[i] = unsafe_load(xw, i)
    end

    # call residual function
    # note that res and res_args are global b.c. hybrd does not provide a
    # hook to pass arbitrary data through.  same approach used in scipy.optimize
    fvec = res(xvec, res_args...)

    # copy f values into C pointer
    for i = 1:nvec
        unsafe_store!(fw, fvec[i], i)
    end

    return
end


function hybrd(residual, x0, args, tol=1e-8)
    """
    Inputs
    ------
    residual : function
        function handle to a function of the form
        out = residual(x, arg1, arg2, ...)
        where out is an array that should equal all zeros
        x is the evaluation point and
        arg1, ... are other necessary parameters

    x0 : array
        an initial estimate of the solution vector

    args : tuple of other arguments that residual takes (arg1, arg2, ...)

    tol : float
        nonnegative input variable. termination occurs
        when the algorithm estimates that the relative error
        between x and the solution is at most tol.

    Outputs
    -------
    x : array of length(x0)
        the final estimate of the solution vector.

    f : array of length(x0)
        contains the functions evaluated at the output x.
    """

    # initialize
    info_in = Cint[0]  # need to set as C pointer to get data back
    x = copy(x0)  # copy so we don't modify input
    n = length(x)
    f = zeros(x)
    lwa = round(Int, (n*(3*n+13))/2)  # cast to int
    wa = zeros(lwa)

    # unfortunately using global vars is necessary because minpack does not
    # provide hooks to pass arbitrary pointers as many modern C/fortran
    # functions do. Note that scipy.optimize uses global variables for this same
    # purpose.

    global res = residual
    global res_args = args

    # define the callback function
    const res_func = cfunction(residual_wrapper, Void, (Ptr{Cint}, Ptr{Cdouble},
        Ptr{Cdouble}, Ptr{Cint}))

    # call hybrd.  must pass by reference for Fortran
    # compilation command I used (OS X with gfortran):
    # gfortran -shared -O2 *.f -o libhybrd.dylib -fPIC
    ccall( (:hybrd1_, "deps/src/libhybrd"), Void, (Ref{Void}, Ref{Cint}, Ref{Cdouble},
        Ref{Cdouble}, Ref{Cdouble}, Ref{Cint}, Ref{Cdouble}, Ref{Cint}),
        res_func, n, x, f, tol, info_in, wa, lwa)
    info = info_in[1]  # extract termination info

    if info == 0
        error("improper input parameters.")
    elseif info == 2
        warn("number of calls to fcn has reached or exceeded 200*(n+1).")
    elseif info == 3
        warn("tol is too small. no further improvement in the approximate solution x is possible.")
    elseif info == 4
        warn("iteration is not making good progress.")
    end

    return x, f
end

end # module
