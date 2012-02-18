TEMPLATES =	templates
BUCKET =	m.aier.us
SYNC =		bin/bucketsync -v ${BUCKET}

CSS =		css/site.css
MINCSS =	${CSS:%.css=%.min.css}
PUBLISHED =	colophon.txt copyright.txt cv.txt index.txt toys/chess.txt
DRAFT =		new-tools.txt
PDF =		cv.pdf
BUILT =		${PUBLISHED:%.txt=%} ${PDF} ${MINCSS}
STATIC =	wcmaier-key.gpg wcmaier-key.txt
OUTPUTS =	${PUBLISHED} ${BUILT} ${STATIC}

.SUFFIXES: .txt .pdf

default: build

clean:
	rm -f ${BUILT}

build: ${BUILT}

deploy: build
	echo ${OUTPUTS} | xargs -P4 ${SYNC}

clean-remote: build
	${SYNC} -d ${OUTPUTS}

serve:
	./bin/serve -v

${MINCSS}: ${CSS}
	cat ${CSS} | cssmin > ${MINCSS}

.txt:
	 wrender $<

.txt.pdf:
	markdown2pdf $<
