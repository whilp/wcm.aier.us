BIN =		bin
TEMPLATES =	templates

INPUTS !=	hg locate "set:!(Makefile|bin|fonts/**|${TEMPLATES}/**)"
BUILT =		${INPUTS:M*.txt:%.txt=%.xhtml}

OUTPUTS =	${INPUTS} ${BUILT}

PANDOC =	pandoc \
			--template=${TEMPLATES}/template.xhtml \
			--standalone \
			--smart \
			-f markdown \
			--html5 -t html --section-divs \
			-o $@ $<

.SUFFIXES: .txt .xhtml

default: build

clean:
	rm -f ${BUILT}

build: ${BUILT}

deploy: build
	echo ${OUTPUTS} | xargs -P4 ${BIN}/bucketsync

.txt.xhtml: Makefile ${TEMPLATES}/template.xhtml
	${PANDOC}
