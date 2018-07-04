# Note that this script can accept some limited command-line arguments, run
# `julia build_tarballs.jl --help` to see a usage message.
using BinaryBuilder
name = "ImageMagick"
version = v"6.9.10-4"
# Collection of sources required to build imagemagick
sources = [
    "https://github.com/ImageMagick/ImageMagick6.git" =>
    "7a09d9b3acf12742bed4fe8d8975b78c6f4acdb4",
]

# Bash recipe for building across all platforms
script = raw"""
cd $WORKSPACE/srcdir
cd ImageMagick6/
./configure --prefix=$prefix --host=$target
make -j${ncore}
make install
exit
"""

# These are the platforms we will build for by default, unless further
# platforms are passed in on the command line
platforms = [
    Linux(:i686, :glibc),
    Linux(:x86_64, :glibc),
    Linux(:aarch64, :glibc),
    Linux(:armv7l, :glibc, :eabihf),
    Linux(:powerpc64le, :glibc),
    Linux(:i686, :musl),
    Linux(:x86_64, :musl),
    Linux(:aarch64, :musl),
    Linux(:armv7l, :musl, :eabihf),
    MacOS(:x86_64),
    FreeBSD(:x86_64),
    Windows(:i686),
    Windows(:x86_64)
]

# The products that we will ensure are always built
products(prefix) = [
    LibraryProduct(prefix, "libMagickWand", :libwand),
]

# Dependencies that must be installed before this package can be built
dependencies = [
    "https://github.com/bicycle1885/ZlibBuilder/releases/download/v1.0.1/build_Zlib.v1.2.11.jl",
    "https://github.com/SimonDanisch/LibpngBuilder/releases/download/v1.6.31/build_libpng.v1.0.0.jl",
    "https://github.com/SimonDanisch/LibJPEGBuilder/releases/download/v9b/build_libjpeg.v9.0.0-b.jl",
    "https://github.com/SimonDanisch/LibTIFFBuilder/releases/download/v4.0.9/build_libtiff.v4.0.9.jl"
]

# Build the tarballs, and possibly a `build.jl` as well.
build_tarballs(ARGS, name, version, sources, script, platforms, products, dependencies)
