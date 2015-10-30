using Distances
using KDTrees
using Colors
using ImageView
using Images
using Base.Test

cd("images")

function labRead(file)
  img = imread(file)
  imglab = convert(Image{Lab}, float32(img))
  return imglab
end

function colorAverage(Image)
  l = mean([pixel.l for pixel in Image])
  a = mean([pixel.a for pixel in Image])
  b = mean([pixel.b for pixel in Image])
  Lab{Float32}(l, a, b)
end

function extractVal(color::Lab)
  return [float64(color.l), float64(color.a), float64(color.b)]
end

function mosaic_color_mathcer(target, source)
  avgColor = reduce(hcat,map(x -> extractVal(colorAverage(labRead(x))), source))
  tree = KDTree(avgColor)
  id = knn(tree, target, 1)[1][1]
  return labRead(source[id])
end

source = readdir()[2:end]
for file in source
  @test labRead(file) == mosaic_color_mathcer(extractVal(colorAverage(labRead(file))), source)
end
