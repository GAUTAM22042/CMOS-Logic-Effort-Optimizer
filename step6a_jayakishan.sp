*==================== step6a_jayakishan_fix.sp ====================
.option ARTIST=2 INGOLD=2 PARHIER=LOCAL PSF=2 HIER_DELIM=0
.temp 25

* -------- Parameters --------
.param VDD=1.1  tr=30p  tf=30p  tclk=1n  toff=100p
.param dRST=-20p     * Step 6.2: early → hold-time failure
.param t2=2n         * 2nd rising clock edge nominal time

* -------- Model Files --------
.include '/opt/cadence/gpdk045/gpdk045_v_6_0/models/hspice/g45n1svt.inc'
.include '/opt/cadence/gpdk045/gpdk045_v_6_0/models/hspice/g45p1svt.inc'

* -------- Post-layout Netlist --------
.include 'XOR_X1-post-layout.sp'   * .SUBCKT XOR_X1 CIN COUT GND PHI RST SOUT

* -------- Power Supplies --------
VDD vdd 0 DC VDD
VSS gnd 0 0

* -------- Clock --------
VPHI phi 0 PULSE(0 VDD 'tclk' 'tr' 'tf' 'tclk/2' 'tclk')

* -------- Include Input Sequence (.vec) --------
.inc 'step3_jayakishan.vec'

* -------- RST timing (early → failure) --------
Vrst rst 0 PWL( 0 0  't2+dRST' 0  't2+dRST+tr' VDD  10n VDD )

* -------- Constant CIN (held high) --------
Vcin cin 0 VDD

* -------- Instantiate layout subckt --------
* Subckt has 7 pins: CIN COUT GND PHI RST SOUT VDD
Xcomb cin cout gnd phi rst sout vdd XOR_X1

* -------- Small capacitive loads --------
Cload_sout sout 0 0.5f
Cload_cout cout 0 0.5f

.option post=2 nomod brief

* -------- Transient Analysis --------
.tran 1p '8*tclk'

* -------- Measurements --------
.meas tran tphi2 WHEN v(phi)=0.55 RISE=2
.meas tran trst1 WHEN v(rst)=0.55 RISE=1
.meas tran d_rst_phi PARAM='trst1 - tphi2'
.meas tran sout_dly_c2 TRIG v(phi) VAL=0.55 RISE=2 \
                      TARG v(sout) VAL=0.55 RISE=1
.meas tran early_flag PARAM='(sout_dly_c2 < 0.5*tclk)'

.probe v(phi) v(rst) v(sout) v(cout)
.end

