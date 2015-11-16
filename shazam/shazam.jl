cd("dropbox/computing")

using LSH
using DSP, WAV, PyPlot, LSH

s, fs = wavread("track1.wav");

# function which given a segment of wav file, returns its power spectrum
function gen_spec(s, window = hanning, h = 10)
   power(periodogram(s[1:round(Int, fs * h)] .* window(h * round(Int, fs))))
end

# the function that takes in a power spectrum, takes a range of fequency 
# (up to 5e4 here) , separates it into n(10 by default) non-overlapping 
# intervals and output the indices of the maximum in each interval

function pick_peaks(seg:: Vector{Float64}, n = 10, top = 50000)
  [findmax(seg[round(Int, i * floor(top/n) + 1): round(Int, (i+1)*floor(top/n))])[2] for i in 0:(n-1)]
end


# function that puts it together: takes in file name, compute the signature
# of the file by hashing the peaks of power spectrum in each (overlapping)
# window.

function gen_signature(file:: ASCIIString, fs:: Integer, hash = lsh, window = hanning, delta = 1, h = 10)
  s = wavread(file)
  [lsh(pick_peaks(gen_spec(s[round(Int, 1 + i * fs * delta) : round(Int, (i + 1) * fs * delta)]))) 
  for i in 0 : floor(size(s)[1] / (fs * delta) - h)]
end

