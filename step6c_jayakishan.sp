*==================== step6_final_good.sp (Step 6.3 clean pass case, no hold fail) ====================
.option ARTIST=2 INGOLD=2 PARHIER=LOCAL PSF=2 HIER_DELIM=0
.temp 25

* -------- Parameters --------
.param VDD=1.1
.param tr=30p
.param tf=30p
.param tclk=1n

* We control clock now:
* PHI rising edges at 1ns, 2ns, 3ns, ...
* So the "2nd rising edge" is exactly at 2ns.
* We'll raise RST a little AFTER 2ns, ex: 2.05ns (50ps later)
.param rst_rise_time = 2.05n

* -------- Model includes --------
.include '/opt/cadence/gpdk045/gpdk045_v_6_0/models/hspice/g45n1svt.inc'
.include '/opt/cadence/gpdk045/gpdk045_v_6_0/models/hspice/g45p1svt.inc'

* -------- Extracted post-layout netlist --------
* Pin order assumed from your working run:
*   .SUBCKT XOR_X1 CIN COUT GND PHI RST SOUT VDD
.include 'XOR_X1-post-layout.sp'

* -------- Rails --------
VDDsrc vdd 0 DC VDD
VSSsrc gnd 0 0

* -------- Clock PHI we OWN now --------
* starts low at 0,
* first rising edge at 1ns,
* 50% duty cycle.
VPHI phi 0 PULSE(0 VDD 1n tr tf 'tclk/2' tclk)

* -------- CIN constant high for hold-time experiment --------
Vcin cin 0 VDD

* -------- RST timing (SAFE CASE) --------
* RST = 0 initially
* goes high shortly AFTER 2ns
* This should AVOID hold-time failure, so SOUT should update on the NEXT cycle.
Vrst rst 0 PWL( \
    0                   0 \
    'rst_rise_time'     0 \
    'rst_rise_time+tr'  VDD \
    10n                 VDD )

* -------- Small loads --------
Cload_sout sout 0 0.5f
Cload_cout cout 0 0.5f

* -------- DUT instance --------
* CIN  COUT  GND  PHI  RST  SOUT  VDD
Xcomb cin cout gnd phi rst sout vdd XOR_X1

* -------- Output control --------
.option post=2 nomod brief

* -------- Transient analysis --------
* run long enough to see the 2ns and 3ns edges
.tran 1p 6n

* -------- Measurements --------
* PHI 2nd rising edge (should be at ~2ns, 50% of VDD ~0.55V)
.meas tran tphi2 WHEN v(phi)=0.55 RISE=2

* RST rising edge timing
.meas tran trst1 WHEN v(rst)=0.55 RISE=1

* Relative timing (should be positive now: RST after PHI edge)
.meas tran d_rst_phi PARAM='trst1 - tphi2'

* Delay from PHI edge #2 to first SOUT rising
.meas tran sout_dly_c2 TRIG v(phi)  VAL=0.55 RISE=2 \
                      TARG v(sout) VAL=0.55 RISE=1

* If this is < 0.5*tclk → bad (latched too early).
* If this is >= 0.5*tclk → good (latched next cycle).
.meas tran early_flag PARAM='(sout_dly_c2 < 0.5*tclk)'

* -------- Probes to screenshot --------
.probe v(phi) v(rst) v(sout)

.end

