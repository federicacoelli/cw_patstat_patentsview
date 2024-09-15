# Config
R = Rscript
STATA = stata-mp -e
DIR_PV := $(shell cat ../../../path.txt | sed -n '2p')

# Input
PVinput = \
	../input/patent.tsv

# Output
output_patent = ../output/patent.csv
PVoutput = $(output_patent)

# Rules
.PHONY: all clean
all: $(PVoutput)

# Folders recipes
../input ../output:
	mkdir $@

# Input recipes
$(PVinput): | ../input/
	if [ -L ../input/$(@F) ] ; then exit 1 ; else ln -s $(DIR_PV)/$(@F) $@ ; fi

# Output recipes
$(output_patent): clean_patent.do ../input/patent.tsv | ../output
	$(STATA) $< $@
	mv *.log ../output/

clean:
	rm -f ../input/*.csv ../input/*.tsv
	rm -f $(PVoutput)
	rm -f ../output/*.log