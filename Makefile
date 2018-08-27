PREFIX ?=/usr/local/bin

.PHONY: all install

all:

install: ssget
	cp ssget $(PREFIX)/ssget
