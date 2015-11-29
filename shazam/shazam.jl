cd("dropbox/computing")


using DSP, PyPlot, WAV

# function which given a segment of wav file, returns its power spectrum
function gen_spec(s, sample_freq::Integer, window = hanning)
   power(periodogram(s, window = window))
end

# the function that takes in a power spectrum, takes a range of fequency 
# (up to 5e4 here) , separates it into n(10 by default) non-overlapping 
# intervals and output the indices of the maximum in each interval

function pick_peaks(seg:: Vector{Float64}, n = 10, top = 50000)
  [findmax(seg[round(Int, i * floor(top/n) + 1): round(Int, (i+1)*floor(top/n))])[2] for i in 0:(n-1)]
end


# function that puts it together: takes in file name, compute the signature
# of the file by hashing the peaks of power spectrum in each (non-overlapping)
# window.

function gen_signature(file::AbstractString, hashfn = hash, window = hanning, delta = 1, h = 10)
  s, fs= wavread(file)
  fs = round(Int, fs)
  [hashfn(pick_peaks(gen_spec(s[round(Int, 1 + i * fs * delta) : round(Int, i * fs * delta + fs * h)], fs))) 
  for i in 0 : floor(size(s)[1] / (fs * delta) - h)]
end

# Storing the music entries as hash tables in the RAM
# This is a easier version of what I'm trying to do
# without using Redis.
function build_lib(folder::AbstractString)
  Music_lib = Dict{UInt64, AbstractString}
  file_list = readdir(folder)
  for name in file_list[2 : end]
    fname = "$folder/$name"
    println(fname)
    for hashval in gen_signature(fname)
      Music_lib[hashval] = name
    end
  end
  return Music_lib
end



function match_snippet(file::AbstractString, lib::Dict)
  hashval = gen_signature(file)
  if all(x -> !haskey(lib, x), a)
    throw(ArgumentError("Song is not in the library!"))
  else
    return(lib[hashval[map(x -> haskey(lib, x), hashval)][1]])
  end
end


# Database version

# Pkg.clone("https://github.com/jkaye2012/Redis.jl")
using Redis

conn = RedisConnection()
# this still doesn't work since the package isn't in sync
# with Julia 0.4

function build_lib_db!(folder::AbstractString, conn)
  file_list = readdir(folder)
  for name in file_list[2 : end]
    println(string(folder,"/",name))
    for j in gen_signature(string(folder,"/",name))
      set(conn, string(j), name)
    end
  end
end

function match_snippet(file::AbstractString, db::Redis.RedisConnection)
  hashval = gen_signature(file)
  if !exists(conn, hashval)
    throw(ArgumentError("Song is not in the library!"))
  else
    return(get(conn, hashval))
  end
end

