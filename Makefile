# Master Makefile

#------------------------------------------------------------------------------
# Tasks
#------------------------------------------------------------------------------
# Import, read and prepare PatenstView
TASK_1.1=initial_data/PatentsView/src

# Crosswalk: Patstat-PatentsView patent identifiers
TASK_1.2=Patstat_PatentsView_concordance/src

#------------------------------------------------------------------------------
# Work section
#------------------------------------------------------------------------------
all:
	$(MAKE) -C $(TASK_1.1)
	$(MAKE) -C $(TASK_1.2)