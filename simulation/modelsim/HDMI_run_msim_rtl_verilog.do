transcript on
if ![file isdirectory HDMI_iputf_libs] {
	file mkdir HDMI_iputf_libs
}

if {[file exists rtl_work]} {
	vdel -lib rtl_work -all
}
vlib rtl_work
vmap work rtl_work

###### Libraries for IPUTF cores 
###### End libraries for IPUTF cores 
###### MIF file copy and HDL compilation commands for IPUTF cores 


vlog "/home/kamal/GitHub/HDL/pll/pll_sim/pll.vo"

vlog -vlog01compat -work work +incdir+/home/kamal/GitHub/HDL {/home/kamal/GitHub/HDL/vga_generator.v}
vlog -vlog01compat -work work +incdir+/home/kamal/GitHub/HDL {/home/kamal/GitHub/HDL/I2C_WRITE_WDATA.v}
vlog -vlog01compat -work work +incdir+/home/kamal/GitHub/HDL {/home/kamal/GitHub/HDL/I2C_HDMI_Config.v}
vlog -vlog01compat -work work +incdir+/home/kamal/GitHub/HDL {/home/kamal/GitHub/HDL/I2C_Controller.v}
vlog -vlog01compat -work work +incdir+/home/kamal/GitHub/HDL {/home/kamal/GitHub/HDL/HDMI.v}

