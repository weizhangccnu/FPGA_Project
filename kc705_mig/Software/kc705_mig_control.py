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
def main():
    print "1234"
    while 1:
        cmd_interpret.write_config_reg(0, 0xaaaa)
        time.sleep(1)
        print "Output 0xaaaa"
        cmd_interpret.write_config_reg(0, 0x5555)
        time.sleep(1)
        print "Output 0x5555"
#--------------------------------------------------------------------------#
if __name__ == "__main__":
	s = socket.socket(socket.AF_INET, socket.SOCK_STREAM)	#initial socket
	s.connect((hostname, port))								#connect socket
	cmd_interpret = command_interpret(s)					#Class instance	
	main()													#execute main function	
	s.close()												#close socket
