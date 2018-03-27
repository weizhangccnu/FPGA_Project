#!/usr/bin/env python
# -*- coding: utf-8 -*-
import copy
import time
import struct
import socket
from command_interpret import *
'''
@author: Wei Zhang
@date: 2018-03-20
Control module for testing mig ip core.
'''
hostname = '192.168.2.3'					#FPGA IP address
port = 1024									#port number
#--------------------------------------------------------------------------#
## DDR3 write data to external device
# @param[in] wr_wrap: wrap address 
# @param[in] wr_begin_addr: write data begin address
# @param[in] post_trigger_addr: post trigger address
def write_data_into_ddr3(wr_wrap, wr_begin_addr, post_trigger_addr):
    # writing begin address and wrap_around
    val = (wr_wrap << 28) + wr_begin_addr
    cmd_interpret.write_config_reg(8, 0xffff & val)
    cmd_interpret.write_config_reg(9, 0xffff & (val >> 16))
    # post trigger address  
    cmd_interpret.write_config_reg(10, 0xffff & post_trigger_addr)
    cmd_interpret.write_config_reg(11, 0xffff & (post_trigger_addr >> 16))
#--------------------------------------------------------------------------#
## DDR3 read data from fifo to ethernet
def read_data_from_ddr3(rd_begin_addr):
    cmd_interpret.write_config_reg(12, 0xffff & rd_begin_addr)
    cmd_interpret.write_config_reg(13, 0xffff & (rd_begin_addr >> 16))
    cmd_interpret.write_pulse_reg(0x0020)           # reading start 
#--------------------------------------------------------------------------#
## main function
def main():
    cmd_interpret.write_pulse_reg(0x0040)           # reset ddr3 data fifo
    time.sleep(0.1)
    write_data_into_ddr3(1, 0x0000000, 0x1000000)   # set write begin address and post trigger address and wrap around
    cmd_interpret.write_pulse_reg(0x0008)           # writing start 
    #time.sleep(5)
    cmd_interpret.write_pulse_reg(0x0010)           # writing stop 
    time.sleep(10)
    read_data_from_ddr3(0x2000000)                  # set read begin address

    for i in xrange(100):
        cmd_interpret.read_data_fifo(50000)         # reading start 
    #print "Ok!"
#--------------------------------------------------------------------------#
## if statement
if __name__ == "__main__":
	s = socket.socket(socket.AF_INET, socket.SOCK_STREAM)	#initial socket
	s.connect((hostname, port))								#connect socket
	cmd_interpret = command_interpret(s)					#Class instance	
	main()													#execute main function	
	s.close()												#close socket
