TEMPLATES =	templates
BUCKET =	m.aier.us
SYNC =		bin/bucketsync -v ${BUCKET}

CSS =		css/GGS.css css/font.css css/site.css
PUBLISHED =	colophon.txt copyright.txt cv.txt index.txt toys/chess.txt
DRAFT =		new-tools.txt
MINCSS =	css/site.min.css
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
	 ./bin/wrender $<

.txt.pdf:
	markdown2pdf $<
