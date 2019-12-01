//***********************************************//
//Title: Final Project
//Module : Addess Parser
//Description: Parse the address and get the tag,
//		Set, Byte address, 
//
//
//**********************************************//

module #(parameter ADDRESS_LIMIT = 512) address_parser();
input [ADDRESS_LIMIT-1:0]address;
output [6:0]byte_select;
output [14:0]set;
output [10:0]tag;


assign byte_select = address[5:0];
assign set = address[20:6];
assign tag = address[31:21];


endmodule