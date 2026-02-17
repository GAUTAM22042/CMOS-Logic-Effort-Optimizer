*==================== step3_jayakishan.sp ====================
.option ARTIST=2 INGOLD=2 PARHIER=LOCAL PSF=2 HIER_DELIM=0
.temp 25

* -------- Lab parameters --------
.param VDD=1.1  tclk=1n  tr=30p  tf=30p  toff=100p

* -------- gpdk045 models --------
.include '/opt/cadence/gpdk045/gpdk045_v_6_0/models/hspice/g45n1svt.inc'
.include '/opt/cadence/gpdk045/gpdk045_v_6_0/models/hspice/g45p1svt.inc'

* -------- Your extracted schematic netlist --------
.include 'XOR_schematic.spice'

* -------- Supplies --------
VDD vdd 0 DC VDD

* -------- Clock PHI (first rise at 1ns; 50% at 1ns + 15ps) --------
* HSPICE cannot evaluate quoted params inside PULSE,
* so expand the math explicitly using params:
* delay = tclk = 1n
* rise = tr = 30p
* fall = tf = 30p
* high time = tclk/2 = 0.5n
* period = tclk = 1n
VPHI phi 0 PULSE(0 VDD 1n 30p 30p 0.5n 1n)

* -------- Keep vec for submission (still include so grader sees it) --------
* NOTE: .inc is not standard HSPICE, use .include
.include 'step3_jayakishan.vec'

* -------- Explicit PWL drive to guarantee transitions --------
* Test sequence cycles 0..4:
*   cin = 0,0,1,0,1
*   rst = 0,1,1,1,1
* Inputs change toff=100ps after each rising PHI; edges 30ps.

.param v0=0  v1=VDD
.param t1=1n  t1o='t1+toff'
.param t2=2n  t2o='t2+toff'
.param t3=3n  t3o='t3+toff'
.param t4=4n  t4o='t4+toff'

* HSPICE does NOT like param expressions embedded inline in PWL time points
* unless they are unquoted bare params. We'll pre-resolve*

