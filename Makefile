BUCKET =	m.aier.us
SYNC =		bin/bucketsync -v ${BUCKET}
TEMPLATES =	templates

INPUTS !=	hg locate "set:!(Makefile|bin/**|.*|${TEMPLATES}/**)"
BUILT =		${INPUTS:M*.txt:%.txt=%.xhtml} cv.pdf
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

.SUFFIXES: .txt .xhtml .pdf

default: build

clean:
	rm -f ${BUILT}

build: ${BUILT}

deploy: build
	echo ${OUTPUTS} | xargs -P4 ${SYNC}

.txt.xhtml: Makefile ${TEMPLATES}/template.xhtml
	${PANDOC}

.txt.pdf:
	markdown2pdf $<
