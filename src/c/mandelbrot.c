#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <complex.h>
#include <errno.h>

typedef struct mandelbrot {
  double complex c;
  int            n;
  double complex z_n;
} mandelbrot;

double complex read_complex(char* str) {
  double real, imag;
  if (!sscanf(str, "%lf%lfi", &real, &imag)) {
    errno = EINVAL;
  }

  return real + imag*I;
}

mandelbrot* initialise(double complex top_left, double complex bottom_right, size_t width, size_t height) {
  mandelbrot* field = malloc(width * height);
  if (!field) {
    return NULL;
  }

  double complex diagonal = bottom_right - top_left;
  double scale_real = creal(diagonal) / (width - 1);
  double scale_imag = cimag(diagonal) / (height - 1);

  for (size_t i = 0; i < width * height; i++) {
    mandelbrot* pt = field + i;
    div_t q = div(i, width);

    pt->c = ((q.rem * scale_real) + (q.quot * scale_imag)*I) + top_left;
    pt->n = 0;
    pt->z_n = 0;
  }

  return field;
}

void iterate(mandelbrot* field, size_t size, size_t iterations) {
  for (size_t n = 0; n < iterations; n++) {
    for (size_t i = 0; i < size; i++) {
      if (cabs((field + i)->z_n) <= 2) {
        mandelbrot* pt = field + i;
        pt->n += 1;
        pt->z_n = (pt->z_n * pt->z_n) + (pt->c);
      }
    }
  }
}

void print(mandelbrot* field, size_t width, size_t height) {
  for (size_t i = 0; i < width * height; i++) {
    mandelbrot* pt = field + i;

    if      (pt->n == 100) { fprintf(stdout, " "); }
    else if (pt->n  >  10) { fprintf(stdout, "#"); }
    else                   { fprintf(stdout, "%c", ".',;\"oO%8@"[pt->n - 1]); }

    if (!((i + 1) % width)) { fprintf(stdout, "\n"); }
  }
}

int main(int argc, char** argv) {
  /* Default values */
  double complex top_left = -2.0 + 1.0*I;
  double complex bottom_right = 1.0 - 1.0*I;
  size_t width  = 99;
  size_t height = 33;

  if (argc == 5) {
    /* Attempt to parse values from command line */
    top_left = read_complex(*(argv + 1));
    bottom_right = read_complex(*(argv + 2));
    width = (size_t)strtol(*(argv + 3), NULL, 10);
    height = (size_t)strtol(*(argv + 4), NULL, 10);

    if (creal(top_left) > creal(bottom_right)
     || cimag(top_left) < cimag(bottom_right)
     || width  <= 0
     || height <= 0) {
      errno = EINVAL;
    }

    if (errno) {
      /* WTF? */
      fprintf(stderr,
        "Usage: mandelbrot [TOPLEFT BOTTOMRIGHT WIDTH HEIGHT]\n"
        "  TOPLEFT      Top-left corner of complex subplane\n"
        "  BOTTOMRIGHT  Bottom-right corner of complex subplane\n"
        "  WIDTH        Output width (characters)\n"
        "  HEIGHT       Output height (characters)\n"
      );
      return 1;
    }
  }

  mandelbrot* field = initialise(top_left, bottom_right, width, height);
  if (!field) {
    fprintf(stderr, "Memory allocation failed!");
    return 1;
  }

  iterate(field, width * height, 100);
  print(field, width, height);

  free(field);
  return 0;
}
