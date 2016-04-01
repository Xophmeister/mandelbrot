SAMPLES ?= 50

all:
	@$(MAKE) -C src SAMPLES=$(SAMPLES)

clean:
	@$(MAKE) -C src CLEAN=1

.PHONY: all clean
