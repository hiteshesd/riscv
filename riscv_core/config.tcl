set ::env(DESIGN_NAME) riscv_core
set ::env(VERILOG_FILES) "dir::src/*.v"
set ::env(CLOCK_PORT) "clk"
set ::env(CLOCK_PERIOD) 50
set ::env(FP_SIZING) absolute
set ::env(DIE_AREA) "0 0 800 800"
set ::env(PL_TARGET_DENSITY) 0.45