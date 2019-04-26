var streamError 1
drvAsynIPPortConfigure $(PORT=$(CONTROLLER=MG)) $(IP):8000
#asynSetOption $(PORT=$(CONTROLLER=MG)) 0 disconnectOnReadTimeout Y
dbLoadTemplate TPG366.subs "CONTROLLER=$(CONTROLLER=MG),PORT=$(PORT=$(CONTROLLER=MG))"
