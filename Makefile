PDC ?= ~/playdate/PlaydateSDK-0.10.2/bin/pdc
PDUTIL ?= ~/playdate/PlaydateSDK-0.10.2/bin/pdutil
PLAYDATE_SIMULATOR ?= ~/playdate/PlaydateSDK-0.10.2/bin/PlaydateSimulator
PLAYDATE_SDK_PATH ?= ~/playdate/PlaydateSDK-0.10.2/
PDX_NAME ?= 'Big Head'

@PHONEY: build
build:
	$(PDC) -sdkpath $(PLAYDATE_SDK_PATH) src/ $(PDX_NAME)

@PHONEY: simulate
simulate: build
	$(PLAYDATE_SIMULATOR) $(PDX_NAME).pdx

#@PHONEY: install
#install: build
#	$(PDUTIL) /dev/ttyACM0 datadisk
#	cp -r $(PDX_NAME).pdx /media/dorthu/PLAYDATE/Games/$(PDX_NAME).pdx
#	# TODO - unmount the device (umount /media/dorthu/PLAYDATE isn't enough)
