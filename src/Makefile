APP1 = ../bin/phase1
APP2 = ../bin/phase2
APP3 = ../bin/phase3

CAMLC = ocamlc
.PRECIOUS: %.cmi %.cmo

# SRC = analysis.mli table.mli
SRC = $(wildcard *.mli)
INT = $(SRC:.mli=.cmi)
OBJ = $(SRC:.mli=.cmo)

all: p1 p2 p3

p1: dirs $(APP1)
p2: dirs $(APP2)
p3: dirs $(APP3)

dirs:
	@mkdir -p ../bin

%.cmi: %.mli
	$(CAMLC) -o $@ -c $<

%.cmo: %.ml $(INT)
	$(CAMLC) -o $@ -c $<

../bin/%: $(OBJ) %.cmo
	$(CAMLC) -o $@ $^

.PHONY: clean

clean:
	rm -f *.cm[io] 2>/dev/null
	rm -r ../bin 2>/dev/null