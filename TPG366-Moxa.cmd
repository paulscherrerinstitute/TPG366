var streamError 1
! setinterface $(TTY=/dev/ttyM$(SER=0)) 1
drvAsynSerialPortConfigure $(PORT=$(CONTROLLER=MG$(SER=0))) $(TTY=/dev/ttyM$(SER=0))
dbLoadTemplate TPG366.subs "CONTROLLER=$(CONTROLLER=MG$(SER=0)),PORT=$(PORT=$(CONTROLLER=MG$(SER=0)))"
