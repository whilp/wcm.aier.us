BUCKET =	m.aier.us
SYNC =		bin/bucketsync -v ${BUCKET}
TEMPLATES =	templates

CSS =		css/GGS.css css/font.css css/site.css
PUBLISHED =	colophon.txt copyright.txt cv.txt index.txt toys/chess.txt
DRAFT =		new-tools.txt
MINCSS =	css/site.min.css
PDF =		cv.pdf
BUILT =		${PUBLISHED:%.txt=%} ${PDF} ${MINCSS}
STATIC =	wcmaier-key.gpg wcmaier-key.txt
OUTPUTS =	${PUBLISHED} ${BUILT} ${STATIC}

PANDOC =	pandoc \
			--email-obfuscation=none \
			--standalone \
			--smart \
			-f markdown \
			--html5 -t html --section-divs \
			-c /css/site.min.css

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

index: index.txt
	${PANDOC} --template=${TEMPLATES}/bare.xhtml -o $@ $<

toys/chess: toys/chess.txt
	${PANDOC} --template=${TEMPLATES}/bare.xhtml -c asdf -o $@ $<

${MINCSS}: ${CSS}
	cat ${CSS} | cssmin > ${MINCSS}

.txt:
	${PANDOC} --template=${TEMPLATES}/base.xhtml -o $@ $<

.txt.pdf:
	markdown2pdf $<
