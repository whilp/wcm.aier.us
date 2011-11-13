BUCKET =	m.aier.us
SYNC =		bin/bucketsync -vv ${BUCKET}
TEMPLATES =	templates

INPUTS !=	hg locate "set:!(Makefile|bin/**|.*|${TEMPLATES}/**)"
BUILT =		${INPUTS:M*.txt:%.txt=%.xhtml}
OUTPUTS =	${INPUTS} ${BUILT}

PANDOC =	pandoc \
			--email-obfuscation=none \
			--template=${TEMPLATES}/template.xhtml \
			--standalone \
			--smart \
			-f markdown \
			--html5 -t html --section-divs \
			-c /css/site.css \
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
