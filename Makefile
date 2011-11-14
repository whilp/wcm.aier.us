BUCKET =	m.aier.us
SYNC =		bin/bucketsync -v ${BUCKET}
TEMPLATES =	templates

INPUTS !=	hg locate "set:!(Makefile|bin/**|.*|${TEMPLATES}/**)"
BUILT =		${INPUTS:M*.txt:%.txt=%} cv.pdf
OUTPUTS =	${INPUTS} ${BUILT}

PANDOC =	pandoc \
			--email-obfuscation=none \
			--template=${TEMPLATES}/template.xhtml \
			--standalone \
			--smart \
			-f markdown \
			--html5 -t html --section-divs \
			-c /css/site.css \
			-o

.SUFFIXES: .txt .pdf

default: build

clean:
	rm -f ${BUILT}

build: ${BUILT}

deploy: build
	echo ${OUTPUTS} | xargs -P4 ${SYNC}

index: index.txt
	${PANDOC} -Vbase=true -o $@ $<

.txt:
	${PANDOC} -o $@ $<

.txt.pdf:
	markdown2pdf $<
