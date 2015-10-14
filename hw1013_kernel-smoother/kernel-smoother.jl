# There is a typo in the problem document, the estimated function value should be a
# kernel weighted average of Y, not X.


using Distances
using Gadfly
using Base.Test
using Distributions

function kernel_g(s)
  exp (- s^2 / 2) * 1/ sqrt(2 * pi)
end

function kernel_boxcar(s)
  if abs(s) <= 1
    return 1/2
  else
    return 0
  end
end

function smoother_factory(xs, ys, kernel, metric = euclidean)
  if length(xs) != length(ys)
    throw(ArgumentError("X Y not of same length!"))
  end
  if typeof(kernel) != Function
    throw(ArgumentError("Kernel should be a function!"))
  end
  if typeof(metric) != Function
    throw(ArgumentError("Metric should be a function!"))
  end

  xs = float(xs)
  ys = float(ys)

  function make_smoother(bandwidth)
    if bandwidth < 0
      throw(ArgumentError("Negative bandwidth!"))
    end

    function smoother(x)
      x = float(x)
      w = [kernel(metric(xi, x) / bandwidth) for xi in xs]
      return sum(ys .* w) / sum(w)
    end
    function smoother_v(x)
      return [smoother(xx) for xx in x]
    end
    return smoother_v
  end
  return make_smoother
end



function make_kernel_smoother(xs, ys, bandwidth, kernel, metric = euclidean)
  xs = float(xs)
  ys = float(ys)
  function smoother(x)
    x = float(x)
    w = [kernel(metric(xi, x) / bandwidth) for xi in xs]
    return sum(ys .* w) / sum(w)
  end
  function smoother_v(x)
    return [smoother(xx) for xx in x]
  end
  return smoother_v
end


## testing for kernel functions

# plot([kernel_g, kernel_boxcar], -3, 3)
@test all([kernel_boxcar(xi) for xi in linspace(-1, 1, 10)] .== 1/2) ==true
@test all([kernel_boxcar(xi) for xi in linspace(-10, -1.01, 20)] .== 0) ==true
@test all([kernel_boxcar(xi) for xi in linspace(1.01, 10, 20)] .== 0) ==true



## testing for smoother_factory and make_kernel_smoother

## using the fact that if we set the bandwidth < 1 with boxcar kernel and set xs
## to be evenly spaced with distance 1, the smoothed vector should be the same as
## the input y vector
@test_throws ArgumentError smoother_factory([1, 2], [1, 2, 3], kernel_g)
@test_throws ArgumentError smoother_factory([1, 2, 3], [1, 2, 3], 2)

xs = linspace(-50, 50, 101)
ys = [rand(Normal(0, 1)) for xi in xs]
k = make_kernel_smoother(xs, ys, 0.8, kernel_boxcar)

@test k(xs) == ys
factory = smoother_factory(xs, ys, kernel_boxcar)
l = factory(0.5)
@test l(xs) == ys
