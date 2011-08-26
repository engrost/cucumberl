SHELL=/bin/sh

EFLAGS=-pa ebin

.PHONY: ebins

all: ebins

ebins:
	test -d ebin || mkdir ebin
	erl $(EFLAGS) -make

clean:
	rm -f tmp/*.cov.html erl_crash.dumpg
	rm -f ebin/*.beam

test: clean ebins
	erl -pa ebin -noshell -sname tester -s testing_suite test_auto -s init stop
