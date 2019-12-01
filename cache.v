
module cache(address,write_enable,load);

wire [6:0]byte_select;
wire [14:0]set;
wire [10:0]tag;


assign byte_select = address[5:0];
assign set = address[20:6];
assign tag = address[31:21];


input [14:0]set;
input write_enable;//use if required
input load;

output reg valid;
output reg dirty;
output reg [11:0]tag;

reg [14:0]way;

always@(*)
begin
	if(write_enable)
	begin	
		if(load)
		begin
			way[set][0] = '1;
			way[set][1] = '1;
			way[set][2] = ; 
		end
	end
	else
	begin
		valid = way[set][0];
		dirty = way[set][1];
		tag = way[set][2]; 
	end
end


endmodule