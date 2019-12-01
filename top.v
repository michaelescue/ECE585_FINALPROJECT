
//***********************************************//
//Title: Final Project
//Module : Top
//Description: Read the incoming trace file which 
//	is analogous to a processor and higher level cache
//
//
//**********************************************//

module top();

parameter OPCODE_SIZE = 2;
parameter ADDRESS_LIMIT = 512;
 
wire [OPCODE_SIZE:0]opcode;
wire [ADDRESS_LIMIT:0]address;

parser #(OPCODE_SIZE, ADDRESS_LIMIT) p1(.opcode(opcode), .address(address));
LLC #(OPCODE_SIZE,ADDRESS_LIMIT) l1(.opcode(opcode),.address(address));


 
endmodule