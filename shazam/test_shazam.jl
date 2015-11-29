# testing the shazam script
# I have a folder named "music" in the work directory
# and the file "test.wav" is the first ten seconds
# taken from one of the wav files.
using Base.Test
include("shazam.jl")

@test length(gen_spec(s[1:10*fs], fs)) == fs

music_lib = build_lib("music")
match_snippet("test.wav", music_lib)

# still need to add codes to this part