PDC ?= ~/playdate/PlaydateSDK-Current/bin/pdc
PDUTIL ?= ~/playdate/PlaydateSDK-Current/bin/pdutil
PLAYDATE_SIMULATOR ?= ~/playdate/PlaydateSDK-Current/bin/PlaydateSimulator
PLAYDATE_SDK_PATH ?= ~/playdate/PlaydateSDK-Current/
PDX_NAME ?= 'Big Head'
PDX_DIRNAME ?= 'Big Head.pdx'

@PHONEY: build
build:
	$(PDC) -sdkpath $(PLAYDATE_SDK_PATH) src/ $(PDX_NAME)

@PHONEY: simulate
simulate: build
	$(PLAYDATE_SIMULATOR) $(PDX_DIRNAME)

@PHONEY: install
install: build
	./pdman mount
	while [ ! -e /media/dorthu/PLAYDATE ]; do sleep 1; done
	cp -r $(PDX_DIRNAME) /media/dorthu/PLAYDATE/Games/
	./pdman umount
