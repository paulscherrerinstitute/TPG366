require "stream"
var streamError 1
drvAsynIPPortConfigure "$(PORT)","$(IP):8000"
asynSetOption($(PORT), 0, "disconnectOnReadTimeout", "Y")
dbLoadTemplate "TPG366.subs","CONTROLLER=$(CONTROLLER),PORT=$(PORT)"
#var streamDebug 1
iocInit
#asynSetTraceMask $(PORT) 0 0x1f
#asynSetTraceIOMask $(PORT) 0 2
