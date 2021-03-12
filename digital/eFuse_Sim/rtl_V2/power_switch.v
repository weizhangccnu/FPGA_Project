//***********************************************************//
// module name: power_switch.v 
// author: Wei Zhang
// Date: March 11th, 2021
// Description: This module is used to descript eFuse power switch behavior.
//              
//***********************************************************//
`timescale 1ns/1ps
module power_switch(
	input VDD, 				// 1.2 V input voltage
	input VDDQ,				// 2.5 V input voltage
	input EN,				// Enable power switch
	input RAMPENA, 			// RAMPENA output of 2.5 V voltage
	input SHORT,			// SHORT signal tied the output to ground
	output VDDQ_2V5			// 2.5 V power output
);

assign VDDQ_2V5 = (VDD & VDDQ) & (!SHORT) & (EN & RAMPENA);
	
endmodule

