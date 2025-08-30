transcript off
onbreak {quit -force}
onerror {quit -force}
transcript on

vlib work
vlib activehdl/xilinx_vip
vlib activehdl/xpm
vlib activehdl/xil_defaultlib
vlib activehdl/xlconstant_v1_1_9
vlib activehdl/xlslice_v1_0_4
vlib activehdl/axi_lite_ipif_v3_0_4
vlib activehdl/lib_cdc_v1_0_3
vlib activehdl/interrupt_control_v3_1_5
vlib activehdl/axi_gpio_v2_0_35
vlib activehdl/axi_infrastructure_v1_1_0
vlib activehdl/axi_vip_v1_1_19
vlib activehdl/processing_system7_vip_v1_0_21
vlib activehdl/proc_sys_reset_v5_0_16
vlib activehdl/smartconnect_v1_0
vlib activehdl/axi_register_slice_v2_1_33

vmap xilinx_vip activehdl/xilinx_vip
vmap xpm activehdl/xpm
vmap xil_defaultlib activehdl/xil_defaultlib
vmap xlconstant_v1_1_9 activehdl/xlconstant_v1_1_9
vmap xlslice_v1_0_4 activehdl/xlslice_v1_0_4
vmap axi_lite_ipif_v3_0_4 activehdl/axi_lite_ipif_v3_0_4
vmap lib_cdc_v1_0_3 activehdl/lib_cdc_v1_0_3
vmap interrupt_control_v3_1_5 activehdl/interrupt_control_v3_1_5
vmap axi_gpio_v2_0_35 activehdl/axi_gpio_v2_0_35
vmap axi_infrastructure_v1_1_0 activehdl/axi_infrastructure_v1_1_0
vmap axi_vip_v1_1_19 activehdl/axi_vip_v1_1_19
vmap processing_system7_vip_v1_0_21 activehdl/processing_system7_vip_v1_0_21
vmap proc_sys_reset_v5_0_16 activehdl/proc_sys_reset_v5_0_16
vmap smartconnect_v1_0 activehdl/smartconnect_v1_0
vmap axi_register_slice_v2_1_33 activehdl/axi_register_slice_v2_1_33

vlog -work xilinx_vip  -sv2k12 "+incdir+D:/Programas/Vivado/2024.2/data/xilinx_vip/include" -l xilinx_vip -l xpm -l xil_defaultlib -l xlconstant_v1_1_9 -l xlslice_v1_0_4 -l axi_lite_ipif_v3_0_4 -l lib_cdc_v1_0_3 -l interrupt_control_v3_1_5 -l axi_gpio_v2_0_35 -l axi_infrastructure_v1_1_0 -l axi_vip_v1_1_19 -l processing_system7_vip_v1_0_21 -l proc_sys_reset_v5_0_16 -l smartconnect_v1_0 -l axi_register_slice_v2_1_33 \
"D:/Programas/Vivado/2024.2/data/xilinx_vip/hdl/axi4stream_vip_axi4streampc.sv" \
"D:/Programas/Vivado/2024.2/data/xilinx_vip/hdl/axi_vip_axi4pc.sv" \
"D:/Programas/Vivado/2024.2/data/xilinx_vip/hdl/xil_common_vip_pkg.sv" \
"D:/Programas/Vivado/2024.2/data/xilinx_vip/hdl/axi4stream_vip_pkg.sv" \
"D:/Programas/Vivado/2024.2/data/xilinx_vip/hdl/axi_vip_pkg.sv" \
"D:/Programas/Vivado/2024.2/data/xilinx_vip/hdl/axi4stream_vip_if.sv" \
"D:/Programas/Vivado/2024.2/data/xilinx_vip/hdl/axi_vip_if.sv" \
"D:/Programas/Vivado/2024.2/data/xilinx_vip/hdl/clk_vip_if.sv" \
"D:/Programas/Vivado/2024.2/data/xilinx_vip/hdl/rst_vip_if.sv" \

vlog -work xpm  -sv2k12 "+incdir+../../../../SABER.gen/sources_1/bd/SABER/ip/SABER_ADC_8_bits_0_1/src/ADC_8_bits_clk_wiz_0_0" "+incdir+../../../../SABER.gen/sources_1/bd/SABER/ipshared/ec67/hdl" "+incdir+../../../../SABER.gen/sources_1/bd/SABER/ipshared/86fe/hdl" "+incdir+../../../../SABER.gen/sources_1/bd/SABER/ipshared/f0b6/hdl/verilog" "+incdir+../../../../SABER.gen/sources_1/bd/SABER/ipshared/0127/hdl/verilog" "+incdir+D:/Programas/Vivado/2024.2/data/xilinx_vip/include" -l xilinx_vip -l xpm -l xil_defaultlib -l xlconstant_v1_1_9 -l xlslice_v1_0_4 -l axi_lite_ipif_v3_0_4 -l lib_cdc_v1_0_3 -l interrupt_control_v3_1_5 -l axi_gpio_v2_0_35 -l axi_infrastructure_v1_1_0 -l axi_vip_v1_1_19 -l processing_system7_vip_v1_0_21 -l proc_sys_reset_v5_0_16 -l smartconnect_v1_0 -l axi_register_slice_v2_1_33 \
"D:/Programas/Vivado/2024.2/data/ip/xpm/xpm_cdc/hdl/xpm_cdc.sv" \
"D:/Programas/Vivado/2024.2/data/ip/xpm/xpm_fifo/hdl/xpm_fifo.sv" \
"D:/Programas/Vivado/2024.2/data/ip/xpm/xpm_memory/hdl/xpm_memory.sv" \

vcom -work xpm -93  \
"D:/Programas/Vivado/2024.2/data/ip/xpm/xpm_VCOMP.vhd" \

vlog -work xil_defaultlib  -v2k5 "+incdir+../../../../SABER.gen/sources_1/bd/SABER/ip/SABER_ADC_8_bits_0_1/src/ADC_8_bits_clk_wiz_0_0" "+incdir+../../../../SABER.gen/sources_1/bd/SABER/ipshared/ec67/hdl" "+incdir+../../../../SABER.gen/sources_1/bd/SABER/ipshared/86fe/hdl" "+incdir+../../../../SABER.gen/sources_1/bd/SABER/ipshared/f0b6/hdl/verilog" "+incdir+../../../../SABER.gen/sources_1/bd/SABER/ipshared/0127/hdl/verilog" "+incdir+D:/Programas/Vivado/2024.2/data/xilinx_vip/include" -l xilinx_vip -l xpm -l xil_defaultlib -l xlconstant_v1_1_9 -l xlslice_v1_0_4 -l axi_lite_ipif_v3_0_4 -l lib_cdc_v1_0_3 -l interrupt_control_v3_1_5 -l axi_gpio_v2_0_35 -l axi_infrastructure_v1_1_0 -l axi_vip_v1_1_19 -l processing_system7_vip_v1_0_21 -l proc_sys_reset_v5_0_16 -l smartconnect_v1_0 -l axi_register_slice_v2_1_33 \
"../../../../SABER.gen/sources_1/bd/SABER/ipshared/5d48/hdl/reg_v3_slave_lite_v1_0_S00_AXI.v" \
"../../../../SABER.gen/sources_1/bd/SABER/ipshared/5d48/hdl/reg_v3.v" \
"../../../../SABER.gen/sources_1/bd/SABER/ip/SABER_wifi_pack_reg_0_0/sim/SABER_wifi_pack_reg_0_0.v" \
"../../../../SABER.gen/sources_1/bd/SABER/ip/SABER_ADC_8_bits_0_1/src/ADC_8_bits_xadc_wiz_0_0/ADC_8_bits_xadc_wiz_0_0.v" \
"../../../../SABER.gen/sources_1/bd/SABER/ip/SABER_ADC_8_bits_0_1/src/ADC_8_bits_clk_wiz_0_0/ADC_8_bits_clk_wiz_0_0_clk_wiz.v" \
"../../../../SABER.gen/sources_1/bd/SABER/ip/SABER_ADC_8_bits_0_1/src/ADC_8_bits_clk_wiz_0_0/ADC_8_bits_clk_wiz_0_0.v" \

vlog -work xlconstant_v1_1_9  -v2k5 "+incdir+../../../../SABER.gen/sources_1/bd/SABER/ip/SABER_ADC_8_bits_0_1/src/ADC_8_bits_clk_wiz_0_0" "+incdir+../../../../SABER.gen/sources_1/bd/SABER/ipshared/ec67/hdl" "+incdir+../../../../SABER.gen/sources_1/bd/SABER/ipshared/86fe/hdl" "+incdir+../../../../SABER.gen/sources_1/bd/SABER/ipshared/f0b6/hdl/verilog" "+incdir+../../../../SABER.gen/sources_1/bd/SABER/ipshared/0127/hdl/verilog" "+incdir+D:/Programas/Vivado/2024.2/data/xilinx_vip/include" -l xilinx_vip -l xpm -l xil_defaultlib -l xlconstant_v1_1_9 -l xlslice_v1_0_4 -l axi_lite_ipif_v3_0_4 -l lib_cdc_v1_0_3 -l interrupt_control_v3_1_5 -l axi_gpio_v2_0_35 -l axi_infrastructure_v1_1_0 -l axi_vip_v1_1_19 -l processing_system7_vip_v1_0_21 -l proc_sys_reset_v5_0_16 -l smartconnect_v1_0 -l axi_register_slice_v2_1_33 \
"../../../../SABER.gen/sources_1/bd/SABER/ip/SABER_ADC_8_bits_0_1/src/ADC_8_bits_xlconstant_0_0/hdl/xlconstant_v1_1_vl_rfs.v" \

vlog -work xil_defaultlib  -v2k5 "+incdir+../../../../SABER.gen/sources_1/bd/SABER/ip/SABER_ADC_8_bits_0_1/src/ADC_8_bits_clk_wiz_0_0" "+incdir+../../../../SABER.gen/sources_1/bd/SABER/ipshared/ec67/hdl" "+incdir+../../../../SABER.gen/sources_1/bd/SABER/ipshared/86fe/hdl" "+incdir+../../../../SABER.gen/sources_1/bd/SABER/ipshared/f0b6/hdl/verilog" "+incdir+../../../../SABER.gen/sources_1/bd/SABER/ipshared/0127/hdl/verilog" "+incdir+D:/Programas/Vivado/2024.2/data/xilinx_vip/include" -l xilinx_vip -l xpm -l xil_defaultlib -l xlconstant_v1_1_9 -l xlslice_v1_0_4 -l axi_lite_ipif_v3_0_4 -l lib_cdc_v1_0_3 -l interrupt_control_v3_1_5 -l axi_gpio_v2_0_35 -l axi_infrastructure_v1_1_0 -l axi_vip_v1_1_19 -l processing_system7_vip_v1_0_21 -l proc_sys_reset_v5_0_16 -l smartconnect_v1_0 -l axi_register_slice_v2_1_33 \
"../../../../SABER.gen/sources_1/bd/SABER/ip/SABER_ADC_8_bits_0_1/src/ADC_8_bits_xlconstant_0_0/sim/ADC_8_bits_xlconstant_0_0.v" \

vlog -work xlslice_v1_0_4  -v2k5 "+incdir+../../../../SABER.gen/sources_1/bd/SABER/ip/SABER_ADC_8_bits_0_1/src/ADC_8_bits_clk_wiz_0_0" "+incdir+../../../../SABER.gen/sources_1/bd/SABER/ipshared/ec67/hdl" "+incdir+../../../../SABER.gen/sources_1/bd/SABER/ipshared/86fe/hdl" "+incdir+../../../../SABER.gen/sources_1/bd/SABER/ipshared/f0b6/hdl/verilog" "+incdir+../../../../SABER.gen/sources_1/bd/SABER/ipshared/0127/hdl/verilog" "+incdir+D:/Programas/Vivado/2024.2/data/xilinx_vip/include" -l xilinx_vip -l xpm -l xil_defaultlib -l xlconstant_v1_1_9 -l xlslice_v1_0_4 -l axi_lite_ipif_v3_0_4 -l lib_cdc_v1_0_3 -l interrupt_control_v3_1_5 -l axi_gpio_v2_0_35 -l axi_infrastructure_v1_1_0 -l axi_vip_v1_1_19 -l processing_system7_vip_v1_0_21 -l proc_sys_reset_v5_0_16 -l smartconnect_v1_0 -l axi_register_slice_v2_1_33 \
"../../../../SABER.gen/sources_1/bd/SABER/ip/SABER_ADC_8_bits_0_1/src/ADC_8_bits_xlslice_0_0/hdl/xlslice_v1_0_vl_rfs.v" \

vlog -work xil_defaultlib  -v2k5 "+incdir+../../../../SABER.gen/sources_1/bd/SABER/ip/SABER_ADC_8_bits_0_1/src/ADC_8_bits_clk_wiz_0_0" "+incdir+../../../../SABER.gen/sources_1/bd/SABER/ipshared/ec67/hdl" "+incdir+../../../../SABER.gen/sources_1/bd/SABER/ipshared/86fe/hdl" "+incdir+../../../../SABER.gen/sources_1/bd/SABER/ipshared/f0b6/hdl/verilog" "+incdir+../../../../SABER.gen/sources_1/bd/SABER/ipshared/0127/hdl/verilog" "+incdir+D:/Programas/Vivado/2024.2/data/xilinx_vip/include" -l xilinx_vip -l xpm -l xil_defaultlib -l xlconstant_v1_1_9 -l xlslice_v1_0_4 -l axi_lite_ipif_v3_0_4 -l lib_cdc_v1_0_3 -l interrupt_control_v3_1_5 -l axi_gpio_v2_0_35 -l axi_infrastructure_v1_1_0 -l axi_vip_v1_1_19 -l processing_system7_vip_v1_0_21 -l proc_sys_reset_v5_0_16 -l smartconnect_v1_0 -l axi_register_slice_v2_1_33 \
"../../../../SABER.gen/sources_1/bd/SABER/ip/SABER_ADC_8_bits_0_1/src/ADC_8_bits_xlslice_0_0/sim/ADC_8_bits_xlslice_0_0.v" \
"../../../../SABER.gen/sources_1/bd/SABER/ip/SABER_ADC_8_bits_0_1/src/ADC_8_bits_xlconstant_1_0/sim/ADC_8_bits_xlconstant_1_0.v" \
"../../../../SABER.gen/sources_1/bd/SABER/ip/SABER_ADC_8_bits_0_1/src/ADC_8_bits_xlconstant_2_0/sim/ADC_8_bits_xlconstant_2_0.v" \
"../../../../SABER.gen/sources_1/bd/SABER/ipshared/b3ae/sim/ADC_8_bits.v" \
"../../../../SABER.gen/sources_1/bd/SABER/ip/SABER_ADC_8_bits_0_1/sim/SABER_ADC_8_bits_0_1.v" \

vcom -work axi_lite_ipif_v3_0_4 -93  \
"../../../../SABER.gen/sources_1/bd/SABER/ipshared/66ea/hdl/axi_lite_ipif_v3_0_vh_rfs.vhd" \

vcom -work lib_cdc_v1_0_3 -93  \
"../../../../SABER.gen/sources_1/bd/SABER/ipshared/2a4f/hdl/lib_cdc_v1_0_rfs.vhd" \

vcom -work interrupt_control_v3_1_5 -93  \
"../../../../SABER.gen/sources_1/bd/SABER/ipshared/d8cc/hdl/interrupt_control_v3_1_vh_rfs.vhd" \

vcom -work axi_gpio_v2_0_35 -93  \
"../../../../SABER.gen/sources_1/bd/SABER/ipshared/6718/hdl/axi_gpio_v2_0_vh_rfs.vhd" \

vcom -work xil_defaultlib -93  \
"../../../../SABER.gen/sources_1/bd/SABER/ip/SABER_axi_gpio_0_0/sim/SABER_axi_gpio_0_0.vhd" \

vlog -work axi_infrastructure_v1_1_0  -v2k5 "+incdir+../../../../SABER.gen/sources_1/bd/SABER/ip/SABER_ADC_8_bits_0_1/src/ADC_8_bits_clk_wiz_0_0" "+incdir+../../../../SABER.gen/sources_1/bd/SABER/ipshared/ec67/hdl" "+incdir+../../../../SABER.gen/sources_1/bd/SABER/ipshared/86fe/hdl" "+incdir+../../../../SABER.gen/sources_1/bd/SABER/ipshared/f0b6/hdl/verilog" "+incdir+../../../../SABER.gen/sources_1/bd/SABER/ipshared/0127/hdl/verilog" "+incdir+D:/Programas/Vivado/2024.2/data/xilinx_vip/include" -l xilinx_vip -l xpm -l xil_defaultlib -l xlconstant_v1_1_9 -l xlslice_v1_0_4 -l axi_lite_ipif_v3_0_4 -l lib_cdc_v1_0_3 -l interrupt_control_v3_1_5 -l axi_gpio_v2_0_35 -l axi_infrastructure_v1_1_0 -l axi_vip_v1_1_19 -l processing_system7_vip_v1_0_21 -l proc_sys_reset_v5_0_16 -l smartconnect_v1_0 -l axi_register_slice_v2_1_33 \
"../../../../SABER.gen/sources_1/bd/SABER/ipshared/ec67/hdl/axi_infrastructure_v1_1_vl_rfs.v" \

vlog -work axi_vip_v1_1_19  -sv2k12 "+incdir+../../../../SABER.gen/sources_1/bd/SABER/ip/SABER_ADC_8_bits_0_1/src/ADC_8_bits_clk_wiz_0_0" "+incdir+../../../../SABER.gen/sources_1/bd/SABER/ipshared/ec67/hdl" "+incdir+../../../../SABER.gen/sources_1/bd/SABER/ipshared/86fe/hdl" "+incdir+../../../../SABER.gen/sources_1/bd/SABER/ipshared/f0b6/hdl/verilog" "+incdir+../../../../SABER.gen/sources_1/bd/SABER/ipshared/0127/hdl/verilog" "+incdir+D:/Programas/Vivado/2024.2/data/xilinx_vip/include" -l xilinx_vip -l xpm -l xil_defaultlib -l xlconstant_v1_1_9 -l xlslice_v1_0_4 -l axi_lite_ipif_v3_0_4 -l lib_cdc_v1_0_3 -l interrupt_control_v3_1_5 -l axi_gpio_v2_0_35 -l axi_infrastructure_v1_1_0 -l axi_vip_v1_1_19 -l processing_system7_vip_v1_0_21 -l proc_sys_reset_v5_0_16 -l smartconnect_v1_0 -l axi_register_slice_v2_1_33 \
"../../../../SABER.gen/sources_1/bd/SABER/ipshared/8c45/hdl/axi_vip_v1_1_vl_rfs.sv" \

vlog -work processing_system7_vip_v1_0_21  -sv2k12 "+incdir+../../../../SABER.gen/sources_1/bd/SABER/ip/SABER_ADC_8_bits_0_1/src/ADC_8_bits_clk_wiz_0_0" "+incdir+../../../../SABER.gen/sources_1/bd/SABER/ipshared/ec67/hdl" "+incdir+../../../../SABER.gen/sources_1/bd/SABER/ipshared/86fe/hdl" "+incdir+../../../../SABER.gen/sources_1/bd/SABER/ipshared/f0b6/hdl/verilog" "+incdir+../../../../SABER.gen/sources_1/bd/SABER/ipshared/0127/hdl/verilog" "+incdir+D:/Programas/Vivado/2024.2/data/xilinx_vip/include" -l xilinx_vip -l xpm -l xil_defaultlib -l xlconstant_v1_1_9 -l xlslice_v1_0_4 -l axi_lite_ipif_v3_0_4 -l lib_cdc_v1_0_3 -l interrupt_control_v3_1_5 -l axi_gpio_v2_0_35 -l axi_infrastructure_v1_1_0 -l axi_vip_v1_1_19 -l processing_system7_vip_v1_0_21 -l proc_sys_reset_v5_0_16 -l smartconnect_v1_0 -l axi_register_slice_v2_1_33 \
"../../../../SABER.gen/sources_1/bd/SABER/ipshared/86fe/hdl/processing_system7_vip_v1_0_vl_rfs.sv" \

vlog -work xil_defaultlib  -v2k5 "+incdir+../../../../SABER.gen/sources_1/bd/SABER/ip/SABER_ADC_8_bits_0_1/src/ADC_8_bits_clk_wiz_0_0" "+incdir+../../../../SABER.gen/sources_1/bd/SABER/ipshared/ec67/hdl" "+incdir+../../../../SABER.gen/sources_1/bd/SABER/ipshared/86fe/hdl" "+incdir+../../../../SABER.gen/sources_1/bd/SABER/ipshared/f0b6/hdl/verilog" "+incdir+../../../../SABER.gen/sources_1/bd/SABER/ipshared/0127/hdl/verilog" "+incdir+D:/Programas/Vivado/2024.2/data/xilinx_vip/include" -l xilinx_vip -l xpm -l xil_defaultlib -l xlconstant_v1_1_9 -l xlslice_v1_0_4 -l axi_lite_ipif_v3_0_4 -l lib_cdc_v1_0_3 -l interrupt_control_v3_1_5 -l axi_gpio_v2_0_35 -l axi_infrastructure_v1_1_0 -l axi_vip_v1_1_19 -l processing_system7_vip_v1_0_21 -l proc_sys_reset_v5_0_16 -l smartconnect_v1_0 -l axi_register_slice_v2_1_33 \
"../../../../SABER.gen/sources_1/bd/SABER/ip/SABER_processing_system7_0_0/sim/SABER_processing_system7_0_0.v" \

vcom -work proc_sys_reset_v5_0_16 -93  \
"../../../../SABER.gen/sources_1/bd/SABER/ipshared/0831/hdl/proc_sys_reset_v5_0_vh_rfs.vhd" \

vcom -work xil_defaultlib -93  \
"../../../../SABER.gen/sources_1/bd/SABER/ip/SABER_proc_sys_reset_0_0/sim/SABER_proc_sys_reset_0_0.vhd" \

vlog -work xil_defaultlib  -v2k5 "+incdir+../../../../SABER.gen/sources_1/bd/SABER/ip/SABER_ADC_8_bits_0_1/src/ADC_8_bits_clk_wiz_0_0" "+incdir+../../../../SABER.gen/sources_1/bd/SABER/ipshared/ec67/hdl" "+incdir+../../../../SABER.gen/sources_1/bd/SABER/ipshared/86fe/hdl" "+incdir+../../../../SABER.gen/sources_1/bd/SABER/ipshared/f0b6/hdl/verilog" "+incdir+../../../../SABER.gen/sources_1/bd/SABER/ipshared/0127/hdl/verilog" "+incdir+D:/Programas/Vivado/2024.2/data/xilinx_vip/include" -l xilinx_vip -l xpm -l xil_defaultlib -l xlconstant_v1_1_9 -l xlslice_v1_0_4 -l axi_lite_ipif_v3_0_4 -l lib_cdc_v1_0_3 -l interrupt_control_v3_1_5 -l axi_gpio_v2_0_35 -l axi_infrastructure_v1_1_0 -l axi_vip_v1_1_19 -l processing_system7_vip_v1_0_21 -l proc_sys_reset_v5_0_16 -l smartconnect_v1_0 -l axi_register_slice_v2_1_33 \
"../../../../SABER.gen/sources_1/bd/SABER/ip/SABER_axi_smc_0/bd_0/sim/bd_2119.v" \
"../../../../SABER.gen/sources_1/bd/SABER/ip/SABER_axi_smc_0/bd_0/ip/ip_0/sim/bd_2119_one_0.v" \

vcom -work xil_defaultlib -93  \
"../../../../SABER.gen/sources_1/bd/SABER/ip/SABER_axi_smc_0/bd_0/ip/ip_1/sim/bd_2119_psr_aclk_0.vhd" \

vlog -work smartconnect_v1_0  -sv2k12 "+incdir+../../../../SABER.gen/sources_1/bd/SABER/ip/SABER_ADC_8_bits_0_1/src/ADC_8_bits_clk_wiz_0_0" "+incdir+../../../../SABER.gen/sources_1/bd/SABER/ipshared/ec67/hdl" "+incdir+../../../../SABER.gen/sources_1/bd/SABER/ipshared/86fe/hdl" "+incdir+../../../../SABER.gen/sources_1/bd/SABER/ipshared/f0b6/hdl/verilog" "+incdir+../../../../SABER.gen/sources_1/bd/SABER/ipshared/0127/hdl/verilog" "+incdir+D:/Programas/Vivado/2024.2/data/xilinx_vip/include" -l xilinx_vip -l xpm -l xil_defaultlib -l xlconstant_v1_1_9 -l xlslice_v1_0_4 -l axi_lite_ipif_v3_0_4 -l lib_cdc_v1_0_3 -l interrupt_control_v3_1_5 -l axi_gpio_v2_0_35 -l axi_infrastructure_v1_1_0 -l axi_vip_v1_1_19 -l processing_system7_vip_v1_0_21 -l proc_sys_reset_v5_0_16 -l smartconnect_v1_0 -l axi_register_slice_v2_1_33 \
"../../../../SABER.gen/sources_1/bd/SABER/ipshared/f0b6/hdl/sc_util_v1_0_vl_rfs.sv" \
"../../../../SABER.gen/sources_1/bd/SABER/ipshared/3718/hdl/sc_switchboard_v1_0_vl_rfs.sv" \

vlog -work xil_defaultlib  -sv2k12 "+incdir+../../../../SABER.gen/sources_1/bd/SABER/ip/SABER_ADC_8_bits_0_1/src/ADC_8_bits_clk_wiz_0_0" "+incdir+../../../../SABER.gen/sources_1/bd/SABER/ipshared/ec67/hdl" "+incdir+../../../../SABER.gen/sources_1/bd/SABER/ipshared/86fe/hdl" "+incdir+../../../../SABER.gen/sources_1/bd/SABER/ipshared/f0b6/hdl/verilog" "+incdir+../../../../SABER.gen/sources_1/bd/SABER/ipshared/0127/hdl/verilog" "+incdir+D:/Programas/Vivado/2024.2/data/xilinx_vip/include" -l xilinx_vip -l xpm -l xil_defaultlib -l xlconstant_v1_1_9 -l xlslice_v1_0_4 -l axi_lite_ipif_v3_0_4 -l lib_cdc_v1_0_3 -l interrupt_control_v3_1_5 -l axi_gpio_v2_0_35 -l axi_infrastructure_v1_1_0 -l axi_vip_v1_1_19 -l processing_system7_vip_v1_0_21 -l proc_sys_reset_v5_0_16 -l smartconnect_v1_0 -l axi_register_slice_v2_1_33 \
"../../../../SABER.gen/sources_1/bd/SABER/ip/SABER_axi_smc_0/bd_0/ip/ip_2/sim/bd_2119_arinsw_0.sv" \
"../../../../SABER.gen/sources_1/bd/SABER/ip/SABER_axi_smc_0/bd_0/ip/ip_3/sim/bd_2119_rinsw_0.sv" \
"../../../../SABER.gen/sources_1/bd/SABER/ip/SABER_axi_smc_0/bd_0/ip/ip_4/sim/bd_2119_awinsw_0.sv" \
"../../../../SABER.gen/sources_1/bd/SABER/ip/SABER_axi_smc_0/bd_0/ip/ip_5/sim/bd_2119_winsw_0.sv" \
"../../../../SABER.gen/sources_1/bd/SABER/ip/SABER_axi_smc_0/bd_0/ip/ip_6/sim/bd_2119_binsw_0.sv" \
"../../../../SABER.gen/sources_1/bd/SABER/ip/SABER_axi_smc_0/bd_0/ip/ip_7/sim/bd_2119_aroutsw_0.sv" \
"../../../../SABER.gen/sources_1/bd/SABER/ip/SABER_axi_smc_0/bd_0/ip/ip_8/sim/bd_2119_routsw_0.sv" \
"../../../../SABER.gen/sources_1/bd/SABER/ip/SABER_axi_smc_0/bd_0/ip/ip_9/sim/bd_2119_awoutsw_0.sv" \
"../../../../SABER.gen/sources_1/bd/SABER/ip/SABER_axi_smc_0/bd_0/ip/ip_10/sim/bd_2119_woutsw_0.sv" \
"../../../../SABER.gen/sources_1/bd/SABER/ip/SABER_axi_smc_0/bd_0/ip/ip_11/sim/bd_2119_boutsw_0.sv" \

vlog -work smartconnect_v1_0  -sv2k12 "+incdir+../../../../SABER.gen/sources_1/bd/SABER/ip/SABER_ADC_8_bits_0_1/src/ADC_8_bits_clk_wiz_0_0" "+incdir+../../../../SABER.gen/sources_1/bd/SABER/ipshared/ec67/hdl" "+incdir+../../../../SABER.gen/sources_1/bd/SABER/ipshared/86fe/hdl" "+incdir+../../../../SABER.gen/sources_1/bd/SABER/ipshared/f0b6/hdl/verilog" "+incdir+../../../../SABER.gen/sources_1/bd/SABER/ipshared/0127/hdl/verilog" "+incdir+D:/Programas/Vivado/2024.2/data/xilinx_vip/include" -l xilinx_vip -l xpm -l xil_defaultlib -l xlconstant_v1_1_9 -l xlslice_v1_0_4 -l axi_lite_ipif_v3_0_4 -l lib_cdc_v1_0_3 -l interrupt_control_v3_1_5 -l axi_gpio_v2_0_35 -l axi_infrastructure_v1_1_0 -l axi_vip_v1_1_19 -l processing_system7_vip_v1_0_21 -l proc_sys_reset_v5_0_16 -l smartconnect_v1_0 -l axi_register_slice_v2_1_33 \
"../../../../SABER.gen/sources_1/bd/SABER/ipshared/0127/hdl/sc_node_v1_0_vl_rfs.sv" \

vlog -work xil_defaultlib  -sv2k12 "+incdir+../../../../SABER.gen/sources_1/bd/SABER/ip/SABER_ADC_8_bits_0_1/src/ADC_8_bits_clk_wiz_0_0" "+incdir+../../../../SABER.gen/sources_1/bd/SABER/ipshared/ec67/hdl" "+incdir+../../../../SABER.gen/sources_1/bd/SABER/ipshared/86fe/hdl" "+incdir+../../../../SABER.gen/sources_1/bd/SABER/ipshared/f0b6/hdl/verilog" "+incdir+../../../../SABER.gen/sources_1/bd/SABER/ipshared/0127/hdl/verilog" "+incdir+D:/Programas/Vivado/2024.2/data/xilinx_vip/include" -l xilinx_vip -l xpm -l xil_defaultlib -l xlconstant_v1_1_9 -l xlslice_v1_0_4 -l axi_lite_ipif_v3_0_4 -l lib_cdc_v1_0_3 -l interrupt_control_v3_1_5 -l axi_gpio_v2_0_35 -l axi_infrastructure_v1_1_0 -l axi_vip_v1_1_19 -l processing_system7_vip_v1_0_21 -l proc_sys_reset_v5_0_16 -l smartconnect_v1_0 -l axi_register_slice_v2_1_33 \
"../../../../SABER.gen/sources_1/bd/SABER/ip/SABER_axi_smc_0/bd_0/ip/ip_12/sim/bd_2119_arni_0.sv" \
"../../../../SABER.gen/sources_1/bd/SABER/ip/SABER_axi_smc_0/bd_0/ip/ip_13/sim/bd_2119_rni_0.sv" \
"../../../../SABER.gen/sources_1/bd/SABER/ip/SABER_axi_smc_0/bd_0/ip/ip_14/sim/bd_2119_awni_0.sv" \
"../../../../SABER.gen/sources_1/bd/SABER/ip/SABER_axi_smc_0/bd_0/ip/ip_15/sim/bd_2119_wni_0.sv" \
"../../../../SABER.gen/sources_1/bd/SABER/ip/SABER_axi_smc_0/bd_0/ip/ip_16/sim/bd_2119_bni_0.sv" \

vlog -work smartconnect_v1_0  -sv2k12 "+incdir+../../../../SABER.gen/sources_1/bd/SABER/ip/SABER_ADC_8_bits_0_1/src/ADC_8_bits_clk_wiz_0_0" "+incdir+../../../../SABER.gen/sources_1/bd/SABER/ipshared/ec67/hdl" "+incdir+../../../../SABER.gen/sources_1/bd/SABER/ipshared/86fe/hdl" "+incdir+../../../../SABER.gen/sources_1/bd/SABER/ipshared/f0b6/hdl/verilog" "+incdir+../../../../SABER.gen/sources_1/bd/SABER/ipshared/0127/hdl/verilog" "+incdir+D:/Programas/Vivado/2024.2/data/xilinx_vip/include" -l xilinx_vip -l xpm -l xil_defaultlib -l xlconstant_v1_1_9 -l xlslice_v1_0_4 -l axi_lite_ipif_v3_0_4 -l lib_cdc_v1_0_3 -l interrupt_control_v3_1_5 -l axi_gpio_v2_0_35 -l axi_infrastructure_v1_1_0 -l axi_vip_v1_1_19 -l processing_system7_vip_v1_0_21 -l proc_sys_reset_v5_0_16 -l smartconnect_v1_0 -l axi_register_slice_v2_1_33 \
"../../../../SABER.gen/sources_1/bd/SABER/ipshared/f49a/hdl/sc_mmu_v1_0_vl_rfs.sv" \

vlog -work xil_defaultlib  -sv2k12 "+incdir+../../../../SABER.gen/sources_1/bd/SABER/ip/SABER_ADC_8_bits_0_1/src/ADC_8_bits_clk_wiz_0_0" "+incdir+../../../../SABER.gen/sources_1/bd/SABER/ipshared/ec67/hdl" "+incdir+../../../../SABER.gen/sources_1/bd/SABER/ipshared/86fe/hdl" "+incdir+../../../../SABER.gen/sources_1/bd/SABER/ipshared/f0b6/hdl/verilog" "+incdir+../../../../SABER.gen/sources_1/bd/SABER/ipshared/0127/hdl/verilog" "+incdir+D:/Programas/Vivado/2024.2/data/xilinx_vip/include" -l xilinx_vip -l xpm -l xil_defaultlib -l xlconstant_v1_1_9 -l xlslice_v1_0_4 -l axi_lite_ipif_v3_0_4 -l lib_cdc_v1_0_3 -l interrupt_control_v3_1_5 -l axi_gpio_v2_0_35 -l axi_infrastructure_v1_1_0 -l axi_vip_v1_1_19 -l processing_system7_vip_v1_0_21 -l proc_sys_reset_v5_0_16 -l smartconnect_v1_0 -l axi_register_slice_v2_1_33 \
"../../../../SABER.gen/sources_1/bd/SABER/ip/SABER_axi_smc_0/bd_0/ip/ip_17/sim/bd_2119_s00mmu_0.sv" \

vlog -work smartconnect_v1_0  -sv2k12 "+incdir+../../../../SABER.gen/sources_1/bd/SABER/ip/SABER_ADC_8_bits_0_1/src/ADC_8_bits_clk_wiz_0_0" "+incdir+../../../../SABER.gen/sources_1/bd/SABER/ipshared/ec67/hdl" "+incdir+../../../../SABER.gen/sources_1/bd/SABER/ipshared/86fe/hdl" "+incdir+../../../../SABER.gen/sources_1/bd/SABER/ipshared/f0b6/hdl/verilog" "+incdir+../../../../SABER.gen/sources_1/bd/SABER/ipshared/0127/hdl/verilog" "+incdir+D:/Programas/Vivado/2024.2/data/xilinx_vip/include" -l xilinx_vip -l xpm -l xil_defaultlib -l xlconstant_v1_1_9 -l xlslice_v1_0_4 -l axi_lite_ipif_v3_0_4 -l lib_cdc_v1_0_3 -l interrupt_control_v3_1_5 -l axi_gpio_v2_0_35 -l axi_infrastructure_v1_1_0 -l axi_vip_v1_1_19 -l processing_system7_vip_v1_0_21 -l proc_sys_reset_v5_0_16 -l smartconnect_v1_0 -l axi_register_slice_v2_1_33 \
"../../../../SABER.gen/sources_1/bd/SABER/ipshared/2da8/hdl/sc_transaction_regulator_v1_0_vl_rfs.sv" \

vlog -work xil_defaultlib  -sv2k12 "+incdir+../../../../SABER.gen/sources_1/bd/SABER/ip/SABER_ADC_8_bits_0_1/src/ADC_8_bits_clk_wiz_0_0" "+incdir+../../../../SABER.gen/sources_1/bd/SABER/ipshared/ec67/hdl" "+incdir+../../../../SABER.gen/sources_1/bd/SABER/ipshared/86fe/hdl" "+incdir+../../../../SABER.gen/sources_1/bd/SABER/ipshared/f0b6/hdl/verilog" "+incdir+../../../../SABER.gen/sources_1/bd/SABER/ipshared/0127/hdl/verilog" "+incdir+D:/Programas/Vivado/2024.2/data/xilinx_vip/include" -l xilinx_vip -l xpm -l xil_defaultlib -l xlconstant_v1_1_9 -l xlslice_v1_0_4 -l axi_lite_ipif_v3_0_4 -l lib_cdc_v1_0_3 -l interrupt_control_v3_1_5 -l axi_gpio_v2_0_35 -l axi_infrastructure_v1_1_0 -l axi_vip_v1_1_19 -l processing_system7_vip_v1_0_21 -l proc_sys_reset_v5_0_16 -l smartconnect_v1_0 -l axi_register_slice_v2_1_33 \
"../../../../SABER.gen/sources_1/bd/SABER/ip/SABER_axi_smc_0/bd_0/ip/ip_18/sim/bd_2119_s00tr_0.sv" \

vlog -work smartconnect_v1_0  -sv2k12 "+incdir+../../../../SABER.gen/sources_1/bd/SABER/ip/SABER_ADC_8_bits_0_1/src/ADC_8_bits_clk_wiz_0_0" "+incdir+../../../../SABER.gen/sources_1/bd/SABER/ipshared/ec67/hdl" "+incdir+../../../../SABER.gen/sources_1/bd/SABER/ipshared/86fe/hdl" "+incdir+../../../../SABER.gen/sources_1/bd/SABER/ipshared/f0b6/hdl/verilog" "+incdir+../../../../SABER.gen/sources_1/bd/SABER/ipshared/0127/hdl/verilog" "+incdir+D:/Programas/Vivado/2024.2/data/xilinx_vip/include" -l xilinx_vip -l xpm -l xil_defaultlib -l xlconstant_v1_1_9 -l xlslice_v1_0_4 -l axi_lite_ipif_v3_0_4 -l lib_cdc_v1_0_3 -l interrupt_control_v3_1_5 -l axi_gpio_v2_0_35 -l axi_infrastructure_v1_1_0 -l axi_vip_v1_1_19 -l processing_system7_vip_v1_0_21 -l proc_sys_reset_v5_0_16 -l smartconnect_v1_0 -l axi_register_slice_v2_1_33 \
"../../../../SABER.gen/sources_1/bd/SABER/ipshared/63ed/hdl/sc_si_converter_v1_0_vl_rfs.sv" \

vlog -work xil_defaultlib  -sv2k12 "+incdir+../../../../SABER.gen/sources_1/bd/SABER/ip/SABER_ADC_8_bits_0_1/src/ADC_8_bits_clk_wiz_0_0" "+incdir+../../../../SABER.gen/sources_1/bd/SABER/ipshared/ec67/hdl" "+incdir+../../../../SABER.gen/sources_1/bd/SABER/ipshared/86fe/hdl" "+incdir+../../../../SABER.gen/sources_1/bd/SABER/ipshared/f0b6/hdl/verilog" "+incdir+../../../../SABER.gen/sources_1/bd/SABER/ipshared/0127/hdl/verilog" "+incdir+D:/Programas/Vivado/2024.2/data/xilinx_vip/include" -l xilinx_vip -l xpm -l xil_defaultlib -l xlconstant_v1_1_9 -l xlslice_v1_0_4 -l axi_lite_ipif_v3_0_4 -l lib_cdc_v1_0_3 -l interrupt_control_v3_1_5 -l axi_gpio_v2_0_35 -l axi_infrastructure_v1_1_0 -l axi_vip_v1_1_19 -l processing_system7_vip_v1_0_21 -l proc_sys_reset_v5_0_16 -l smartconnect_v1_0 -l axi_register_slice_v2_1_33 \
"../../../../SABER.gen/sources_1/bd/SABER/ip/SABER_axi_smc_0/bd_0/ip/ip_19/sim/bd_2119_s00sic_0.sv" \

vlog -work smartconnect_v1_0  -sv2k12 "+incdir+../../../../SABER.gen/sources_1/bd/SABER/ip/SABER_ADC_8_bits_0_1/src/ADC_8_bits_clk_wiz_0_0" "+incdir+../../../../SABER.gen/sources_1/bd/SABER/ipshared/ec67/hdl" "+incdir+../../../../SABER.gen/sources_1/bd/SABER/ipshared/86fe/hdl" "+incdir+../../../../SABER.gen/sources_1/bd/SABER/ipshared/f0b6/hdl/verilog" "+incdir+../../../../SABER.gen/sources_1/bd/SABER/ipshared/0127/hdl/verilog" "+incdir+D:/Programas/Vivado/2024.2/data/xilinx_vip/include" -l xilinx_vip -l xpm -l xil_defaultlib -l xlconstant_v1_1_9 -l xlslice_v1_0_4 -l axi_lite_ipif_v3_0_4 -l lib_cdc_v1_0_3 -l interrupt_control_v3_1_5 -l axi_gpio_v2_0_35 -l axi_infrastructure_v1_1_0 -l axi_vip_v1_1_19 -l processing_system7_vip_v1_0_21 -l proc_sys_reset_v5_0_16 -l smartconnect_v1_0 -l axi_register_slice_v2_1_33 \
"../../../../SABER.gen/sources_1/bd/SABER/ipshared/cef3/hdl/sc_axi2sc_v1_0_vl_rfs.sv" \

vlog -work xil_defaultlib  -sv2k12 "+incdir+../../../../SABER.gen/sources_1/bd/SABER/ip/SABER_ADC_8_bits_0_1/src/ADC_8_bits_clk_wiz_0_0" "+incdir+../../../../SABER.gen/sources_1/bd/SABER/ipshared/ec67/hdl" "+incdir+../../../../SABER.gen/sources_1/bd/SABER/ipshared/86fe/hdl" "+incdir+../../../../SABER.gen/sources_1/bd/SABER/ipshared/f0b6/hdl/verilog" "+incdir+../../../../SABER.gen/sources_1/bd/SABER/ipshared/0127/hdl/verilog" "+incdir+D:/Programas/Vivado/2024.2/data/xilinx_vip/include" -l xilinx_vip -l xpm -l xil_defaultlib -l xlconstant_v1_1_9 -l xlslice_v1_0_4 -l axi_lite_ipif_v3_0_4 -l lib_cdc_v1_0_3 -l interrupt_control_v3_1_5 -l axi_gpio_v2_0_35 -l axi_infrastructure_v1_1_0 -l axi_vip_v1_1_19 -l processing_system7_vip_v1_0_21 -l proc_sys_reset_v5_0_16 -l smartconnect_v1_0 -l axi_register_slice_v2_1_33 \
"../../../../SABER.gen/sources_1/bd/SABER/ip/SABER_axi_smc_0/bd_0/ip/ip_20/sim/bd_2119_s00a2s_0.sv" \
"../../../../SABER.gen/sources_1/bd/SABER/ip/SABER_axi_smc_0/bd_0/ip/ip_21/sim/bd_2119_sarn_0.sv" \
"../../../../SABER.gen/sources_1/bd/SABER/ip/SABER_axi_smc_0/bd_0/ip/ip_22/sim/bd_2119_srn_0.sv" \
"../../../../SABER.gen/sources_1/bd/SABER/ip/SABER_axi_smc_0/bd_0/ip/ip_23/sim/bd_2119_sawn_0.sv" \
"../../../../SABER.gen/sources_1/bd/SABER/ip/SABER_axi_smc_0/bd_0/ip/ip_24/sim/bd_2119_swn_0.sv" \
"../../../../SABER.gen/sources_1/bd/SABER/ip/SABER_axi_smc_0/bd_0/ip/ip_25/sim/bd_2119_sbn_0.sv" \

vlog -work smartconnect_v1_0  -sv2k12 "+incdir+../../../../SABER.gen/sources_1/bd/SABER/ip/SABER_ADC_8_bits_0_1/src/ADC_8_bits_clk_wiz_0_0" "+incdir+../../../../SABER.gen/sources_1/bd/SABER/ipshared/ec67/hdl" "+incdir+../../../../SABER.gen/sources_1/bd/SABER/ipshared/86fe/hdl" "+incdir+../../../../SABER.gen/sources_1/bd/SABER/ipshared/f0b6/hdl/verilog" "+incdir+../../../../SABER.gen/sources_1/bd/SABER/ipshared/0127/hdl/verilog" "+incdir+D:/Programas/Vivado/2024.2/data/xilinx_vip/include" -l xilinx_vip -l xpm -l xil_defaultlib -l xlconstant_v1_1_9 -l xlslice_v1_0_4 -l axi_lite_ipif_v3_0_4 -l lib_cdc_v1_0_3 -l interrupt_control_v3_1_5 -l axi_gpio_v2_0_35 -l axi_infrastructure_v1_1_0 -l axi_vip_v1_1_19 -l processing_system7_vip_v1_0_21 -l proc_sys_reset_v5_0_16 -l smartconnect_v1_0 -l axi_register_slice_v2_1_33 \
"../../../../SABER.gen/sources_1/bd/SABER/ipshared/7f4f/hdl/sc_sc2axi_v1_0_vl_rfs.sv" \

vlog -work xil_defaultlib  -sv2k12 "+incdir+../../../../SABER.gen/sources_1/bd/SABER/ip/SABER_ADC_8_bits_0_1/src/ADC_8_bits_clk_wiz_0_0" "+incdir+../../../../SABER.gen/sources_1/bd/SABER/ipshared/ec67/hdl" "+incdir+../../../../SABER.gen/sources_1/bd/SABER/ipshared/86fe/hdl" "+incdir+../../../../SABER.gen/sources_1/bd/SABER/ipshared/f0b6/hdl/verilog" "+incdir+../../../../SABER.gen/sources_1/bd/SABER/ipshared/0127/hdl/verilog" "+incdir+D:/Programas/Vivado/2024.2/data/xilinx_vip/include" -l xilinx_vip -l xpm -l xil_defaultlib -l xlconstant_v1_1_9 -l xlslice_v1_0_4 -l axi_lite_ipif_v3_0_4 -l lib_cdc_v1_0_3 -l interrupt_control_v3_1_5 -l axi_gpio_v2_0_35 -l axi_infrastructure_v1_1_0 -l axi_vip_v1_1_19 -l processing_system7_vip_v1_0_21 -l proc_sys_reset_v5_0_16 -l smartconnect_v1_0 -l axi_register_slice_v2_1_33 \
"../../../../SABER.gen/sources_1/bd/SABER/ip/SABER_axi_smc_0/bd_0/ip/ip_26/sim/bd_2119_m00s2a_0.sv" \
"../../../../SABER.gen/sources_1/bd/SABER/ip/SABER_axi_smc_0/bd_0/ip/ip_27/sim/bd_2119_m00arn_0.sv" \
"../../../../SABER.gen/sources_1/bd/SABER/ip/SABER_axi_smc_0/bd_0/ip/ip_28/sim/bd_2119_m00rn_0.sv" \
"../../../../SABER.gen/sources_1/bd/SABER/ip/SABER_axi_smc_0/bd_0/ip/ip_29/sim/bd_2119_m00awn_0.sv" \
"../../../../SABER.gen/sources_1/bd/SABER/ip/SABER_axi_smc_0/bd_0/ip/ip_30/sim/bd_2119_m00wn_0.sv" \
"../../../../SABER.gen/sources_1/bd/SABER/ip/SABER_axi_smc_0/bd_0/ip/ip_31/sim/bd_2119_m00bn_0.sv" \

vlog -work smartconnect_v1_0  -sv2k12 "+incdir+../../../../SABER.gen/sources_1/bd/SABER/ip/SABER_ADC_8_bits_0_1/src/ADC_8_bits_clk_wiz_0_0" "+incdir+../../../../SABER.gen/sources_1/bd/SABER/ipshared/ec67/hdl" "+incdir+../../../../SABER.gen/sources_1/bd/SABER/ipshared/86fe/hdl" "+incdir+../../../../SABER.gen/sources_1/bd/SABER/ipshared/f0b6/hdl/verilog" "+incdir+../../../../SABER.gen/sources_1/bd/SABER/ipshared/0127/hdl/verilog" "+incdir+D:/Programas/Vivado/2024.2/data/xilinx_vip/include" -l xilinx_vip -l xpm -l xil_defaultlib -l xlconstant_v1_1_9 -l xlslice_v1_0_4 -l axi_lite_ipif_v3_0_4 -l lib_cdc_v1_0_3 -l interrupt_control_v3_1_5 -l axi_gpio_v2_0_35 -l axi_infrastructure_v1_1_0 -l axi_vip_v1_1_19 -l processing_system7_vip_v1_0_21 -l proc_sys_reset_v5_0_16 -l smartconnect_v1_0 -l axi_register_slice_v2_1_33 \
"../../../../SABER.gen/sources_1/bd/SABER/ipshared/37bc/hdl/sc_exit_v1_0_vl_rfs.sv" \

vlog -work xil_defaultlib  -sv2k12 "+incdir+../../../../SABER.gen/sources_1/bd/SABER/ip/SABER_ADC_8_bits_0_1/src/ADC_8_bits_clk_wiz_0_0" "+incdir+../../../../SABER.gen/sources_1/bd/SABER/ipshared/ec67/hdl" "+incdir+../../../../SABER.gen/sources_1/bd/SABER/ipshared/86fe/hdl" "+incdir+../../../../SABER.gen/sources_1/bd/SABER/ipshared/f0b6/hdl/verilog" "+incdir+../../../../SABER.gen/sources_1/bd/SABER/ipshared/0127/hdl/verilog" "+incdir+D:/Programas/Vivado/2024.2/data/xilinx_vip/include" -l xilinx_vip -l xpm -l xil_defaultlib -l xlconstant_v1_1_9 -l xlslice_v1_0_4 -l axi_lite_ipif_v3_0_4 -l lib_cdc_v1_0_3 -l interrupt_control_v3_1_5 -l axi_gpio_v2_0_35 -l axi_infrastructure_v1_1_0 -l axi_vip_v1_1_19 -l processing_system7_vip_v1_0_21 -l proc_sys_reset_v5_0_16 -l smartconnect_v1_0 -l axi_register_slice_v2_1_33 \
"../../../../SABER.gen/sources_1/bd/SABER/ip/SABER_axi_smc_0/bd_0/ip/ip_32/sim/bd_2119_m00e_0.sv" \
"../../../../SABER.gen/sources_1/bd/SABER/ip/SABER_axi_smc_0/bd_0/ip/ip_33/sim/bd_2119_m01s2a_0.sv" \
"../../../../SABER.gen/sources_1/bd/SABER/ip/SABER_axi_smc_0/bd_0/ip/ip_34/sim/bd_2119_m01arn_0.sv" \
"../../../../SABER.gen/sources_1/bd/SABER/ip/SABER_axi_smc_0/bd_0/ip/ip_35/sim/bd_2119_m01rn_0.sv" \
"../../../../SABER.gen/sources_1/bd/SABER/ip/SABER_axi_smc_0/bd_0/ip/ip_36/sim/bd_2119_m01awn_0.sv" \
"../../../../SABER.gen/sources_1/bd/SABER/ip/SABER_axi_smc_0/bd_0/ip/ip_37/sim/bd_2119_m01wn_0.sv" \
"../../../../SABER.gen/sources_1/bd/SABER/ip/SABER_axi_smc_0/bd_0/ip/ip_38/sim/bd_2119_m01bn_0.sv" \
"../../../../SABER.gen/sources_1/bd/SABER/ip/SABER_axi_smc_0/bd_0/ip/ip_39/sim/bd_2119_m01e_0.sv" \

vlog -work axi_register_slice_v2_1_33  -v2k5 "+incdir+../../../../SABER.gen/sources_1/bd/SABER/ip/SABER_ADC_8_bits_0_1/src/ADC_8_bits_clk_wiz_0_0" "+incdir+../../../../SABER.gen/sources_1/bd/SABER/ipshared/ec67/hdl" "+incdir+../../../../SABER.gen/sources_1/bd/SABER/ipshared/86fe/hdl" "+incdir+../../../../SABER.gen/sources_1/bd/SABER/ipshared/f0b6/hdl/verilog" "+incdir+../../../../SABER.gen/sources_1/bd/SABER/ipshared/0127/hdl/verilog" "+incdir+D:/Programas/Vivado/2024.2/data/xilinx_vip/include" -l xilinx_vip -l xpm -l xil_defaultlib -l xlconstant_v1_1_9 -l xlslice_v1_0_4 -l axi_lite_ipif_v3_0_4 -l lib_cdc_v1_0_3 -l interrupt_control_v3_1_5 -l axi_gpio_v2_0_35 -l axi_infrastructure_v1_1_0 -l axi_vip_v1_1_19 -l processing_system7_vip_v1_0_21 -l proc_sys_reset_v5_0_16 -l smartconnect_v1_0 -l axi_register_slice_v2_1_33 \
"../../../../SABER.gen/sources_1/bd/SABER/ipshared/3ee4/hdl/axi_register_slice_v2_1_vl_rfs.v" \

vlog -work xil_defaultlib  -v2k5 "+incdir+../../../../SABER.gen/sources_1/bd/SABER/ip/SABER_ADC_8_bits_0_1/src/ADC_8_bits_clk_wiz_0_0" "+incdir+../../../../SABER.gen/sources_1/bd/SABER/ipshared/ec67/hdl" "+incdir+../../../../SABER.gen/sources_1/bd/SABER/ipshared/86fe/hdl" "+incdir+../../../../SABER.gen/sources_1/bd/SABER/ipshared/f0b6/hdl/verilog" "+incdir+../../../../SABER.gen/sources_1/bd/SABER/ipshared/0127/hdl/verilog" "+incdir+D:/Programas/Vivado/2024.2/data/xilinx_vip/include" -l xilinx_vip -l xpm -l xil_defaultlib -l xlconstant_v1_1_9 -l xlslice_v1_0_4 -l axi_lite_ipif_v3_0_4 -l lib_cdc_v1_0_3 -l interrupt_control_v3_1_5 -l axi_gpio_v2_0_35 -l axi_infrastructure_v1_1_0 -l axi_vip_v1_1_19 -l processing_system7_vip_v1_0_21 -l proc_sys_reset_v5_0_16 -l smartconnect_v1_0 -l axi_register_slice_v2_1_33 \
"../../../../SABER.gen/sources_1/bd/SABER/ip/SABER_axi_smc_0/sim/SABER_axi_smc_0.v" \
"../../../../SABER.gen/sources_1/bd/SABER/sim/SABER.v" \

vlog -work xil_defaultlib  -sv2k12 "+incdir+../../../../SABER.gen/sources_1/bd/SABER/ip/SABER_ADC_8_bits_0_1/src/ADC_8_bits_clk_wiz_0_0" "+incdir+../../../../SABER.gen/sources_1/bd/SABER/ipshared/ec67/hdl" "+incdir+../../../../SABER.gen/sources_1/bd/SABER/ipshared/86fe/hdl" "+incdir+../../../../SABER.gen/sources_1/bd/SABER/ipshared/f0b6/hdl/verilog" "+incdir+../../../../SABER.gen/sources_1/bd/SABER/ipshared/0127/hdl/verilog" "+incdir+D:/Programas/Vivado/2024.2/data/xilinx_vip/include" -l xilinx_vip -l xpm -l xil_defaultlib -l xlconstant_v1_1_9 -l xlslice_v1_0_4 -l axi_lite_ipif_v3_0_4 -l lib_cdc_v1_0_3 -l interrupt_control_v3_1_5 -l axi_gpio_v2_0_35 -l axi_infrastructure_v1_1_0 -l axi_vip_v1_1_19 -l processing_system7_vip_v1_0_21 -l proc_sys_reset_v5_0_16 -l smartconnect_v1_0 -l axi_register_slice_v2_1_33 \
"../../../../SABER.gen/sources_1/bd/SABER/ipshared/e8fc/src/ascon_pack.sv" \
"../../../../SABER.gen/sources_1/bd/SABER/ipshared/e8fc/src/Pc.sv" \
"../../../../SABER.gen/sources_1/bd/SABER/ipshared/e8fc/src/Permutation.sv" \
"../../../../SABER.gen/sources_1/bd/SABER/ipshared/e8fc/src/Pl.sv" \
"../../../../SABER.gen/sources_1/bd/SABER/ipshared/e8fc/src/Ps.sv" \
"../../../../SABER.gen/sources_1/bd/SABER/ipshared/e8fc/src/Sbox.sv" \
"../../../../SABER.gen/sources_1/bd/SABER/ipshared/e8fc/src/ad_reg.sv" \
"../../../../SABER.gen/sources_1/bd/SABER/ipshared/e8fc/src/ascon.sv" \
"../../../../SABER.gen/sources_1/bd/SABER/ipshared/e8fc/src/cipher_reg.sv" \
"../../../../SABER.gen/sources_1/bd/SABER/ipshared/e8fc/src/compteur_double_init.sv" \
"../../../../SABER.gen/sources_1/bd/SABER/ipshared/e8fc/src/counter_128.sv" \
"../../../../SABER.gen/sources_1/bd/SABER/ipshared/e8fc/src/data_reg.sv" \
"../../../../SABER.gen/sources_1/bd/SABER/ipshared/e8fc/src/drive_ascon.sv" \
"../../../../SABER.gen/sources_1/bd/SABER/ipshared/e8fc/src/fsm_SABER.sv" \
"../../../../SABER.gen/sources_1/bd/SABER/ipshared/e8fc/src/fsm_moore.sv" \
"../../../../SABER.gen/sources_1/bd/SABER/ipshared/e8fc/src/key_reg.sv" \
"../../../../SABER.gen/sources_1/bd/SABER/ipshared/e8fc/src/lfsr_128.sv" \
"../../../../SABER.gen/sources_1/bd/SABER/ipshared/e8fc/src/mux_state.sv" \
"../../../../SABER.gen/sources_1/bd/SABER/ipshared/e8fc/src/nonce_gen.sv" \
"../../../../SABER.gen/sources_1/bd/SABER/ipshared/e8fc/src/nonce_reg.sv" \
"../../../../SABER.gen/sources_1/bd/SABER/ipshared/e8fc/src/register_w_en.sv" \
"../../../../SABER.gen/sources_1/bd/SABER/ipshared/e8fc/src/state_register_w_en.sv" \
"../../../../SABER.gen/sources_1/bd/SABER/ipshared/e8fc/src/xor_begin_perm.sv" \
"../../../../SABER.gen/sources_1/bd/SABER/ipshared/e8fc/src/xor_end_perm.sv" \
"../../../../SABER.gen/sources_1/bd/SABER/ipshared/e8fc/src/encryptor_system.sv" \
"../../../../SABER.gen/sources_1/bd/SABER/ip/SABER_encryptor_system_0_1/sim/SABER_encryptor_system_0_1.sv" \

vlog -work xil_defaultlib \
"glbl.v"

