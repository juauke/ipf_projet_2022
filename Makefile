APP1 = bin/phase1
APP2 = bin/phase2
APP3 = bin/phase3

CAMLC = ocamlc
.PRECIOUS: %.cmi %.cmo

# SRC = analysis.mli table.mli
SRC = $(wildcard *.mli)
INT = $(SRC:.mli=.cmi)
OBJ = $(SRC:.mli=.cmo)

all: p1 p2 p3

p1: $(APP1)
p2: $(APP2)
p3: $(APP3)

%.cmi: %.mli
	mkdir -p objs
	$(CAMLC) -c $<

%.cmo: %.ml $(INT)
	$(CAMLC) -c $<

bin/%: $(OBJ) %.cmo
	mkdir -p bin
	$(CAMLC) -o $@ $^

.PHONY: clean

clean:
	rm -rf $(APP1) $(APP2) $(APP3) *.cm[io] 2>/dev/null