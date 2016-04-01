BIN=mandelbrot

build: $(BIN) ;

time: $(BIN)
	@../time.sh $(CURDIR)/$(BIN)

$(BIN): mandelbrot.c
	gcc -std=gnu11 -Wpedantic -Wall -Wextra -Werror -Wgnu -Ofast $^ -o $@

clean:
	rm -f $(BIN)

.PHONY: build time clean
