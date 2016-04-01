#!/usr/bin/env racket

(module mandelbrot racket/base 
  (require (only-in racket/function curryr)
           (only-in racket/list     range)
           (only-in racket/math     sqr)
           (only-in racket/vector   vector-map))

  ;; z_n+1 = z_n^2 + c
  ;; c :: Complex
  (struct mandelbrot-point (c n z_n))

  ;; initialise :: Complex -> Complex -> Integer -> Integer -> ([mandelbrot-point], printer :: [mandelbrot-point])
  ;  top-left      Top-left corner of complex subplane
  ;  bottom-right  Bottom-right corner of complex subplane
  ;  width         Output image width
  ;  height        Output image height
  (define (initialise top-left bottom-right width height)
    (define (quantise i)
      (define-values (imaginary real) (quotient/remainder i width))

      (define diagonal   (- bottom-right top-left))
      (define scale-real (/ (real-part diagonal) (sub1 width)))
      (define scale-imag (/ (imag-part diagonal) (sub1 height)))

      ; Unsurprisingly, floating point is significantly faster than
      ; using complex numbers with exact rational parts
      (exact->inexact
        (+ (make-rectangular (* real scale-real) (* imaginary scale-imag)) top-left)))

    (values
      ; Initial state
      (map (compose (curryr mandelbrot-point 0 0) quantise) (range (* width height)))

      ; State printer
      (let
        ([colourise (λ (point)
                      (string
                        (let ([n (mandelbrot-point-n point)])
                          (cond [(equal? n 100) #\space]
                                [(> n 10)       #\#]
                                [else           (string-ref ".',;\"oO%8@" (sub1 n))]))))]

         [wrap (λ (text)
                 ; FIXME This is probably an inefficient approach
                 (regexp-replace* (pregexp (format ".{~a}" width)) text "&\n"))])

        (λ (state)
          (display (wrap
            (foldl (λ (point output) (string-append output (colourise point)))
                   ""
                   state)))))))

    ;; mandelbrot :: [mandelbrot-point] -> Integer -> [mandelbrot-point]
    (define (mandelbrot state iterations)
      (define (iterate point)
        ; TODO It's inefficient to calculate the magnitude of each point
        ; in every iteration; add a check for completed points
        (if (> (magnitude (mandelbrot-point-z_n point)) 2)
          ; #t: We're done
          point

          ; #f: Iterate point
          (mandelbrot-point (mandelbrot-point-c point)
                            (add1 (mandelbrot-point-n point))
                            (+ (sqr (mandelbrot-point-z_n point)) (mandelbrot-point-c point)))))

      (if (zero? iterations)
        ; #t: We're done
        state

        ; #f: Iterate
        (mandelbrot (map iterate state) (sub1 iterations))))

    (let ([args (vector-map string->number (current-command-line-arguments))])
      (define-values (top-left bottom-right width height)
        (if (equal? (vector-length args) 4)
          ; #t: Attempt to parse values from command line
          (let ([top-left     (vector-ref args 0)]
                [bottom-right (vector-ref args 1)]
                [width        (vector-ref args 2)]
                [height       (vector-ref args 3)])

            (if (and (complex? top-left)
                     (complex? bottom-right)
                     (> (real-part bottom-right) (real-part top-left))
                     (> (imag-part top-left) (imag-part bottom-right))
                     (exact-positive-integer? width)
                     (exact-positive-integer? height))

              ; #t: Parse successful
              (values top-left bottom-right width height)

              ; #f: WTF?
              (begin (displayln "Usage: mandelbrot.rkt [TOPLEFT BOTTOMRIGHT WIDTH HEIGHT]")
                     (displayln "  TOPLEFT      Top-left corner of complex subplane")
                     (displayln "  BOTTOMRIGHT  Bottom-right corner of complex subplane")
                     (displayln "  WIDTH        Output width (characters)")
                     (displayln "  HEIGHT       Output height (characters)")
                     (exit 1))))

          ; #f: Default values
          (values -2+1i 1-1i 99 33)))

      (define-values (z_0 mandelbrot-print) (initialise top-left bottom-right width height))
      (mandelbrot-print (mandelbrot z_0 100))))
