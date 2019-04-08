require "stream"
require "SynApps"
drvAsynIPPortConfigure "$(PORT=TCP366)","$(IP):8000"
#asynSetOption($(PORT=TCP366), 0, "disconnectOnReadTimeout", "Y")
dbLoadTemplate "TPG366.subs","CONTROLLER=$(CONTROLLER=MG1),PORT=$(PORT=TCP366),PREC_=-4"
