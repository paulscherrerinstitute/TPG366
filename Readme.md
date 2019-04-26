# TPG366

This is a support module for the Pfeiffer Vaccum MaxiGauge TPG366.

It consists of two EPICS template files: TPG366-Sensor.template, which
should be instantiated once for each of the six vacuum sensors of the
TPG366, and TPG366-Setpoint.template, which sould be instantiated once
for each of the six relays of the TPG366.

## Usage

### Load the module "TPG366"

Use the `require` command to load the module. It provides the templates and
a generic substitution file as well as the StreamDevice protocols.

Startup script:

    require TPG366

### Create an asyn IP port

The TPG366 must be connected to Ethernet and have a static IP
address. The TPG366 could boot with DHCP, but it does not provide a host
name. Thus the IP address must be known to EPICS and thus be fixed. 

Use the `drvAsynIPPortConfigure` command once for each Maxigauge to connect
to. If the TPG366 has a host name in the name server, that name can be used
instead of the IP address. The TPG366 runs the server on TCP port 8000.

The asyn port name is arbitrary but when connecting to multiple TPG366
devices from one IOC, each must have its own port name.

Example startup script line for one TPG366, using port name MG1 and
IP address 172.10.20.30:

    drvAsynIPPortConfigure MG1 172.10.20.30:8000

### Create an asyn serial port on a Moxa DA-66x

The TPG366 must be connected to a serial port on a Moxa. Only one TPG366
can be connected to each port. The port must run on 9600 baud (the default)
and must be configured for "RS485-2WIRES" using the `setinterface` program.

Use the `drvAsynSerialPortConfigure` command once for each Maxigauge to connect
to. The serial ports are named `/dev/ttyM0` ... `/dev/ttyM15`.

The asyn port name is arbitrary but when connecting to multiple TPG366
devices from one IOC, each must have its own port name.

Example startup script line for one TPG366, using port name MG2 connected
to port `/dev/ttyM0` on a Moxa DA-66x:

    ! setinterface /dev/ttyM0 1
    drvAsynSerialPortConfigure MG2 /dev/ttyM0

### Alternative A: Create a substitution file

For each of the six sensors of the TPG366, instantiate
TPG366-Sensor.template once.

The following macros can be used. Some are mandatory, some have default
values:

    * PORT        - Asyn port name created previosly (mandatory)
    * CONTROLLER  - Name of the TPG366 (mandatory)
    * CH          - Sensor channel number 1...6 (mandatory)
    * SENSOR      - Name of the sensor, (mandatory)
    * PREC        - Precision, defaults to -3 (3 digits exponential)
    * MIN         - Exponent of lower limit, defaults to -11 (i.e. 1e-11)
    * MAX         - Exponent of upper limit, defaults to 3 (i.e. 1e3)
    * WARN        - MINOR alarm limit defaults to Inf (no warning)
    * ALARM       - MAJOR alarm limit defaults to Inf (no alarm)

Also for each of the six setpoints (relays), instantiate the
TPG366-Setpoint.template once. The relays have numbers 1...6
but for backward compatibility also the letters A...F are provided.
Channel Access Security can be used to limit access to settings.

The following macros can be used. Some are mandatory, some have default
values:

    * PORT        - Asyn port name as before (mandatory)
    * CONTROLLER  - Name of the TPG366 as before (mandatory)
    * NR          - Number of the relay 1...6 (mandatory)
    * NRC         - Matching character A...F (mandatory)
    * PREC        - Precision, defaults to -3 (3 digits exponential)
    * ASG         - Access Security Group, defaults to empty

The template files do not need to be installed in the IOC because they are
available from the module.

As `PORT` and `CONTROLLER` are the same for all six sensors and setpoints,
a global setting is recommended.

    global { "PORT=MG1,CONTROLLER=SIN-VMMG-100,ASG=VACOP" }
    file TPG366-Sensor.template
    { pattern
      {CH  SENSOR              MIN   MAX   WARN    ALARM }
      { 1  SINSB05-VMCP-A010    -4    -3   Inf     Inf   }
      { 2  SINSB05-VMCC-A010   -11     3   2E-07   5E-07 }
      { 3  SINSB05-VMCC-A020   -11     3   2E-07   5E-07 }
      { 4  SINSB05-VMCC-A030   -11     3   2E-07   5E-07 }
      { 5  SINSB05-VMCC-A040   -11     3   2E-07   5E-07 }
      { 6  SINSB05-VMCP-A025    -4    -3   Inf     Inf   }
    }
    file TPG366-Setpoint.template
    { pattern
      {NR  NRC }
      { 1   A  }
      { 2   B  }
      { 3   C  }
      { 4   D  }
      { 5   E  }
      { 6   F  }
    }

Repeat this pattern for multiple TPG366 devices. Redefine the global
settings before instantiating "TPG366-Sensor.template" and
"TPG366-Setpoint.template" six time each for each TPG366.

### Alternative B: Use predefined substitution file

The predefined substitution file "TPG366.subs" can be called from the
startup script. However all macro parameters need to be given on the same
line and the length of the line is limited.

The substitution file instantiates the six sensors and six setpoints of
one TPG366. Thus for each TPG366, one line in the startup script is
needed.

The macros are similar to using the templates directly (see above), but are
postfixed with numbers 1...6 for the six sensors, or with an underscore
to define a default for all six sensors. Thus it is possible to use a
default, e.g. PREC_ for most sensors but overwrite PREC1 for one sensor.

Individual precision of the six setpoints can be set using PRECA...F in
addition to PREC1...6 for the sensore in order to allow settings
independent of the sensors. To define a default for all six setpoints use
PRECSP. If none of those is set then PREC_ is used, which defaults to 3.

Because of the limited length of the command line, some shortcuts are
available. In particular a common sensor prefix can be given as P and the
rest of the sensor names can be given as S1...6. Thus the name of sensor 1
is $(SENSOR1) or $(P)$(S1).

The default for P is "$(CONTROLLER)-" and the defaults for S1...6 are
"SENSOR1" ... "SENSOR6". Thus the default name of sensor 1 is
$(CONTROLLER)-SENSOR1.

Example startup script using "TPG366.subs".

    require TPG366
    drvAsynIPPortConfigure MG1,129.129.130.224:8000
    dbLoadTemplate TPG366.subs,"PORT=MG1,CONTROLLER=SIN-VMMG-100,WARN_=2E-07,ALARM_=5E-07,P=SINSB05-VMC,S1=P-A010,MIN1=-4,MAX1=-3,WARN1=Inf,ALARM1=Inf,S2=C-A010,S3=C-A020,S4=C-A030,S5=C-A040,S6=P-A025,MIN6=-4,MAX6=-3,WARN6=Inf,ALARM6=Inf"
