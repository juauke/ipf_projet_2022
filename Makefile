APP1 = phase1
APP2 = phase2
APP3 = phase3

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
	mkdir -p objs 1>/dev/null
	$(CAMLC) -c $<

%.cmo: %.ml $(INT)
	mkdir -p objs 1>/dev/null
	$(CAMLC) -c $<

%: $(OBJ) %.cmo
	mkdir -p bin 1>/dev/null
	$(CAMLC) -o $@ $^

.PHONY: clean

clean:
	rm -rf $(APP1) $(APP2) $(APP3) *.cm[io] 2>/dev/null