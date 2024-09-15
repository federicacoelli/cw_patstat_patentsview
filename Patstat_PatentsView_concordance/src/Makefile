# Config
STATA = stata-mp -e
DIR_PATSTAT := $(shell cat ../../path.txt | sed -n '1p')

# Input
input_1 = ../input/patent.csv
input_2 = \
	../input/publn_info.dta \
	../input/family_info.dta \
	../input/appln_info.dta

# Output
output_1 = ../output/patstat_patentsview_conc.csv
output_2 = ../output/patstat_patentsview_conc_codebook.csv
output_3 = ../output/docdb_uspto_patent_id.csv
output_4 = ../output/docdb_uspto_patent_id_codebook.csv

# Rules
.PHONY: all clean
all: $(output_1) $(output_2) $(output_3) $(output_4)

# Folders recipes
../input ../output:
	mkdir $@

# Input recipes
$(input_1): | ../input/
	if [ -L ../input/$(@F) ] ; then exit 1 ; else ln -s ../../initial_data/PatentsView/output/$(@F) $@ ; fi
$(input_2): | ../input/
	if [ -L ../input/$(@F) ] ; then exit 1 ; else ln -s $(DIR_PATSTAT)/$(@F) $@ ; fi

# Output recipies
$(output_1): merge_patstat_patentsview.do $(input_1) $(input_2) | ../output
	$(STATA) $< $@
	mv *.log ../output/

$(output_2) $(output_3) $(output_4): $(output_1)

clean:
	rm -f ../input/*.csv ../input/*.dta
	rm -f $(output_1) $(output_2) $(output_3) $(output_4)
	rm -f ../output/*.csv
	rm -f ../output/*.log