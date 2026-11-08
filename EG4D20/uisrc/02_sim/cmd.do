## part 1: create lib
vlib work

## part 2: load rtl
vlog -timescale 1ps/1ps -f   compile.f                                                                      
                                             
## part 3: sim
vsim -L D:/ModelSim_SE/anlogic/eg4d -gui -novopt work.tb_key
#vsim -voptargs=+acc work.tb_key         

## part 4: add wave
#do wave.do
add wave *

## part 5: show ui
view wave
view structure
view signals

## part 6: run sim
#run -all
run 1000ns