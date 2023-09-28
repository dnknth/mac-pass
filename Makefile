.PHONY: all clean install

all: Pass.app

Pass.app: Pass.platypus
	platypus -P $< $@

install: Pass.app $(HOME)/Applications
	rm -r $(HOME)/Applications/$<
	mv $< $(HOME)/Applications

$(HOME)/Applications:
	mkdir $@
	touch $@/.localized

clean:
	rm -r Pass.app
