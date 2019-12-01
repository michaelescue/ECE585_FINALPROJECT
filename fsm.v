
//**********************************************************************//
//Title: Final Project							
//Module : FSM								
//Description: Finite state machine to to transition between the states of MESI protocol						
//								
//									
//**********************************************************************//


module FSM();

parameter OPCODE_SIZE 2
parameter ADDRESS_LIMIT 512

input  [OPCODE_SIZE:0]opcode;
wire [ADDRESS_LIMIT:0]address;

endmodule