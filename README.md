# Mandelbrot Shootout!

Pit ASCII art Mandelbrot set renderers against each other.

## Mandelbrot Renderer

Each Mandelbrot renderer should generate an ASCII art view of a
specified subplane of the Mandelbrot set at a particular resolution:

    mandelbrot [TOPLEFT BOTTOMRIGHT WIDTH HEIGHT]

The corner coordinates should be complex numbers (per the understanding
of the language in question) and resolution must be an integral number
of characters. By default, the renderer will output a 99×33 character
image of -2+i to 1-1i.

"Colourisation" is based on the number of iterations, at each point,
until the absolute value exceeds 2 (or the bailout value of 100
iterations). The following palette is used:

   Iterations | Swatch
  :----------:|:------:
  1           |   `.`
  2           |   `'`
  3           |   `,`
  4           |   `;`
  5           |   `"`
  6           |   `o`
  7           |   `O`
  8           |   `%`
  9           |   `8`
  10          |   `@`
  11-99       |   `#`
  100         |   ` `

Ideally a tester for conforming implementations should be written...but
life's too short. By default, you'll get something like this:

    .........'''''''',,,,,,,,,,,,,,,,,,,,,,,,,,,;;;;;;;;;""""oo%@#8@##o";;;;;;;,,,,,,,'''''''''''''''''
    ........''''''',,,,,,,,,,,,,,,,,,,,,,,,,,;;;;;;;;;;;""""oOO%@###8Ooo"";;;;;;;,,,,,,,'''''''''''''''
    .......'''''',,,,,,,,,,,,,,,,,,,,,,,,,;;;;;;;;;;;;""""oo%@###  ##88o"""";;;;;;;,,,,,,,'''''''''''''
    ......''''',,,,,,,,,,,,,,,,,,,,,,,,,;;;;;;;;;;;""""oooO%8# #    ###%oo""""";;;;;,,,,,,,,'''''''''''
    .....'''',,,,,,,,,,,,,,,,,,,,,,,,;;;;;;;;;;;"""oooooOOO%@#       ##%OOooo""""";;;,,,,,,,,,'''''''''
    ....''',,,,,,,,,,,,,,,,,,,,,,,,;;;;;;;;;""""o@88#@%%8@@@###     ###@8@#%OooOO#O";;,,,,,,,,,,'''''''
    ....'',,,,,,,,,,,,,,,,,,,,,,;;;;;;;"""""""ooO@######## #              ##88#@##8%";;,,,,,,,,,,''''''
    ...'',,,,,,,,,,,,,,,,,,,,,;;;;""""""""""oooO%8##                         #   ##O"";;,,,,,,,,,,'''''
    ...',,,,,,,,,,,,,,,,,,;;;;"""""""""""oooooO8#####                           ##Ooo"";;,,,,,,,,,,''''
    ..',,,,,,,,,,,,,,;;;;;"%Ooooooo""oooooOOO%8#  #                             ##%Oo"";;;,,,,,,,,,,'''
    ..,,,,,,,,,;;;;;;;;"""oO#8%OOO%8#%OOOOO%%8##                                 ####O";;;,,,,,,,,,,,''
    .',,,,,;;;;;;;;;"""""oo%8###########@888@###                                  ##8o";;;;,,,,,,,,,,''
    .,,,;;;;;;;;;;""""""ooOO8@## ##     #######                                   ##8o";;;;,,,,,,,,,,,'
    .,;;;;;;;;;;"""""""oOO%@####           ###                                    #@Oo";;;;;,,,,,,,,,,'
    .;;;;;;;;;""oooooO%##@####              #                                     #%o"";;;;;,,,,,,,,,,'
    .;"""ooOOOooooOOO%8#### #                                                    #Ooo"";;;;;,,,,,,,,,,'
                                                                              ##@%Ooo"";;;;;,,,,,,,,,,,
    .;"""ooOOOooooOOO%8#### #                                                    #Ooo"";;;;;,,,,,,,,,,'
    .;;;;;;;;;""oooooO%##@####              #                                     #%o"";;;;;,,,,,,,,,,'
    .,;;;;;;;;;;"""""""oOO%@####           ###                                    #@Oo";;;;;,,,,,,,,,,'
    .,,,;;;;;;;;;;""""""ooOO8@## ##     #######                                   ##8o";;;;,,,,,,,,,,,'
    .',,,,,;;;;;;;;;"""""oo%8###########@888@###                                  ##8o";;;;,,,,,,,,,,''
    ..,,,,,,,,,;;;;;;;;"""oO#8%OOO%8#%OOOOO%%8##                                 ####O";;;,,,,,,,,,,,''
    ..',,,,,,,,,,,,,,;;;;;"%Ooooooo""oooooOOO%8#  #                             ##%Oo"";;;,,,,,,,,,,'''
    ...',,,,,,,,,,,,,,,,,,;;;;"""""""""""oooooO8#####                           ##Ooo"";;,,,,,,,,,,''''
    ...'',,,,,,,,,,,,,,,,,,,,,;;;;""""""""""oooO%8##                         #   ##O"";;,,,,,,,,,,'''''
    ....'',,,,,,,,,,,,,,,,,,,,,,;;;;;;;"""""""ooO@######## #              ##88#@##8%";;,,,,,,,,,,''''''
    ....''',,,,,,,,,,,,,,,,,,,,,,,,;;;;;;;;;""""o@88#@%%8@@@###     ###@8@#%OooOO#O";;,,,,,,,,,,'''''''
    .....'''',,,,,,,,,,,,,,,,,,,,,,,,;;;;;;;;;;;"""oooooOOO%@#       ##%OOooo""""";;;,,,,,,,,,'''''''''
    ......''''',,,,,,,,,,,,,,,,,,,,,,,,,;;;;;;;;;;;""""oooO%8# #    ###%oo""""";;;;;,,,,,,,,'''''''''''
    .......'''''',,,,,,,,,,,,,,,,,,,,,,,,,;;;;;;;;;;;;""""oo%@###  ##88o"""";;;;;;;,,,,,,,'''''''''''''
    ........''''''',,,,,,,,,,,,,,,,,,,,,,,,,,;;;;;;;;;;;""""oOO%@###8Ooo"";;;;;;;,,,,,,,'''''''''''''''
    .........'''''''',,,,,,,,,,,,,,,,,,,,,,,,,,,;;;;;;;;;""""oo%@#8@##o";;;;;;;,,,,,,,'''''''''''''''''

Anyway, the source should be placed in a subdirectory of `src`, along
with a `Makefile` with `build`, `time` and `clean` targets. The `build`
target should build the binary (or executable) and `clean` should clear
up any temporary build files (these may be empty rules; for example, for
interpreted languages). The `time` rule should always be of the form:

    time: $(BIN)
    	@../time.sh $(CURDIR)/$(BIN)

...where `$(BIN)` is the binary basename (presumably `mandelbrot`).

Optionally, an entry can be added to the `src/.manifest` file, which
gives an implementation a human-readable name:

    echo "$DIR\t$DESCRIPTION" >> src/.manifest

...where `$DIR` is the subdirectory within `src` **including the
trailing slash** and `$DESCRIPTION` is its name.

### Idiomatic Implementations

It is arguable that benchmarking idiomatic implementations is an unfair
test. For example, a compiled, stateful C implementation is going to be
considerably faster than an interpreted, immutable version -- such as
from Lisp -- on normal hardware. It is up to you, as an analyst, to make
a fair interpretation of the data (e.g., by grouping implementations by
class, or considering other metrics such as code readability).

## Sampling

The benchmark is performed by running `make` against the project root,
with an optional sample size value (defaults to 50):

    make [SAMPLES=x]

This will build the binary for each implementation and then run it
`SAMPLES` time, taking the runtime for each run and aggregating the
results. In the end, you will get the mean and standard error real, user
and system times, in milliseconds. You will also get a total count of
the implementation's lines of code, for what that's worth.

(Note: You will need GNU Make, GNU Awk, [R](https://www.r-project.org)
and [cloc](https://github.com/AlDanial/cloc) for all this to happen!)

## MIT License

Copyright (c) 2016 Christopher Harrison

Permission is hereby granted, free of charge, to any person obtaining a
copy of this software and associated documentation files (the
"Software"), to deal in the Software without restriction, including
without limitation the rights to use, copy, modify, merge, publish,
distribute, sublicense, and/or sell copies of the Software, and to
permit persons to whom the Software is furnished to do so, subject to
the following conditions:

The above copyright notice and this permission notice shall be included
in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS
OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
