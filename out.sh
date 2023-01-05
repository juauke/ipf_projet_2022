find . -path './test/phase1/*.txt' -exec sh -c './bin/phase1 {} > ./test/out/phase1/$(basename -a {})' \; && \
find . -path './test/phase1/*.txt' -exec sh -c './bin/phase1 {} 2> ./test/out/phase1/err_$(basename -a {})' \; && \
find . -path './test/out/*' -size 0 -exec rm {} \;

find . -path './test/phase2/*.txt' -exec sh -c './bin/phase2 {} > ./test/out/phase2/$(basename -a {})' \; && \
find . -path './test/phase2/*.txt' -exec sh -c './bin/phase2 {} 2> ./test/out/phase2/err_$(basename -a {})' \; && \
find . -path './test/out/*' -size 0 -exec rm {} \;

find . -path './test/phase3/*.txt' -exec sh -c './bin/phase3 {} > ./test/out/phase3/$(basename -a {})' \; && \
find . -path './test/phase3/*.txt' -exec sh -c './bin/phase3 {} 2> ./test/out/phase3/err_$(basename -a {})' \; && \
find . -path './test/out/*' -size 0 -exec rm {} \;
