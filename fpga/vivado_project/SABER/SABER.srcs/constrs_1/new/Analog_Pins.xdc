## XADC - A0 (Arduino) -> VAUX1 (AD1P/N)
set_property PACKAGE_PIN E17 [get_ports { V_P_i }] ; # A0 positivo -> VAUXP1
set_property PACKAGE_PIN D18 [get_ports { v_N_i }] ; # A0 negativo -> VAUXN1
# (sem IOSTANDARD)