SYNC =		bin/bucketsync -vv m.aier.us

INPUTS !=	hg locate "set:!(Makefile|bin/**|.*|${TEMPLATES}/**)"
BUILT =		${INPUTS:M*.txt:%.txt=%.xhtml}
OUTPUTS =	${INPUTS} ${BUILT}

TEMPLATES =	templates
PANDOC =	pandoc \
			--email-obfuscation=none \
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
	echo ${OUTPUTS} | xargs -P4 ${SYNC}

.txt.xhtml: Makefile ${TEMPLATES}/template.xhtml
	${PANDOC}
