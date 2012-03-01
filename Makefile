TEMPLATES =	templates
BUCKET =	m.aier.us
SYNC =		bin/bucketsync -v ${BUCKET}

CSS =		css/site.css
MINCSS =	${CSS:%.css=%.min.css}
PUBLISHED =	colophon.txt copyright.txt cv.txt index.txt wrender.txt toys/chess.txt
DRAFT =		new-tools.txt
PDF =		cv.pdf
PDF =
BUILT =		${HTML} ${PDF} ${MINCSS}
HTML =		${PUBLISHED:%.txt=%}
JS =		js/modernizr.custom.04939.js
TEXT =		wcmaier-key.gpg wcmaier-key.txt
COMPRESSABLE =	${HTML} ${MINCSS} ${TEXT} ${JS}
COMPRESSED =	${COMPRESSABLE:%=%.gz}
OUTPUTS =	${PUBLISHED} ${BUILT} ${TEXT} ${JS}

.SUFFIXES: .txt .pdf .gz

default: build

clean:
	rm -f ${BUILT} ${COMPRESSED}

build: ${BUILT}
compress: ${COMPRESSED}

deploy: build compress
	echo ${OUTPUTS} | xargs -P4 ${SYNC}

clean-remote: build
	${SYNC} -d ${OUTPUTS}

serve:
	./bin/serve -v

${MINCSS}: ${CSS}
	cat ${CSS} | cssmin > ${MINCSS}

.txt:
	wrenderit $<

%.gz: ${BUILT}
	gzip -c ${@:%.gz=%} > $@

.txt.pdf:
	markdown2pdf $<
