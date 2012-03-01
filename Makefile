TEMPLATES =	templates
BUCKET =	m.aier.us
SYNC =		bin/bucketsync -v ${BUCKET}

CSS =		css/site.css
MINCSS =	${CSS:%.css=%.min.css}
PUBLISHED =	colophon.txt copyright.txt cv.txt index.txt wrender.txt toys/chess.txt
DRAFT =		new-tools.txt
PDF =		cv.pdf
BUILT =		${PUBLISHED:%.txt=%} ${PDF} ${MINCSS}
COMPRESSED =	${BUILT:%=%.gz}
STATIC =	wcmaier-key.gpg wcmaier-key.txt
OUTPUTS =	${PUBLISHED} ${BUILT} ${STATIC}

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
