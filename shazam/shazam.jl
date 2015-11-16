cd("dropbox/computing")


using DSP, WAV, PyPlot

s, fs = wavread("music/Summer.wav");

# function which given a segment of wav file, returns its power spectrum
function gen_spec(s, Fs::Integer, window = hanning, h = 10)
   power(periodogram(s[1:round(Int, Fs * h)], window = window))
end

# gen_spec(s[1:10*fs], fs)

# the function that takes in a power spectrum, takes a range of fequency 
# (up to 5e4 here) , separates it into n(10 by default) non-overlapping 
# intervals and output the indices of the maximum in each interval

function pick_peaks(seg:: Vector{Float64}, n = 10, top = 50000)
  [findmax(seg[round(Int, i * floor(top/n) + 1): round(Int, (i+1)*floor(top/n))])[2] for i in 0:(n-1)]
end


# function that puts it together: takes in file name, compute the signature
# of the file by hashing the peaks of power spectrum in each (non-overlapping)
# window.

function gen_signature(file:: ASCIIString, hash = hash, window = hanning, delta = 1, h = 10)
  s, fs= wavread(file)
  fs = round(Int, fs)
  [hash(pick_peaks(gen_spec(s[round(Int, 1 + i * fs * delta) : round(Int, i * fs * delta + fs * h)], fs))) 
  for i in 0 : floor(size(s)[1] / (fs * delta) - h)]
end

# first try to store the music entries as hash tables in the RAM
function build_lib(folder:: ASCIIString)
  Music_lib = Dict()
  file_list = readdir(folder)
  for name in file_list[2 : end]
    println(string(folder,"/",name))
    for j in gen_signature(string(folder,"/",name))
      Music_lib[j] = name
    end
  end
  return Music_lib
end



function match_snippet(file:: ASCIIString, lib:: Dict)
  a = gen_signature(file)
  if all(map(x -> !haskey(lib, x), a))
    return("Song not in the library!")
  else
    #return(a[map(x -> haskey(lib, x), a)])
    return(lib[a[map(x -> haskey(lib, x), a)][1]])
  end
end


# I'll write the version with database instead of hashtable later.

# using it

music_lib = build_lib("music")
match_snippet("test.wav", music_lib)
