#!/usr/bin/env python3

import sys

class MandelbrotPoint(object):
    def __init__(self, c):
        self.c   = c
        self.n   = 0
        self.z_n = 0

    def __str__(self):
        if self.n == 100:
            return " "

        if self.n > 10:
            return "#"

        else:
            return ".',;\"oO%8@"[self.n - 1]

    def iterate(self):
        if abs(self.z_n) <= 2:
            self.n += 1
            self.z_n = (self.z_n ** 2) + self.c

class Mandelbrot(object):
    def __init__(self, top_left, bottom_right, width, height):
        """
        top-left      Top-left corner of complex subplane
        bottom-right  Bottom-right corner of complex subplane
        width         Output image width
        height        Output image height
        """
        self.top_left = top_left
        self.width = width

        diagonal = bottom_right - top_left
        self.scale_real = diagonal.real / (width - 1)
        self.scale_imag = diagonal.imag / (height - 1)

        self.z = [MandelbrotPoint(self._quantise(i)) for i in range(width * height)]

    def __str__(self):
        output = [str(z) for z in self.z]
        output = ["".join(output[i:i + self.width]) for i in range(0, len(output), self.width)]
        return "\n".join(output)

    def _quantise(self, i):
        imaginary, real = divmod(i, self.width)
        return complex(real * self.scale_real, imaginary * self.scale_imag) + self.top_left

    def iterate(self, iterations):
        for i in range(iterations):
            for z in self.z:
                z.iterate()

if __name__ == "__main__":
    try:
        # Attempt to parse values from command line
        [_, top_left, bottom_right, width, height] = sys.argv

        try:
            top_left     = complex(top_left)
            bottom_right = complex(bottom_right)
            width        = int(width)
            height       = int(height)

            if top_left.real > bottom_right.real \
            or top_left.imag < bottom_right.imag \
            or width  <= 0 \
            or height <= 0:
                raise Exception

        except:
            # WTF?
            print("Usage: mandelbrot.py [TOPLEFT BOTTOMRIGHT WIDTH HEIGHT]")
            print("  TOPLEFT      Top-left corner of complex subplane")
            print("  BOTTOMRIGHT  Bottom-right corner of complex subplane")
            print("  WIDTH        Output width (characters)")
            print("  HEIGHT       Output height (characters)")
            sys.exit(1)

    except ValueError:
        # Default values
        # NOTE Python has first-class complex numbers, but uses "j" :P
        top_left, bottom_right, width, height = (-2+1j, 1-1j, 99, 33)

    mandelbrot = Mandelbrot(top_left, bottom_right, width, height)
    mandelbrot.iterate(100)
    print(mandelbrot)
