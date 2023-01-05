all:
	$(MAKE) -C src/

p1: 
	$(MAKE) -C src/ p1
p2: 
	$(MAKE) -C src/ p2
p3: 
	$(MAKE) -C src/ p3

.PHONY: clean

clean:
	$(MAKE) -C src/ clean