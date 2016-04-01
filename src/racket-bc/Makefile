BIN=mandelbrot

build: $(BIN) ;

time: $(BIN)
	@../time.sh $(CURDIR)/$(BIN)

$(BIN): mandelbrot.rkt
	raco exe -o $@ $^

clean:
	rm -f $(BIN)

.PHONY: build time clean
