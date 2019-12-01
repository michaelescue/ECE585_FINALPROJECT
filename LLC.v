//**********************************************************************//
//Title: Final Project							
//Module : FSM								
//Description: Finite state machine to to transition between the 
//states of MESI protocol						
//								
//									
//**********************************************************************//
//Bus Operation types
`define READ 1 /* Bus Read */
`define WRITE 2 /* Bus Write */
`define INVALIDATE 3 /* Bus Invalidate */
`define RWIM 4 /* Bus Read With Intent to Modify */
/*Snoop Result types*/
`define NOHIT 0 /* No hit */
`define HIT 1 /* Hit */
`define HITM 2 /* Hit to modified line */
/* L2 to L1 message types*/
`define GETLINE 1 /* Request data for modified line in L1 */
`define SENDLINE 2 /* Send requested cache line to L1 */
`define INVALIDATELINE 3 /* Invalidate a line in L1 */
`define EVICTLINE 4 /* Evict a line from L1 */

module LLC #(parameter OPCODE_SIZE = 2,
	 parameter ADDRESS_LIMIT = 512) 
	
	(clock,reset,opcode,address);

input [OPCODE_SIZE-1:0]opcode;
input [ADDRESS_LIMIT-1:0]address;
input clock;
input reset;

parameter CACHE_SIZE 	= 512;

wire [OPCODE_SIZE:0]opcode;
wire [ADDRESS_LIMIT:0]address;
wire [6:0]byte_select;
wire [14:0]set;
wire [10:0]tag;

//cache block
reg [14:0]cache_tag;
reg [CACHE_SIZE-1:0]cache_data;
reg valid;
reg dirty;

reg [5:0]cycle;
reg [5:0]cache_read;
reg [5:0]cache_write;
reg [5:0]cache_hit;
reg [5:0]cache_miss;
reg [5:0]cache_hit_ratio;
reg write_enable;
reg load;
integer SnoopResult;
integer DRAM_data;


localparam
	Init 	  = 0000000001,
	PrRd_data = 0000000010,
	PrWr_data = 0000000100,
	PrRd_inst = 0000001000,
	BusUpgr   = 0000010000,
	BusRd 	  = 0000100000,
	BusWr 	  = 0001000000,
	BusRdX 	  = 0010000000,
	Clear 	  = 0100000000,
	Print 	  = 1000000000;
	
reg [9:0]state,nextstate;




//parsing the address to obtain the 8 way cache for LLC
assign byte_select = address[5:0];
assign set = address[20:6];
assign tag = address[31:21];


cache c1(.address(address),.write_enable(write_enable),.load(load));

/*
initial begin
	cycle = 0;
	cache_read = 0;
	cache_write = 0;
	cache_hit = 0;
	cache_miss = 0;
	cache_hit_ratio= 0;
end
*/
always@(posedge clock)
begin
	if(reset)
		state <= Init;
	else
		state <= nextstate;
end


//NEXTSTATE LOGIC
always@(state)
begin
	case (state)
	Init: begin
		if     (opcode == 0)
			nextstate = PrRd_data;
		else if(opcode == 1)
			nextstate = PrWr_data;
		else if(opcode == 2)
			nextstate = PrRd_inst;
		else if(opcode == 3)
			nextstate = BusUpgr;
		else if(opcode == 4)
			nextstate = BusRd;
		else if(opcode == 5)
			nextstate = BusWr;
		else if(opcode == 6)
			nextstate = BusRdX;
		else if(opcode == 7)
			nextstate = Clear;
		else if(opcode == 8)
			nextstate = Clear;
		else if(opcode == 9)
			nextstate = Print;
		else 
			nextstate = Init;
	end

	PrRd_data:
		nextstate = Init;
	PrWr_data:
		nextstate = Init;
	PrRd_inst:
		nextstate = Init;
	BusUpgr:
		nextstate = Init;
	BusRd:
		nextstate = Init;
	BusWr:
		nextstate = Init;
	BusRdX:
		nextstate = Init;
	Clear:
		nextstate = Init;
	Print:	
		nextstate = Init;
	endcase
end

//OUTPUT
always@(state)
begin
	case(state)
	Init:
		begin
			//no o/p to be set here
		end
	PrRd_data: //read request from L1 data cache
	begin
		//Hit
		cache_read = cache_read+1;
		if(tag == cache_tag) begin 				//how to get this value?
			if(valid == 1) begin
				cache_hit = cache_hit + 1;
				$display("Exclusive or Shared state");
				MessageToCache(`SENDLINE, address);
			end
		end
		//Miss
		else begin
			cache_miss = cache_miss + 1;
			$display("Invalid State");
			SnoopResult = GetSnoopResult(address);
			BusOperation(READ,address,SnoopResult);
			if(SnoopResult == 0) begin
				$display("SnoopResult: No Hit");
				DRAM_data = GetFromDRAM(address);
				MessageToCache(`SENDLINE, address);
				valid = 1;
				dirty = 0;
			end
			else if(SnoopResult == 1) begin
				$display("SnoopResult: Hit");
				DRAM_data = GetFromDRAM(address);
				MessageToCache(`SENDLINE, address);
				valid = 1;
				dirty = 0;
			end
			else if(SnoopResult == 2)begin
				$display("SnoopResult: HitM");
				DRAM_data = GetFromCache(address);
				MessageToCache(`SENDLINE,address);
				valid = 1;
				dirty = 0;
			end
		end
	end
	PrWr_data: //write request from L1 data cache
	begin
		//Hit
		cycle = cycle + 1;
		cache_write = cache_write + 1;
		if(tag == cache_tag) begin
			if(dirty == 1)	begin
				cache_hit = cache_hit + 1;
				$display("Modified");
				PutToDRAM(address);
				GetFromDRAM(address);
				MessageToCache(SENDLINE,address);
			end	
			else begin
				$display("Exclusive or Shared State");
				MessageToCache(SENDLINE,address);
			end
		end	
		//Miss
		else begin
			//?? do we need to check for dirty bit here
			cache_miss = cache_miss + 1;
			$display("Invalid State");
			SnoopResult = GetSnoopResult(address);
			BusOperation(RWIM,address,SnoopResult);
			if(SnoopResult == 0) begin
				$display("SnoopResult: No Hit");
				DRAM_data = GetFromDRAM(address);
				MessageToCache(SENDLINE, address);
				valid = 1;
			end
			else if(SnoopResult == 1) begin
				$display("SnoopResult: Hit");
				DRAM_data = GetFromCache(address);
				MessageToCache(SENDLINE,address);
				valid = 1;
			end
			else if(SnoopResult == 2) begin
				$display("SnoopResult: HitM");
				DRAM_data = GetFromCache(address);
				MessageToCache(SENDLINE,address);
				valid = 1;
			end
		end
	end
	PrRd_inst:	//read request from L1 instruction cache
	begin
		//Hit
		cache_read = cache_read + 1;
		if(tag == cache_tag) begin
			cache_hit = cache_hit + 1;
			$display("Exclusive or shared state");
			MessageToCache(SENDLINE,address);
		end
		else begin
			cache_miss = cache_miss + 1;
			$display("Invalid State");
			SnoopResult = GetSnoopResult(address);
			BusOperation(RWIM,address,SnoopResult);
			if(SnoopResult == 0) begin
				$display("SnoopResult: No Hit");
				DRAM_data = GetFromDRAM(address);
				MessageToCache(SENDLINE,address);
				valid = 1;
			end
			else if(SnoopResult == 2) begin
				$display("SnoopResult: Hit");
				DRAM_data = GetFromDRAM(address);
				MessageToCache(SENDLINE,address);
				valid = 1;
			end
		end
	end
	BusUpgr://Snooped Invalidate Command
	begin
		//Hit
		if(tag == cache_tag) begin
			cache_hit = cache_hit + 1;
			$display("Shared State");
			MessageToCache(RWIM,address,SnoopResult);
		end
	end
	BusRd:	//snooped read request
	begin
		//Hit
		if(tag == cache_tag) begin
			if(dirty == 1)
				cache_hit = cache_hit + 1;
				cache_read = cache_read + 1;
				$display("Modified State");
				PutToDRAM(address);
				/*?? how to implement state transition from M->I*/
		end
	end
	BusWr: //snooped write request
	begin
		if(tag == cache_tag) begin
			cache_hit = cache_hit + 1;
			cache_write = cache_write + 1;
			$display("Modified state");
			PutToDRAM(address);
			/*V->I*/
		end
	end
	BusRdX: //Bus Read with a intension to modify
	begin

		if(tag == cache_tag) begin
			if(dirty == 1) begin
				cache_hit = cache_hit + 1;
				cache_write = cache_write + 1;
				$display("Modified");
				PutToDRAM(address);
				//M->I
			end
		end
		else if(tag == cache_tag) begin
			$display("shared");
			//S->I
		end
	end
	Clear:
	begin
		//clear the DRAM
		PutToDRAM(CLEAR);
	end
	Print:
	begin
		//print the contents and state of each cache line
		$display("Number of Cache Reads: %d",cache_read);
		$display("Number of Cache Writes: %d",cache_write);
		$display("Number of Cache Hits: %d",);
		$display("Number of Cache Miss: %d",);
		$display("Cache Ratio: %d",);
	end
	endcase
	
end

endmodule


function MessageToCache(string Message,integer addr)
begin
`ifndef SILENT
	$display("L2: %d  %h",Message,addr);
`endif
end
endfunction 

function GetSnoopResult(integer addr)
begin
	


	reg [1:0] 	hitlineP1, hitlineP2, hitlineP3;
	reg		hit, hitm;

	hitlineP1 = SnoopResultP1(addr);	// Return hit, hitm, or nohit
	
	hitlineP2 = SnoopResultP2(addr);		// Return hit, hitm, or nohit

	hitlineP3 = SnoopResultP3(addr);	// Return hit, hitm, or nohit

	hit = {hitlineP1[0], hitlineP2[0], hitlineP3[0]};
	hitm = {hitlineP1[1], hitlineP2[1], hitlineP3[1]};

	if({hitm,hit} == 0)		GetSnoopResult = `NOHIT;
	else if({hitm,hit} == 1)	GetSnoopResult = `HIT;
	else if({hitm,hit} == 2)	GetSnoopResult = `HITM;
	else begin
		`ifndef SILENT
		$display("GetSnoopResult - ERROR (or dont care).");
		`endif
	end
	

end
endfunction

function BusOperation(string BusOp,integer addr,integer SnoopResult)
begin
`ifndef SILENT
	$display("BusOperation: BusOp = %d, address = %h, Snoopresult=% ",Message,address,SnoopResult);
`endif
end
endfunction

function GetFromDRAM(integer addr)
begin
	
	GetFromDRAM = 1; /*send the value from Memory, temp given value = 1*/
end
endfunction


function GetFromCache(integer addr) //getting the value from other cache if they have a modified or shared copy
begin
	
	GetFromCache = 1;// temporary value
end
endfunction

function PutToDRAM(integer addr)
begin
	PutToDRAM = 1; 
end
endfunction

function SnoopResultP1(integer addr)
begin
	// addr will be compared to look up table and hit, hitm, or nohit returned.
end
endfunction

function SnoopResultP2(integer addr)
begin
	// addr will be compared to look up table and hit, hitm, or nohit returned.
end
endfunction

function SnoopResultP3(integer addr)
begin
	// addr will be compared to look up table and hit, hitm, or nohit returned.
end
endfunction


