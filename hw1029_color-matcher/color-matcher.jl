using Distances
using KDTrees
using Colors
using ImageView
using Images
using Base.Test

#cd("dropbox/computing/images")

function lab_read(file)
  img = imread(file)
  imglab = convert(Image{Lab}, float64(img))
  return imglab
end

function color_average(Image)
  l = mean([pixel.l for pixel in Image])
  a = mean([pixel.a for pixel in Image])
  b = mean([pixel.b for pixel in Image])
  return [l, a, b]
end

function mosaic_color_matcher(target, source)
  avgColor = reduce(hcat,map(x -> color_average(lab_read(x)), source))
  tree = KDTree(avgColor)
  id = knn(tree, target, 1)[1][1]
  return lab_read(source[id])
end

source = readdir()[2:end]
for file in source
  @test lab_read(file) == mosaic_color_matcher(color_average(lab_read(file)), source)
end
