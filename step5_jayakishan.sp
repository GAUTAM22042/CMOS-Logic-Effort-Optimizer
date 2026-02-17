*==================== step5_final_2G.sp ====================
.option INGOLD=2 PARHIER=LOCAL PSF=2 HIER_DELIM=0 post=2 nomod brief
.temp 25

.param VDD=1.1

* ---- PDK models ----
.include '/opt/cadence/gpdk045/gpdk045_v_6_0/models/hspice/g45n1svt.inc'
.include '/opt/cadence/gpdk045/gpdk045_v_6_0/models/hspice/g45p1svt.inc'

* ---- extracted post-layout netlist ----
* .SUBCKT XOR_X1 CIN COUT GND PHI RST SOUT VDD
.include 'XOR_X1-post-layout.sp'

* ---- rails ----
VDD vdd 0 DC 1.1
VSS gnd 0 DC 0

* ---- DUT instance ----
* CIN  COUT  GND   PHI   RST   SOUT  VDD
XUUT cin  cout  gnd  phi  rst  sout  vdd  XOR_X1

* ---- Clock PHI for 2 GHz ----
* period = 0.5ns
* first rising edge at 0.5ns
* high time = 0.25ns
Vphi phi 0 PULSE(0 1.1 0.5n 30p 30p 0.25n 0.5n)

* ---- CIN pattern (0,0,1,0,1) scaled to 0.5ns cycles ----
* PHI edges: 0.5ns, 1.0ns, 1.5ns, 2.0ns, ...
* We toggle CIN around 0.6ns, 1.1ns, 1.6ns, 2.1ns, etc.
Vcin cin 0 PWL( 0 0  0.600n 0  0.630n 0  1.100n 0  1.130n 1.1  1.600n 1.1  1.630n 0  2.100n 0  2.130n 1.1  3.000n 1.1 )

* ---- RST: same idea, assert low first cycle, then high ----
Vrst rst 0 PWL( 0 0  0.600n 0  0.630n 1.1  3.000n 1.1 )

* simulate 3ns total (6 cycles @0.5ns)
.tran 1p 3n

* measure avg power from 0.5ns to 3ns
.meas tran Pavg_2G AVG POWER FROM=0.5n TO=3n

.end

