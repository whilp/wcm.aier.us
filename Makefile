BUCKET =	m.aier.us
SYNC =		bin/bucketsync -v ${BUCKET}
TEMPLATES =	templates

INPUTS !=	hg locate "set:!(Makefile|README|bin/**|.*|${TEMPLATES}/**)"
CSS =		${INPUTS:M*.css}
MINCSS =	css/site.min.css
BUILT =		${INPUTS:M*.txt:%.txt=%} cv.pdf ${MINCSS}
OUTPUTS =	${INPUTS} ${BUILT}

PANDOC =	pandoc \
			--email-obfuscation=none \
			--standalone \
			--smart \
			-f markdown \
			--html5 -t html --section-divs \
			-c /css/site.css

.SUFFIXES: .txt .pdf

default: build

clean:
	rm -f ${BUILT}

build: ${BUILT}

deploy: build
	echo ${OUTPUTS} | xargs -P4 ${SYNC}

index: index.txt
	${PANDOC} --template=${TEMPLATES}/bare.xhtml -o $@ $<

${MINCSS}: ${CSS}
	cat $? | cssmin > ${MINCSS}

.txt:
	${PANDOC} --template=${TEMPLATES}/base.xhtml -o $@ $<

.txt.pdf:
	markdown2pdf $<
