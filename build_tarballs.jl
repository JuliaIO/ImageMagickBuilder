# Note that this script can accept some limited command-line arguments, run
# `julia build_tarballs.jl --help` to see a usage message.
using BinaryBuilder

# Collection of sources required to build ImageMagick
sources = [
    "https://github.com/ImageMagick/ImageMagick6.git" =>
    "00097eb42c2ea812d4a26e6683b000d4354f5fad",

]

# Bash recipe for building across all platforms
script = raw"""
cd $WORKSPACE/srcdir
cd ImageMagick6/
./configure --prefix=$prefix --host=$target
make -j${nproc}
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
    FreeBSD(:x86_64)
]

# The products that we will ensure are always built
products(prefix) = [
    LibraryProduct(prefix, "libMagickWand", :libmagick),
    LibraryProduct(prefix, "libMagickCore", :libmagickcore),
    LibraryProduct(prefix, "libMagick++", :libmagickwand)
]

# Dependencies that must be installed before this package can be built
dependencies = [
    
]

# Build the tarballs, and possibly a `build.jl` as well.
build_tarballs(ARGS, "ImageMagick", sources, script, platforms, products, dependencies)

