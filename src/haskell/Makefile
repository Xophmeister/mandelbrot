BIN=mandelbrot

build: $(BIN) ;

time: $(BIN)
	@../time.sh $(CURDIR)/$(BIN)

$(BIN): mandelbrot.hs
	ghc --make $^ -O2 -o $@

clean:
	rm -f $(BIN) *.hi *.o

.PHONY: build time clean
