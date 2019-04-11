require "stream"
require "SynApps"
var streamError 1
drvAsynIPPortConfigure "$(PORT=$(CONTROLLER))","$(IP):8000"
#asynSetOption($(PORT=$(CONTROLLER)), 0, "disconnectOnReadTimeout", "Y")
dbLoadTemplate "TPG366.subs","CONTROLLER=$(CONTROLLER),PORT=$(PORT=$(CONTROLLER))"
