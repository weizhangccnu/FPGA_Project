#!/usr/bin/env python
# -*- coding:utf-8 -*-
import os
import sys
import visa
import time
#----------------------------------------------------------#
def main():
	rm = visa.ResourceManager()
	print rm.list_resources()
	inst = rm.open_resource('GPIB0::7::INSTR')
	print inst.query("*IDN?")

	print inst.query(":ACQuire:LTESt?")
	print inst.write(":ACQuire:LTESt ALL")

	inst.write(":ACQuire:RUNTil PATTerns,10")

	print inst.query(":ACQuire:SSCReen?")
	print inst.write(":ACQuire:SSCReen DISK")
	time.sleep(1)
	print inst.write(":ACQuire:SSCReen:AREA SCReen")
	time.sleep(1)
	print inst.query(":ACQuire:SSCReen:IMAGe?")
	print inst.write(":ACQuire:SSCReen:IMAGe INVert")
	time.sleep(1)

	print "Ok!"
#----------------------------------------------------------#
if __name__ == "__main__":
	main()
