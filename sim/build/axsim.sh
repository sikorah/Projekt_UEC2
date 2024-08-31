#!/bin/bash

export LD_LIBRARY_PATH=${LD_LIBRARY_PATH}:/home_local/Xilinx/Vivado/2021.2/data/../lib/lnx64.o:/home_local/Xilinx/Vivado/2021.2/data/../lib/lnx64.o/Default

xsim.dir/top_vga_tb/axsim $@

if [ $? -ne 0 ] ; then
  echo "FATAL ERROR: Simulation exited unexpectantly"
fi
