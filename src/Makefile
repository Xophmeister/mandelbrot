DIRS=$(dir $(wildcard */))

all: $(DIRS) ;

$(DIRS):
ifndef CLEAN
	@echo "$$((grep "^$@\t" .manifest || echo "$@") | cut -f2)" ; \
	$(MAKE) -C $@ build >/dev/null ; \
	echo "  Code  $$(cloc $@ --exclude-lang=make --sum-one | awk '/^SUM:/ { print $$NF }') sloc" ; \
	for i in $$(seq $(SAMPLES)); do \
		$(MAKE) -C $@ time | ./process.awk ; \
	done | ./aggregate.r ; \
	echo
else
	@$(MAKE) -C $@ clean >/dev/null
endif

.PHONY: all $(DIRS)
